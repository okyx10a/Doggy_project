/* DHTServer - ESP8266 Webserver with a DHT sensor as an input

   Based on ESP8266Webserver, DHTexample, and BlinkWithoutDelay (thank you)

   Version 1.0  5/3/2014  Version 1.0   Mike Barela for Adafruit Industries
*/
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <OneWire.h> 
#include <DallasTemperature.h>


// Assign pin for the temperature sensor
#define ONE_WIRE_BUS 2
// Setup for the temperature sensor
OneWire oneWire(ONE_WIRE_BUS); 
DallasTemperature sensors(&oneWire);

const char* ssid     = "Qiao";
const char* password = "zgmfx10a";

ESP8266WebServer server(80);
 


 
float temp_f;  // Values read from sensor
String webString="";     // String to display
// Generally, you should use "unsigned long" for variables that hold time
unsigned long previousMillis = 0;        // will store last temp was read
const long interval = 2000;              // interval at which to read sensor
 
void handle_root() {
  server.send(200, "text/plain", "Hello from the esp8266, read from /temp");
  delay(100);
}
 
void setup(void)
{
  // You can open the Arduino IDE Serial Monitor window to see what the code is doing
  Serial.begin(115200);  // Serial connection from ESP-01 via 3.3v console cable

  // Connect to WiFi network
  WiFi.begin(ssid, password);
  Serial.print("\n\r \n\rWorking to connect");

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
   
  server.on("/", handle_root);
  
  server.on("/temp", [](){  // if you add this subdirectory to your webserver call, you get text below :)
      sensors.requestTemperatures();
      temp_f =  sensors.getTempCByIndex(0);  
      webString="Temperature: "+String((int)temp_f)+" C";   // Arduino has a hard time with float to string
      server.send(200, "text/plain", webString);            // send to someones browser when asked
  });

  sensors.begin();
  server.begin();
  Serial.println("HTTP server started");
}
 
void loop(void)
{
  
  server.handleClient();
} 

