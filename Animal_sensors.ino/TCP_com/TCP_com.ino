
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
#define BUFFER_SIZE 256
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
String brea_data[BUFFER_SIZE];


void setup() {
  Serial.begin(115200);
  WiFi.config(ip, gateway, subnet);
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
  adcAttachPin(A2);
  analogSetAttenuation(ADC_11db);
  sensors.begin();
  server.begin();
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13, HIGH);
  WiFiClient client = server.available();
  Serial.println("Waiting for connection.");
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
        Serial.println("Command incoming");
        cmd = client.read();
      }
      if (cmd == 1)
      {
        sensors.requestTemperatures();
        client.println(sensors.getTempCByIndex(0));
      }
      else if (cmd == 0)
      {
        adcStart(A2);
        current = millis();
        client.print(adcEnd(A2));
        client.println();
        client.print(current - start);
        client.println();
      }
      else
      {
      }
      delay(10);
    }
    client.stop();
    Serial.println("Client Disconnected");
  }

  digitalWrite(13, LOW);
}
