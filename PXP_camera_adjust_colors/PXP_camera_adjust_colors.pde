// The world pixel by pixel 2022
// Daniel Rozin
// Adjusting colors of a video
// uses PXP methods in the bottom
import processing.video.*;

Capture ourVideo;          // variable to hold the video
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);       // open default video in the size of window
  ourVideo.start();                                  // start the video
  noCursor();                                        // so we can see the little smiley
}

void draw() {
  if (ourVideo.available())  ourVideo.read();       // get a fresh frame of video as often as we can
  background (0);
  ourVideo.loadPixels();                     // load the pixels array of the video 
  loadPixels();                              // load the pixels array of the window  
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourVideo.pixels, width);
      PxPSetPixel(x, y, R+mouseX, G+mouseY, B, 255, pixels, width);    // sets the R,G,B values to the window
    }
  }
  updatePixels();                                    //  must call updatePixels once were done messing with pixels[]
  println (frameRate);

  ellipse(mouseX, mouseY, 30, 30);                    // add a little guy...
  ellipse(mouseX-5, mouseY-5, 5, 5);
  ellipse(mouseX+5, mouseY-5, 5, 5);
  arc(mouseX, mouseY, 20, 20, 1, 2);
}



// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
