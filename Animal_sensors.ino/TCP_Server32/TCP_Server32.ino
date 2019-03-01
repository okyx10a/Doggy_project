
#include <WiFi.h>
#include <WiFiClient.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <esp32-hal-adc.h>


// Hardcode WiFi parameters as this isn't going to be moving around.
const char* ssid = "Dog_temp";
const char* password = "12345678";



// Assign pin for the temperature sensor
#define ONE_WIRE_BUS A0
#define BUFFER_SIZE 1
// Setup for the temperature sensor
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

IPAddress ip(192, 168, 137, 32);
IPAddress gateway(192, 168, 137, 1); // set gateway to match your network
IPAddress subnet(255, 255, 255, 0); // set subnet mask to match your

// Start a TCP Server on port 80
WiFiServer server(80);

unsigned long start;
unsigned long current;
byte cmd = 2;
uint8_t brea_data[BUFFER_SIZE*2];
uint8_t time_data[BUFFER_SIZE*4];
uint16_t adcVal;
unsigned long time_intv;


void setup() {
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

  // Start the TCP server
  adcAttachPin(A3);
  analogSetAttenuation(ADC_11db);
  sensors.begin();
  server.begin();
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13, HIGH);
  WiFiClient client = server.accept();

  if (client)
  {
    digitalWrite(13, LOW);
    Serial.println("Client connected");
    start = millis();
    current = millis();
    cmd = 2;
    

    while (client.connected())
    {
      if (client.available() && cmd == 2)
      {
        //Serial.println("Command incoming");
        cmd = client.read();
      }
      if (cmd == 1)
      {
        sensors.requestTemperatures();
        client.println(sensors.getTempCByIndex(0));
      }
      if (cmd == 0)
      {
        for (int i = 0; i < BUFFER_SIZE; i = i + 2)
        { 
          adcStart(A3);
          //delayMicroseconds(200);
          adcVal = adcEnd(A3);
          current = millis();
          time_intv = current - start;
          brea_data[i] = lowByte(adcVal);
          brea_data[i + 1] = highByte(adcVal);
          time_data[2*i] = time_intv & 0xFF;
          time_data[2*i + 1] = ((time_intv >> 8) & 0xFF);
          time_data[2*i + 2] = ((time_intv >> 16) & 0xFF);
          time_data[2*i + 3] = ((time_intv >> 24) & 0xFF);
          Serial.println(adcVal);
          Serial.println(time_intv);
          /*Serial.println(brea_data[i]);
          Serial.println(brea_data[i + 1]);
          Serial.println(time_data[2*i]);
          Serial.println(time_data[2*i + 1]);
          Serial.println(time_data[2*i + 2]);
          Serial.println(time_data[2*i + 3]);*/
        }
        

        client.write((uint8_t*)&brea_data, BUFFER_SIZE*2 );
        client.write((uint8_t*)&time_data, BUFFER_SIZE*4 );
      }
      delay(20);
    }
    client.stop();
    //Serial.println("Client Disconnected");
  }
  
  digitalWrite(13, LOW);
}
