// Doodle recorder for the PEmbroider library for Processing!
// Press 's' to save the embroidery file. Press space to clear.

import processing.embroider.*;
PEmbroiderGraphics E;

ArrayList<PVector> currentMark;
ArrayList<ArrayList<PVector>> marks;
boolean mouse = false;
int totalNeedleDowns = 0;

//===================================================
void setup() {
  size (800, 800);
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("PEmbroider_interactive_demo_2.pes"); // TO DO: ADD PERSONAL NAMING FOR THE FILE NAMES
  E.setPath(outputFilePath);

  currentMark = new ArrayList<PVector>();
  marks = new ArrayList<ArrayList<PVector>>();
  // TO DO: ADD SAMPLE SHAPES AND SCALE HERE
}

//===================================================
void draw() {

  // Clear the canvas, init the PEmbroiderGraphics
  background(200);
  E.clear();
  E.beginDraw();
  E.noFill();
  
  drawRuler(width-300, height-25);
  drawSampler();

  // Set some graphics properties
  E.noFill();
  E.stroke(0, 0, 0);
  E.strokeWeight(1);
  E.strokeSpacing(5.0);
  E.strokeMode(PEmbroiderGraphics.PERPENDICULAR);
  E.RESAMPLE_MAXTURN = 0.8f; //
  E.setStitch(20, 1000, 0.0); /// MAY NEED TO CHANGE THIS BASED ON "CLICK SHAPE" VS "HELD SHAPE"


  // Draw all previous marks
  for (int m=0; m<marks.size(); m++) {
    ArrayList<PVector> mthMark = marks.get(m);
    E.beginShape();
    for (int i=0; i<mthMark.size(); i++) {
      PVector ithPoint = mthMark.get(i);
      E.vertex (ithPoint.x, ithPoint.y);
    }
    E.endShape();
  }





  // If the mouse is pressed,
  // add the latest mouse point to current mark,
  // and draw the current mark
  // TO DO: CREATE A MOUSE PRESSED TYPE SHAPE, END SHAPE USING ENTER
  if (mousePressed) {
    addNeedleDowns(mouseX, mouseY);
  }

  E.beginShape();
  for (int i=0; i<currentMark.size(); i++) { /// current marks is stored separately from the total mark
    PVector ithPoint = currentMark.get(i);
    E.vertex (ithPoint.x, ithPoint.y);
  }
  E.endShape();
  
  textSize(20);
  fill(0);
  text("Stitches Left:" + str(4000-totalNeedleDowns),100,height-30);

  E.visualize();
}

//===================================================
void mousePressed() {
  // Create a new current mark
  if (mouse == false) {
    mouse = true; // lets let everyone know we're starting a new mark,
  }
  addNeedleDowns(mouseX, mouseY);
}

void mouseReleased() {
  addNeedleDowns(mouseX, mouseY);
} 

void addNeedleDowns(float X, float Y) {
  if (totalNeedleDowns < 4000) {
    totalNeedleDowns++;
    currentMark.add(new PVector(X, Y));
  }
}

//===================================================
void keyPressed() {
  if (key == ' ') {
    currentMark.clear();
    marks.clear();
    totalNeedleDowns = 0;
  } else if (key == 's' || key == 'S') { // S to save
    // Add png + .pes export
    // Add timestamp to allow for multiple exports
    E.optimize(); // slow, but very good and important
    E.printStats();
    E.endDraw(); // write out the file
  } else if (key == '\n') {
    mouse = false;
    marks.add(currentMark);
    currentMark = new ArrayList<PVector>();
  }
}



void drawRuler(float x, float y) {

  float mm = 10;
  float cm = 10*mm;
  int nMm = 25;
  float w = nMm*mm;
  float x0 = x;//1*cm;
  float x1 = x0 + w;
  float y0 = y; //2*cm;

  // Inch ruler:
  float inch = 25.4*mm;
  float quarterInch = inch/4.0;
  float px = x0;
  for (int i=0; i<=4; i++) {
    px = x0 + i*quarterInch;
    if (i%4 == 0) {
      E.line (px, y0, px, y0-cm*1.0);
      E.line (px, y0-cm*1.0, px, y0);
    } else if (i%2 == 0) {
      E.line (px, y0, px, y0-cm*0.5);
      E.line (px, y0-cm*0.5, px, y0);
    } else {
      E.line (px, y0, px, y0-cm*0.25);
      E.line (px, y0-cm*0.25, px, y0);
    }
  }
  E.line(x0, y0, px, y0);

  E.textSize(2.3);
  E.textFont(PEmbroiderFont.DUPLEX);
  E.text("IN", x0, y0-150);
}



void drawSampler(){ 
 // E.beginOptimize();
  E.noStroke();
  E.setStitch(10,10,0.0);
  E.fill(10);
  E.hatchSpacing(8);
  E.hatchMode(PEmbroiderGraphics.PARALLEL);
  float circDiam = 60;
  float  wallOffset = 20;
  E.circle(circDiam/2+wallOffset,circDiam/2+wallOffset,circDiam);
  
  E.hatchMode(PEmbroiderGraphics.CROSS);
  E.rect(wallOffset,height-(circDiam+wallOffset),circDiam,circDiam);
  
  E.stroke(1);
  E.hatchMode(PEmbroiderGraphics.SPIRAL);
  E.rect(width-(circDiam*2+wallOffset),wallOffset,circDiam*2,circDiam);
  
  E.noFill();
  E.rect(width/2-100,height/2-100,200,200);
  E.rect(width/2-350,height/2-100,200,200);
  E.rect(width/2+ 150 ,height/2-100,200,200);
  
  //E.endOptimize();
  
}
