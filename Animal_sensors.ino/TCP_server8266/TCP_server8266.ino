


#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>


// Hardcode WiFi parameters
char* ssid = "Dog_temp";
char* password = "12345678";


// Assign pin for the temperature sensor
#define ONE_WIRE_BUS A0
#define BUFFER_SIZE 6
// Setup for the temperature sensor
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

IPAddress ip(192, 168, 137, 33);
IPAddress gateway(192, 168, 137, 0); // set gateway to match your network
IPAddress subnet(255, 255, 255, 0); // set subnet mask to match your

// Start a TCP Server on port 80
WiFiServer server(80);

unsigned long start;
unsigned long current;
byte cmd = 2;
uint8_t wifi_data[BUFFER_SIZE];
uint16_t adcVal;
unsigned long time_intv;

void setup()
{
  Serial.begin(115200);
  WiFi.config(ip, gateway, subnet);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");
  //Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  //the sensors giving us 85 every time we restart the chip
  sensors.requestTemperatures();
  sensors.getTempCByIndex(0);
  // Start the TCP server

  server.begin();
  pinMode(LED_BUILTIN , OUTPUT);
}

void loop()
{
  // listen for incoming clients
  digitalWrite(LED_BUILTIN , HIGH);
  WiFiClient client = server.available();
  if (client) 
  {
    Serial.println("Client connected");

    start = millis();
    current = millis();
    cmd = 2;
    digitalWrite(LED_BUILTIN , LOW);
    while (client.connected())
    {
      
      if (client.available() && cmd == 2)
      {
        Serial.println("Command incoming");
        cmd = client.read();
      }
      else if (cmd == 1)
      {
        sensors.begin();
        sensors.requestTemperatures();
        client.println(sensors.getTempCByIndex(0));
      }
      else if (cmd == 0)
      {
        for (int i = 0; i < BUFFER_SIZE; i = i + 6)
        {
          current = millis();
          time_intv = current - start;
          adcVal = analogRead(A0);
          wifi_data[i] = lowByte(adcVal);
          wifi_data[i + 1] = highByte(adcVal);
          wifi_data[i + 2] = time_intv & 0xFF;
          wifi_data[i + 3] = ((time_intv >> 8) & 0xFF);
          wifi_data[i + 4] = ((time_intv >> 16) & 0xFF);
          wifi_data[i + 5] = ((time_intv >> 24) & 0xFF);
          /*Serial.println(adcVal);
          Serial.println(time_intv);
          Serial.println(wifi_data[i]);
          Serial.println(wifi_data[i + 1]);
          Serial.println(wifi_data[i + 2]);
          Serial.println(wifi_data[i + 3]);
          Serial.println(wifi_data[i + 4]);
          Serial.println(wifi_data[i + 5]);*/
        }
        

        client.write((uint8*)&wifi_data, BUFFER_SIZE );
      }
      delay(5);
    }
    client.flush();
    client.stop();
    Serial.println("Client Disconnected");

  }
  digitalWrite(LED_BUILTIN , LOW);
}
