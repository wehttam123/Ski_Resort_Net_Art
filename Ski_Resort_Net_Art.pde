import java.net.*;
import java.io.*;
import java.util.*;
import java.text.*;

String name = "default"; //resort name
float temp = 0;       //temperature
float base = 0;       //base depth
float snow = 0;       //new snow
float wind = 0;       //wind speed

DateFormat timeformat = new SimpleDateFormat("hh:mm aa"); 
Date time = new Date();  //time of day
Date sunset = new Date();          
Date sunrise = new Date();

Boolean night = true;

void setup() {
  
  try {
    URL url = new URL("http://www.snowcountry.com/resort-page/ab/lakelouise");
    BufferedReader input = new BufferedReader(new InputStreamReader(url.openStream()));
    String data;
    Boolean found = false;
    int count = 0;
    
    while ((data = input.readLine()) != null){
      if(data.contains("huge")){
        StringBuilder num = new StringBuilder();
        found = false;
        for(char c : data.toCharArray()){ 
          if(Character.isDigit(c)){ 
            num.append(c); 
            found = true;
          } else if(found){
            break; 
          }
        }
        count++;
        if(count == 1){
          snow = Float.parseFloat(num.toString());
        } else if(count == 2){
          base = Float.parseFloat(num.toString());
        } else if(count == 5){
          temp = (Float.parseFloat(num.toString())-32)*(0.6);
        }
      } else if(data.contains("Winds")){
        StringBuilder num = new StringBuilder();
        found = false;
        for(char c : data.toCharArray()){ 
          if(Character.isDigit(c)){ 
            num.append(c); 
            found = true;
          } else if(found){
            break; 
          }
        }
        wind = Float.parseFloat(num.toString())*1.6;
      } else if(data.contains("Sunrise")){
        sunrise = timeformat.parse(data.split(";")[1].substring(0,8));
        sunset = timeformat.parse(data.split(";")[3].substring(0,8));
      }
    }
    input.close();
    time = timeformat.parse(timeformat.format(time.getTime()));
  } catch(Exception e) {
    e.printStackTrace();
  }
  
  if (time.after(sunrise)){
    if (time.before(sunset)){
    night = false;
    }
  }
  
  name = "Lake Louise";
  
  width = 1280;
  height = 720;
  size(1280, 720);

}

void draw() {
  if (night){
    background(30,75,75);
  } else {
    background(100,230,255);
  }
  
  String t = timeformat.format(time);
  String sr = timeformat.format(sunrise);
  String ss = timeformat.format(sunset);
  text("Resort: " + name + "  Temperature: " + temp + "°C  Base: " + base + "\"  New Snow: " + snow + "\"  Wind Speed: " + wind + " kph  Time: " + t + "  Sunset: " + ss + "  Sunrise: " + sr
  ,5,height-5);
}