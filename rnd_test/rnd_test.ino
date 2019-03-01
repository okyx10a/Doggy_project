


#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>


// Hardcode WiFi parameters as this isn't going to be moving around.
char* ssid = "Dog_temp";
char* password = "12345678";
byte cmd = 0;


// Assign pin for the temperature sensor
#define ONE_WIRE_BUS A0
// Setup for the temperature sensor
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

IPAddress ip(192, 168, 137, 33);
IPAddress gateway(192, 168, 137, 0); // set gateway to match your network
IPAddress subnet(255, 255, 255, 0); // set subnet mask to match your

// Start a TCP Server on port 80
WiFiServer server(80);

time_t start;
time_t current;

void setup()
{
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
  //the sensors giving us 85 every time we restart the chip
  sensors.requestTemperatures();
  sensors.getTempCByIndex(0);
  // Start the TCP server
  sensors.begin();
  server.begin();
}

void loop()
{
  // listen for incoming clients
  WiFiClient client = server.available();
  if (client) {
    Serial.println("Client connected");
    start = millis();
    while (client.connected()) {
      current = millis();
      client.print("Derp");
      client.print(",");
      client.print((current - start) / 1000.0);
      client.println();
    }
    client.flush();
    client.stop();
    Serial.println("Client Disconnected");
  }
  
}
