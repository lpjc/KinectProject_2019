import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;


// Port we are receiving.
int port = 9100; 
int port2 = 9200;
DatagramSocket ds; 
DatagramSocket ds2;
// A byte array to read into (max size of 65536, could be smaller)
byte[] buffer = new byte[65536]; 

PImage video;
PImage video2;

void setup() {
  size(640,480);
  try {
    ds = new DatagramSocket(port);
    ds2 = new DatagramSocket(port2);
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  video = createImage(640,480,RGB); // expected the same size as broadcasted
}

 void draw() {
  // checkForImage() is blocking, stay tuned for threaded example!
  checkForImage();
  //checkForImage2();

  // Draw the image
 background(video);
  imageMode(CENTER);
  //image(video2,width/2,height/2);
  blend(video, 0,0,width,height,0,0,width,height,BLEND);
}

void checkForImage() {
  DatagramPacket p = new DatagramPacket(buffer, buffer.length);   
  try {
    ds.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();

  println("Received datagram with " + data.length + " bytes." );

  // Read incoming data into a ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream( data );

  // We need to unpack JPG and put it in the PImage video
  //video.loadPixels();
  try {
    // Make a BufferedImage out of the incoming bytes
    BufferedImage img = ImageIO.read(bais);
    // Put the pixels into the video PImage
    img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
  } catch (Exception e) {
    e.printStackTrace();
  }
  // Update the PImage pixels
  video.updatePixels();
}
void checkForImage2() {
  DatagramPacket p = new DatagramPacket(buffer, buffer.length);   
  try {
    ds2.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();

  println("Received datagram with " + data.length + " bytes." );

  // Read incoming data into a ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream( data );

  // We need to unpack JPG and put it in the PImage video
  video2.loadPixels();
  try {
    // Make a BufferedImage out of the incoming bytes
    BufferedImage img = ImageIO.read(bais);
    // Put the pixels into the video PImage
    img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
  } catch (Exception e) {
    e.printStackTrace();
  }
  // Update the PImage pixels
  video2.updatePixels();
} 
