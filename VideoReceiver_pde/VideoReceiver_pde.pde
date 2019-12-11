import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;


ArrayList<SenderData> senderDataArray;
 
void setup() {
  size(640,480);
  int[] ports = {9100, 9200}; // ADD PORTS HERE - ADD ONLY THE ONES THAT ARE USED 
                              // (if additional added, you will get black screen)
  senderDataArray = new ArrayList<SenderData>();

  for(int i = 0; i < ports.length; i++){
    senderDataArray.add(new SenderData(ports[i]));
  } 
}

void draw() {
  imageMode(CENTER);
  background(0);
  
  // checkForImage() is blocking, stay tuned for threaded example!
  for(int i = 0; i < senderDataArray.size(); i++){
    SenderData sd = senderDataArray.get(i);
    sd.checkForImage();
    
    blend(sd.video, 0,0,width,height,0,0,width,height,ADD);
  }


  // Draw the image
  
 
 // image(data2.video,width/2,height/2);
  
}
