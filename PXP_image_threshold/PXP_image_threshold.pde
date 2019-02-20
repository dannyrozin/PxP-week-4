// The world pixel by pixel 2019
// Daniel Rozin
// threshold an image's brightness
// uses methods for getting and setting pixel values fast
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("https://www.crestwoodflowers.net/gifs/index-flowers.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels();                           // load the pixels array of the image
}

void draw() {
  background (0);
  loadPixels(); // load the pixels array of the window  
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourImage.pixels, width);     // get the RGB of our pixel and place in RGB globals
      int thresholdAmont = mouseX;                   // make sure we dont have a value of zero cause we need to divide by it 
      if ((R+G+B)  <thresholdAmont) {                // we are evaluating the brightness 
        R=0;
        G=0;
        B=0;                                         // if the  brightness is lower than mouseX
      } else {                                       // then we set as black
        R= 255;
        G=255;
        B=255;                                       //if the  brightness is higher than mouseX
      }                                              //we set white
      PxPSetPixel(x, y, R, G, B, 255, pixels, width);    // sets the R,G,B values to the window
    }
  }
  updatePixels();                                    //  must call updatePixels oce were done messing with pixels[]
  println (frameRate);
}


// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

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
  r = r << 16;                                // We are packing all 4 composents into one int
  g = g << 8;                                 // so we need to shift them to their places
  color argb = a | r | g | b;                 // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;          // finaly we set the int with te colors into the pixels[]
}