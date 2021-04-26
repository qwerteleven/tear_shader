import processing.video.*;

Capture cam;
PImage img;
boolean enabled = true;
PShader tear_drop;

void setup() {
  size(750, 750, P2D);
  
  cam = new Capture(this, width , height);
  cam.start();
  
  tear_drop = loadShader("tear_drop.glsl");
}

void draw() {
  tear_drop.set("resolution", float(width), float(height));
  tear_drop.set("time", millis() / 1000.0);
  tear_drop.set("A", random(-9, 9));
  tear_drop.set("B", random(-9, 9));
  
  if (cam.available()) {
    cam.read();
    image(cam, 0, 0);
  }
  
  if (enabled) 
   shader(tear_drop);
}

void mousePressed() {
  enabled = !enabled;
  if (!enabled == true) {
    resetShader();
  }
}
