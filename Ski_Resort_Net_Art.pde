import java.net.*;
import java.io.*;
import java.util.*;
import java.text.*;

String name = "default"; //resort name
String temp = "0";       //temperature
String base = "0";       //base depth
String snow = "0";       //new snow
String wind = "0";       //wind speed

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
          snow = num.toString();
        } else if(count == 2){
          base = num.toString();
        } else if(count == 5){
          temp = num.toString();
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
        wind = num.toString();
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
  
  size(800, 480);
  System.out.println("name: " + name + " temp: " + temp + " base: " + base + " snow: " + snow + " wind: " + wind + " time: " + time + " sunset: " + sunset + " sunrise " + sunrise + " night: " + night);

}

void draw() {
}