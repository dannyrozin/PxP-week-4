// The world pixel by pixel 2021
// Daniel Rozin
// adjusting colors of an image
// uses PXP methods for getting and setting pixel values fast
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("http://cdn.playbuzz.com/cdn/f721db4c-bdcf-4cbf-83e0-57f9d352b1ed/4330b72d-02e1-4947-b241-9bb4bf06a539.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels();               // load the pixels array of the image, we just need to do this once
}                                      // because it's a static image and doesnt change

void draw() {
  loadPixels();                           // load the pixels array of the window  
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourImage.pixels, width);                       // get the R,G,B values
      PxPSetPixel(x, y, R+mouseX, G+mouseY, B, 255, pixels, width);    // sets the R,G,B values to the window
    }
  }
  updatePixels();                                    //  must call updatePixels oce were done messing with pixels[]
  println (frameRate);

  // make cat cross every 60 seconds. Not very important...
  float catPos= map(second(), 0, 59, 0, width);
  fill(0);
  noStroke();
  ellipse(catPos, 300, 30, 30);
  triangle (catPos, 290, catPos-10, 290, catPos -5, 275);
  triangle (catPos, 290, catPos+10, 290, catPos +5, 275);
  fill(255);
  ellipse(catPos-5, 295, 5, 5);
  ellipse(catPos+5, 295, 5, 5);
  stroke (255);
  triangle (catPos, 305, catPos-3, 300, catPos +3, 300);
  noFill();
  arc(catPos-5, 305, 10, 10, 0, 2);
  arc(catPos+5, 305, 10, 10, 1, 4);
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
