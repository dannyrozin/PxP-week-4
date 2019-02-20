// The world pixel by pixel 2019
// Daniel Rozin
// change an image's saturation
// uses PXP methods for getting and setting pixel values fast
int R, G, B, A;          // you must have these global variables to use the PxPGetPixel()
PImage ourImage;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("https://www.crestwoodflowers.net/gifs/index-flowers.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels();                          // load the pixels array of the image
}

void draw() {
  image (ourImage, 0, 0);                           // draw the un processed image as we will only process some of the pixels
  loadPixels();                                     // load the pixels array of the window  
  float average = 127;
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      if (dist(x, y, width/2, height/2) < height/2) {  // lets just do this to a circle of pixels
        PxPGetPixel(x, y, ourImage.pixels, width);  // get the RGB of our pixel and place in RGB globals
        int saturation =mouseX/5;                   // saturation  value between 0-200;

        int R1 = R;
        int G1=G;
        int B1 = B;                                 // this is from the litle C refrence book
        int RY1 = (70*R1-59*G1-11*B1)/100;
        int BY1 = (-30*R1-59*G1+89*B1)/100;
        int GY1 = (-30*R1+41*G1-11*B1)/100;
        int Y = (30 *R1 +59 *G1+11*B1)/100;
        int RY = (RY1 *saturation)/100;                   
        int GY = (GY1 *saturation)/100;
        int BY = (BY1 *saturation)/100;

        int tempR =  RY+Y;
        int tempG =  GY+Y;
        int tempB =  BY+Y;

        tempR= constrain(tempR, 0, 255);                                   // this could yield number smaller than 0 and greater than 255
        tempG= constrain(tempG, 0, 255);                                  // so we have to constrain
        tempB= constrain(tempB, 0, 255);  
        PxPSetPixel(x, y, tempR, tempG, tempB, 255, pixels, width);    // sets the R,G,B values to the window
      }
    }
  }
  updatePixels();                                    //  must call updatePixels oce were done messing with pixels[]
  println ( frameRate);
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