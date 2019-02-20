// The world pixel by pixel 2019
// Daniel Rozin
// Adjusting the brightness of an image
// This example does not use the PXP methods which makes it slower but more readable

PImage ourImage;
void setup() {
  size(1024, 768);
  frameRate(120);
  ourImage= loadImage("https://res.cloudinary.com/teepublic/image/private/s--OrJcI8-v--/t_Preview/b_rgb:5e366e,c_limit,f_jpg,h_630,q_90,w_630/v1495920519/production/designs/1629044_1.jpg");
  ourImage.resize (width, height);                              // it makes things much easier to have the image the size of the window
  ourImage.loadPixels();                                         // load the pixels array of the image, we only have to do ths once
}                                                                // because the image doesnt change

void draw() {
  loadPixels();                                                 // load the pixels array of the window  
  for (int x = 0; x<width; x++) {                              // visit all pixels
    for (int y = 0; y<height; y++) {
      int thisPixel = x+y*width;                                // the famous formula for getting the position in the pixels[] 
      color thisColor=ourImage.pixels[thisPixel];                       //get the color from the pixels[]
      float R= red(thisColor);                                   // get the R,G,B components and store in floats
      float G= green(thisColor);
      float B= red(thisColor);
      R=R+mouseX-width/2;                                              // changing R,G,B by adding the same number to all 3
      G=G+mouseX-width/2;                                              // which is changing the brightness of that pixel
      B=B+mouseX-width/2;
      color newColor = color(R,G,B);
    pixels[thisPixel]= newColor;
  }
  }
  updatePixels();                                    //  must call updatePixels oce were done messing with pixels[]
  println (frameRate);
}