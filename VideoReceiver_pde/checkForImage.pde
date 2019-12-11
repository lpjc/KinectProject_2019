class SenderData{
    
  int port; 
  DatagramSocket ds; 
  byte[] buffer = new byte[65536];
  PImage video;
  
  SenderData (int _port){
    port = _port;
    try {
      ds = new DatagramSocket(port);
    } catch (SocketException e) {
      e.printStackTrace();
    } 
    video = createImage(640,480,RGB);
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
}
