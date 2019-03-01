#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>
#include <OneWire.h> 
#include <DallasTemperature.h>

// Define Constants
#define FIREBASE_HOST "bioabd-662cf.firebaseio.com"
#define FIREBASE_AUTH "CqO8PSmZMvpMkMHOxIhVbajug5Cc5Y0tSoYcGlMX"
#define WIFI_SSID "MJK"
#define WIFI_PASSWORD "A12086477198990"

// Assign ID to the accelerometer
Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified(12345);

// Assign pin for the temperature sensor
#define ONE_WIRE_BUS 2
// Setup for the temperature sensor
OneWire oneWire(ONE_WIRE_BUS); 
DallasTemperature sensors(&oneWire);

void setup() {
  Serial.begin(9600);
  // Attempt connection with given SSID and Password
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  
  // Connect to Wi-Fi
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  // Connect to Firebase server with the given host name and authentication code
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  #ifndef ESP8266
  while (!Serial);
#endif
  
  // Sensor initialization
  if(!accel.begin())
  {
    // Sensor detection error for the accelerometer
    Serial.println("No ADXL345 detected. Check the wiring.");
    while(1);
  }
  // Maximum measured force @ 16g
  accel.setRange(ADXL345_RANGE_16_G);
  
  // Start the temperature sensor
  sensors.begin();
}

void loop() {
  // Request the temperature
  sensors.requestTemperatures();
  sensors_event_t event; 
  
  // Request the acceleration
  accel.getEvent(&event);
  StaticJsonBuffer<200> jsonBuffer;
  JsonObject& root = jsonBuffer.createObject();
  
  // Measure the time in ms and send it to the server
  root["unixTime"] = millis();
  // Measure the x y z acceleration values and send it to the server
  root["xValue"] = event.acceleration.x;
  root["yValue"] = event.acceleration.y;
  root["zValue"] = event.acceleration.z;
  // Measure the temperature and send it to the server
  root["tempValue"] = sensors.getTempCByIndex(0);
  // Push the measured data to the server
  String name = Firebase.push("/adxl345", root);
  // Error handler
  if (Firebase.failed()) {
      Serial.print("pushing /logs failed:");
      Serial.println(Firebase.error());
      return;
  }
  // Delay for 1 sec and repeat
  delay(1000);
}
