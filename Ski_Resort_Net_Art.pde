/* @pjs preload="Mountains.png,Mountains night.png,Tree.png,Tree Night.png"; */

import java.net.*;
import java.io.*;
import java.util.*;
import java.text.*;

PImage mountains;
PImage mountains_night;
PImage tree;
PImage tree_night;

String name = "default"; //resort name
String resort = "lakelouise";
float temp = 0.0;       //temperature
float base = 0.0;       //base depth
float snow = 0.0;       //new snow
float wind = 0.0;       //wind speed

DateFormat timeformat = new SimpleDateFormat("hh:mm aa"); 
Date time = new Date();  //time of day
Date sunset = new Date();          
Date sunrise = new Date();

Boolean night = true;

float speed = 0.0;
float sway = 0.0;

float [] x = new float[300];
float [] y = new float[300];
int [] size = new int[300];
int [] direction = new int[300];


String data;
Boolean found = false;
int count = 0;

DecimalFormat format = new DecimalFormat(".#");

void setup() {
  
  
  try {
    URL url = new URL("http://www.snowcountry.com/resort-page/ab/lakelouise");
    BufferedReader input = new BufferedReader(new InputStreamReader(url.openStream()));
    
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
  
  
      for(int i = 0; i < 300; i++) {
        size[i] = round(random(3, 5));
        x[i] = random(0, width);
        y[i] = random(0, height);
        direction[i] = round(random(0, 1));
      }
  
  mountains = loadImage("Mountains.png");
  mountains_night = loadImage("Mountains night.png");
  tree = loadImage("Tree.png");
  tree_night = loadImage("Tree Night.png");
  
  width = 1280;
  height = 720;
  size(1280, 720);
  frameRate(30);
  noStroke();
  smooth();

}

void draw() {

  if (wind == 0){
    speed = 0;
    sway = 0;
  } else if (wind < 10){
    speed = speed + 0.04;
    sway = (cos(speed)*10)/4;
  } else{
    speed = speed + 0.08;
  sway = (cos(speed)*10)/2;
  }
  
  if (night){
    background(30,75,75);
    image(mountains_night,0,0);
  
    pushMatrix();
    translate(800,600);
    if (mouseX > 700 && mouseX < 900 && 
       mouseY > 100 && mouseY < 600) {
        sway = sway*10;
        rotate(radians(sway));
        sway = sway/10;
      } else {
        rotate(radians(sway));
      }
    image(tree_night,-100,-400);
    popMatrix();
    
    pushMatrix();
    translate(1000,700);
    if (mouseX > 900 && mouseX < 1100 && 
       mouseY > 200 && mouseY < 700) {
        sway = sway*10;
        rotate(radians(-sway));
        sway = sway/10;
      } else {
        rotate(radians(-sway));
      }
    image(tree_night,-100,-400);
    popMatrix();
    
    pushMatrix();
    translate(1200,550);
    if (mouseX > 1100 && mouseX < 1300 && 
       mouseY > 50 && mouseY < 550) {
        sway = sway*10;
        rotate(radians(sway));
        sway = sway/10;
      } else {
        rotate(radians(sway));
      }
    image(tree_night,-100,-400);
    popMatrix();
    
  } else {
    background(100,230,255);
    image(mountains,0,0);
    
    pushMatrix();
    translate(800,600);
    if (mouseX > 700 && mouseX < 900 && 
       mouseY > 100 && mouseY < 600) {
        sway = sway*10;
        rotate(radians(sway));
        sway = sway/10;
      } else {
        rotate(radians(sway));
      }
    image(tree,-100,-400);
    popMatrix();
    
    pushMatrix();
    translate(1000,700);
    if (mouseX > 900 && mouseX < 1100 && 
       mouseY > 100 && mouseY < 700) {
        sway = sway*10;
        rotate(radians(-sway));
        sway = sway/10;
      } else {
        rotate(radians(-sway));
      }
    image(tree,-100,-400);
    popMatrix();
    
    pushMatrix();
    translate(1200,550);
    if (mouseX > 1100 && mouseX < 1300 && 
       mouseY > 50 && mouseY < 500) {
        sway = sway*10;
        rotate(radians(sway));
        sway = sway/10;
      } else {
        rotate(radians(sway));
      }
    image(tree,-100,-400);
    popMatrix();
  }
  
    if (snow == 0){
  } else if (snow < 10){
      for(int i = 0; i < x.length; i++) {
    fill(255);
    ellipse(x[i], y[i], size[i], size[i]);
    
    if(direction[i] == 0) {
      x[i] += map(size[i], 3, 5, .1, .5);
    } else {
      x[i] -= map(size[i], 3, 5, .1, .5);
    }
    
    y[i] += size[i] + direction[i]; 
    
    if(x[i] > width + size[i] || x[i] < -size[i] || y[i] > height + size[i]) {
      x[i] = random(0, width);
      y[i] = -size[i];
    }
    
  }
  } else{
          for(int i = 0; i < x.length; i++) {
    fill(255);
    ellipse(x[i], y[i], size[i]*2, size[i]*2);
    
    if(direction[i] == 0) {
      x[i] += map(size[i]*2, 3, 5, .1, .5);
    } else {
      x[i] -= map(size[i]*2, 3, 5, .1, .5);
    }
    
    y[i] += size[i]*2 + direction[i]; 
    
    if(x[i] > width + size[i]*2 || x[i] < -size[i]*2 || y[i] > height + size[i]*2) {
      x[i] = random(0, width);
      y[i] = -size[i]*2;
    }
    
  }
  }
  String t = timeformat.format(time);
  String sr = timeformat.format(sunrise);
  String ss = timeformat.format(sunset);
  fill(0);
  text("Resort: " + name + "  Temperature: " + format.format(temp) + "°C  Base: " + format.format(base) + "\"  New Snow: " + format.format(snow) + "\"  Wind Speed: " + format.format(wind) + " kph  Time: " + t + "  Sunset: " + ss + "  Sunrise: " + sr
  ,5,height-5);
}

void mouseClicked(){
  
  if (mouseX > 0 && mouseX < 130 && 
      mouseY > height-20 && mouseY < height) {
        
        if (resort.equals("ab/lakelouise")){
            resort = "bc/ferniealpine";
            name = "Fernie         ";
          } else if (resort.equals("bc/ferniealpine")) {
            resort = "ab/sunshinevillage";
            name = "Sunshine    ";
          } else {
            resort = "ab/lakelouise";
            name = "Lake Louise";
          }
        
         try {
          URL url = new URL("http://www.snowcountry.com/resort-page/" + resort);
          BufferedReader input = new BufferedReader(new InputStreamReader(url.openStream()));
          
          found = false;
          count = 0;
    
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
  
  }
    if (mouseX > 335 && mouseX < 335+100 && 
      mouseY > height-20 && mouseY < height) {
          if (snow == 0.0){
            snow = 1;
          } else if (snow < 10.0) {
            snow = 10;
          } else {
            snow = 0;
          }
  }
    if (mouseX > 440 && mouseX < 440+125 && 
      mouseY > height-20 && mouseY < height) {
          if (wind == 0.0){
            wind = 1;
          } else if (wind < 10.0) {
            wind = 10;
          } else {
            wind = 0;
          }
  }
    if (mouseX > 570 && mouseX < 570+100 && 
      mouseY > height-20 && mouseY < height) {
          if (night) {
            night = false;
          } else {
            night = true;
          }
  }
}