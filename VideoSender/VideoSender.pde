import processing.video.*;
import processing.net.*; 

import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

int clientPort = 9100; // Port we are sending to - the receiver needs this

// This is our object that sends UDP out
DatagramSocket ds; 

PImage imgt;
PImage depthImg;

int minDepth =  60;
int maxDepth = 860;

void setup() {
  
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  
   size(640, 480);

  kinect = new Kinect(this);
  kinect.initDepth();
  
  depthImg = new PImage(kinect.width, kinect.height);
  
}

void draw() {

  // Threshold for the desired depth of the Kinect Sihlouttes
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(0,0,120);
    } else {
      depthImg.pixels[i] = color(0,0,0,255);
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, 0, 0);
  broadcast(depthImg);
}

// BROADCASTING METHOD for UDP protocol
void broadcast(PImage img) {

  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  img.loadPixels(); // loading th epixels in current display down to img
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);
  
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    
    //InetAddress address = InetAddress.getByName("127.0.0.1"); 
    // ^-- IF TO SAME MACHINE, FOR TESTING 
    InetAddress address = InetAddress.getByName("192.168.87.155"); // ADD IP HERE
    // ^-- NEED IP OF DESTINATION MACHINE
    
    byte[] byteIP = address.getAddress();
      try {
      ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByAddress(byteIP),clientPort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }   
  
}
