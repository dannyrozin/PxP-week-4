// The world pixel by pixel 2019
// Daniel Rozin
// change an image's contrast
// uses PXP methods for getting and setting pixel values fast
int R, G, B, A;          // you must have these global variables to use the PxPGetPixel()
PImage ourImage;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("https://www.crestwoodflowers.net/gifs/index-flowers.jpg");
  ourImage.resize (width, height);        // make sure the image is the size of the window
  ourImage.loadPixels();                 // load the pixels array of the image
}

void draw() {
  loadPixels(); // load the pixels array of the window  
  float average = 127;                              // this is the middle gray that the image will be in 0 contrast
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourImage.pixels, width);     // get the RGB of our pixel and place in RGB globals
      float contrastAmont = map (mouseX, 0, width, 0, 2);                   // contrast  value beween 0-2;

      int tempR =  int(contrastAmont * (R - average)+average);        // this is from the little book of algorithms in C
      int tempG =  int(contrastAmont * (G - average)+average);        // in general, this math takes each color closer or farther
      int tempB =  int(contrastAmont * (B - average)+average);        // from the 127 middle point
      tempR= constrain(tempR, 0, 255);                                   // this could yield number smaller than 0 and greater than 255
      tempG= constrain(tempG, 0, 255);                                  // so we have to constrain
      tempB= constrain(tempB, 0, 255);  
      PxPSetPixel(x, y, tempR, tempG, tempB, 255, pixels, width);    // sets the R,G,B values to the window
    }
  }
  updatePixels();                                    //  must call updatePixels oce were done messing with pixels[]
  println ( map (mouseX, 0, width, 0, 2));
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
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}