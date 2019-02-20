// The world pixel by pixel 2019
// Daniel Rozin
// PXP methods in an object called PxPixel
PxPixel ourPxPixel= new PxPixel();
PImage ourImage;
void setup() {
  size(1000, 800);
  ourImage= loadImage("http://cdn.playbuzz.com/cdn/f721db4c-bdcf-4cbf-83e0-57f9d352b1ed/4330b72d-02e1-4947-b241-9bb4bf06a539.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels(); // load the pixels array of the image
}

void draw() {
  image(ourImage, 0, 0);                                  // draw the image to the screen as we will be only changing some of the pixels
  loadPixels();
  // load the pixels array of the window 
  for (int x = 0; x<mouseX; x++) {                      // looping through all the pixels left of the mouse
    for (int y = 0; y<height; y++) {
      ourPxPixel.getPixel(x, y, pixels, width);
      int R=255-ourPxPixel.R;                                          // inverse the colors by subtracting from 255
      int G=255-ourPxPixel.G;
      int B=255-ourPxPixel.B;
      ourPxPixel.setPixel(x, y, R, G, B, 255, pixels, width);
    }
  }
  updatePixels();                                           //  must call updatePixels oce were done messing with pixels[]
  println (frameRate);
}



class PxPixel {
  int R, G, B, A;

  void getPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
    int thisPixel=pixelArray[x+y*pixelsWidth];
    A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
    R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
    G = (thisPixel >> 8) & 0xFF;   
    B = thisPixel & 0xFF;
  }

  void setPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
    a =(a << 24);                       
    r = r << 16;                       // We are packing all 4 composents into one int
    g = g << 8;                        // so we need to shift them to their places
    color argb = a | r | g | b;
    pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
  }
}