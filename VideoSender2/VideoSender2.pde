import processing.video.*;
import processing.net.*; 

import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

//byte[] sn = ip.getAddress();
// This is the port we are sending to
int clientPort = 9200; 
//byte[] ipAddr = new byte[] { 127, 0, 0, 1 };
//InetAddress client = InetAddress.getByName("Localhost");

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
  // Images must be in the "data" directory to load correctly
 // imgt = loadImage("maybe.jpg");
  
  kinect = new Kinect(this);
  kinect.initDepth();
  
  depthImg = new PImage(kinect.width, kinect.height);
  
}

void draw() {
  //println(kinect.width + " " + kinect.height); 640 480
 // image(img, 0, 0);
    
  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(200,0,0);
    } else {
      depthImg.pixels[i] = color(255,255,000);
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, 0, 0);
  broadcast(depthImg);
}

// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast(PImage img) {

  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    
    // InetAddress address = InetAddress.getByName("127.0.0.1"); 
    // ^-- IF TO SAME MACHINE
    InetAddress address = InetAddress.getByName("192.168.87.179");
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
