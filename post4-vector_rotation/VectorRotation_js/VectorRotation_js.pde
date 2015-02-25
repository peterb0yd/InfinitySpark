rMatrix rMat;
Graph_3d graph;
Button resetGraphButton, updateVectorButton, resetVectorButton;
Vector vector, rotatedVector;
VectorInput vecX, vecY, vecZ;
HScrollbar hs1, hs2, hs3;
ArrayList <VectorInput> vectorInputs = new ArrayList <VectorInput>();
ArrayList <HScrollbar> scrollBars = new ArrayList <HScrollbar>();
public boolean dragging = false;
public boolean released = false;
public float maxValue = 0;
boolean error = false;
PFont font;

void setup() {
  size(600, 620, P3D);
  
  vector = new Vector(0,0,0);
  rMat = new rMatrix();
  graph = new Graph_3d();
  
  // Set Horizontal Scrollbars properties
  hs1 = new HScrollbar(0, 380, width, 16, 16, 1); // hs1 is Z
  hs2 = new HScrollbar(0, 400, width, 16, 16, 2); // hs2 is X
  hs3 = new HScrollbar(0, 420, width, 16, 16, 3); // hs3 is Y
  scrollBars.add(hs1);
  scrollBars.add(hs2);
  scrollBars.add(hs3);

  // Set button properties
  resetGraphButton = new Button(width/2-90, 444, 180, 40, "Reset Graph");
  updateVectorButton = new Button(width/2+10, 500, 100, 45, "Update");
  resetVectorButton = new Button(width/2+10, 545, 100, 45, "Reset");
  
  // Set Vector Input properties
  vecX = new VectorInput(width/2+110, 500, 1);
  vecY = new VectorInput(width/2+110, 530, 2);
  vecZ = new VectorInput(width/2+110, 560, 3);
  vectorInputs.add(vecX);
  vectorInputs.add(vecY);
  vectorInputs.add(vecZ);
}

void draw() {
  background(255);

  // Show Horizontal Scrollbars
  for (HScrollbar sb : scrollBars) {
    sb.draw();
  }
  
  // Draw graph
  graph.draw();

  // Show Buttons
  resetGraphButton.draw();
  resetVectorButton.draw();
  updateVectorButton.draw();
  
  // Draw Text Inputs
  for (VectorInput vecInput : vectorInputs) {
    vecInput.draw();
  }

  // If Vector available, draw it
  if (vector != null) {
    vector.draw();
  }
  

  // Input error - draw message
  if (error) showInputError();
  
  // Draw vector rotation angles
  drawRotatedAngles();
  
  // Draw vector rotation values 
  drawRotatedValues();
  
  // Cursor logic
  setCursor();
}

void mousePressed() {
  released = false;
  
  // Reset Graph rotation
  if (resetGraphButton.over()) {
    for (HScrollbar sb : scrollBars) {
      sb.resetPos();
    }
    resetRotatedValues();
  }
  
  // Reset vector to (0,0,0);
  if (resetVectorButton.over()) {
     if (vector != null) {
        vector.reset();
        resetRotatedValues();
     } 
     for (VectorInput vecInput : vectorInputs) {
       vecInput.input = "0";
     }
  }
  
  // Show vector on graph
  if (updateVectorButton.over()) {
     updateVector(); 
  }
  
  // Input vector values
  for (VectorInput vecInput : vectorInputs) {
    vecInput.checkMousePress();
  }
}

void keyPressed() {
  if (key == ENTER) {
    updateVector();
  }
  for (int i = 0; i < 3; i++) {
    VectorInput vecInput = vectorInputs.get(i);
    if (vecInput.clickedOn) {
      if (vecInput.highlighted && !vecInput.typing) {
        vecInput.input = "";
        if (keyIsNumber(key)) {
          vecInput.input += String.fromCharCode(key);
        } 
        vecInput.highlighted = false;
        vecInput.typing = true;
      } else {
        if (key == BACKSPACE && vecInput.input.length() > 0) {
          vecInput.input = vecInput.input.substring(0, vecInput.input.length()-1);
        } else {
          if (vecInput.input.length() < 10 && keyIsNumber(key)) {
             vecInput.input += String.fromCharCode(key);
          }
        }
      }
    }
  }
}

// Draw vector to graph
void updateVector() {
    float originalMaxValue = maxValue;
    try {
      float[] comp = new float[3];  // vector component holder
      maxValue = 0;
      for (int i = 0; i < 3; i++) {
         VectorInput vecInput = vectorInputs.get(i);
         if (!vecInput.input) {  // vector input empty
            comp[i] = 0;
            vecInput.input = "0";
         } else {
            comp[i] = parseFloat(vecInput.input);  // convert input to float
         }
         // Get maxValue component for Scaling
         if (comp[i] < 0) {  
           if (comp[i]*-1 > maxValue) maxValue = comp[i]*-1;   // maxValue is negative
         } else {
           if (comp[i] > maxValue) maxValue = comp[i];   // maxValue is positive
         } 
      }
      error = false;
      if (maxValue != 0) {
        maxValue = (float)(Math.round((maxValue*1.2) * 100) / 100);
        maxValue = graph.getMaxValue(maxValue);
      }
      vector = new Vector(comp[0], comp[1], comp[2]);  // initialize vector
      checkGraphRotation();
    } catch (NumberFormatException e) {  // input error
      error = true;
      maxValue = originalMaxValue;
      return;
    }
    
}

void mouseReleased() {
  released = true;
}

// Update rotation vector values
void updateRotatedValues(int a) {
  switch (a) {
     case 1: rotatedVector = new Vector(rMat.rotationX(vector, graph.deg1)); break;  // normal X
     case 2: rotatedVector = new Vector(rMat.rotationY(vector, graph.deg2)); break;  // normal Y  
     case 3: rotatedVector = new Vector(rMat.rotationZ(vector, graph.deg3)); break;  // normal Z
  }
} 

// Reset rotation vector values 
void resetRotatedValues() {
  rotatedVector = vector; 
}

// Show transformed vector components
void drawRotatedValues() {
   if (rotatedVector == null) rotatedVector = vector;
   fill(240);
   rect(180, 500, 130, 90);
   fill(0);
   text("Vector Rotated:", 200, 520);
   float roundRX = (float)(Math.round((rotatedVector.x) * 1000000) / 1000000);
   float roundRY = (float)(Math.round((rotatedVector.y) * 1000000) / 1000000);
   float roundRZ = (float)(Math.round((rotatedVector.z) * 1000000) / 1000000);
   text("x: " + roundRX, 200, 540);
   text("y: " + roundRY, 200, 560);
   text("z: " + roundRZ, 200, 580);
}

// Show transformed vector components
void drawRotatedAngles() {
   if (rotatedVector == null) rotatedVector = vector;
   fill(240);
   rect(60, 500, 120, 90);
   fill(0);
   text("Angle to axis:", 80, 520);
   float xAngle = acos(rotatedVector.x/rotatedVector.magnitude())*(180/PI);
   float yAngle = acos(rotatedVector.y/rotatedVector.magnitude())*(180/PI);
   float zAngle = acos(rotatedVector.z/rotatedVector.magnitude())*(180/PI);
   xAngle = (float)(Math.round((xAngle) * 1000000) / 1000000);
   yAngle = (float)(Math.round((yAngle) * 1000000) / 1000000);
   zAngle = (float)(Math.round((zAngle) * 1000000) / 1000000);
   if (xAngle != xAngle) xAngle = 0;
   if (yAngle != yAngle) yAngle = 0;
   if (zAngle != zAngle) zAngle = 0;
   text("x: " + xAngle + "°", 80, 540);
   text("y: " + yAngle + "°", 80, 560);
   text("z: " + zAngle + "°", 80, 580);
}

// Check if Typed Key is number
boolean keyIsNumber(char k) {
   String nums = "0123456789.-";
   String s = String.fromCharCode(k);
   if (nums.contains(s)) {
     return true;
   } else {
     return false;
   } 
}


// Check if graph is rotated
void checkGraphRotation() {
  rotatedVector = vector;
  if (graph.deg1 != 0) {            // check X rotation value
    updateRotatedValues(1);
  } 
  if (graph.deg2 != 0) {            // check Y rotation value  
    updateRotatedValues(2);  
  }
  if (graph.deg3 != 0) {            // check Z rotation value
    updateRotatedValues(3);
  }
}


// Show input-error message
void showInputError() {
   fill(255,0,0);
   text("Error: incorrect value(s) entered", width/2-90, 610, 6);
   fill(0);
}

// Sets Cursor to default
void setCursor() {
  if (!resetGraphButton.over() && 
      !resetVectorButton.over() &&
      !updateVectorButton.over() && 
      !hs1.over && !hs2.over && !hs3.over && 
      !vecX.over() && !vecY.over() && !vecZ.over()) {
    cursor(ARROW);
  }
}






/********* BUTTON CLASS ***********/
class Button {
  int x, y;
  int buttonWidth, buttonHeight;
  String label;
  Button(int x, int y, int buttonWidth, int buttonHeight, String label) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.label = label;
  }
  void draw() {
    fill(200);
    if (over()) {
      fill(255);
    }
    rect(x, y, buttonWidth, buttonHeight);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x+(buttonWidth/2), y+(buttonHeight/2)-2);
    textAlign(NORMAL, NORMAL);
  }
  boolean over() {
    if (mouseX >= x && mouseY >= y && mouseX <= x + buttonWidth && mouseY <= y + buttonHeight) {
      cursor(HAND);
      return true;
    } 
    return false;
  }
}







class Graph_3d {
  public float deg1;  // deg2 is X
  public float deg2;  // deg3 is Y
  public float deg3;  // deg1 is Z

  void draw() {
    // Rotated Axis drawn
    drawRotated();
    
    // Draw rotation angles to screen
    drawRotationAngles();
   
    // Draw graph scale to screen
    drawScale();
  }

  // Rotated Axis
  void drawRotated() {
    pushMatrix();
    // move the origin to the pivot point
    translate(200, 200, 0); 

    // Set Coordinate positions
    deg1 = map(hs1.getPos(), 0, 600, 0, 360);
    deg2 = map(hs2.getPos(), 0, 600, 0, 360);
    deg3 = map(hs3.getPos(), 0, 600, 0, 360);
    
    rotateX(radians(deg2));    // deg2 is X
    rotateY(radians(deg3));    // deg3 is Y
    rotateZ(radians(deg1));    // deg1 is Z
    
    // X Coordinate 
    line(0, 0, 150, 0, 0, -150);
    drawMarks(1);
    text("X", -10, 0, 155);
    text("-X", 10, 0, -155);

    // Y Coordinate
    line(150, 0, 0, -150, 0, 0);
    drawMarks(2);
    text("Y", 155, 0, 0);
    text("-Y", -165, 0, 0);

    // Z Coordinate
    line(0, 150, 0, 0, -150, 0);
    drawMarks(3);
    text("Z", 0, -160, 0);
    text("-Z", 0, 160, 0);

    popMatrix();
  }


  // Draw Axis Marks
  void drawMarks(int axis) {
    switch (axis) {
    case 1:
      for (int i = 0; i <= 10; i++ ) {
        line(0, 5, -150+(i*30), 0, -5, -150+(i*30));
      }
      break;
    case 2:
      for (int i = 0; i <= 10; i++ ) {
        line(-150+(i*30), 5, 0, -150+(i*30), -5, 0);
      }
      break;
    case 3:
      for (int i = 0; i <= 10; i++ ) {
        line(5, -150+(i*30), 0, -5, -150+(i*30), 0);
      }
      break;
    }
  }
  
  // Draw Rotation angles to screen
  void drawRotationAngles() {
    // Draw text to screen
    deg1 -= 180.0;
    deg2 -= 180.0;
    deg3 -= 180.0;
    fill(240);
    rect(390, 40, 180, 130);
    fill(0);
    textAlign(CENTER);
    text("Graph's Axes Rotations", 480, 70);
    textAlign(NORMAL);
    float roundD1 = (float)(Math.round((deg1) * 1000000) / 1000000);
    float roundD2 = (float)(Math.round((deg2) * 1000000) / 1000000);
    float roundD3 = (float)(Math.round((deg3) * 1000000) / 1000000);
    text("X rotation = " + roundD1 + "°", 420, 100);    
    text("Y rotation = " + roundD2 + "°", 420, 120);
    text("Z rotation = " + roundD3 + "°", 420, 140);
  }
  
  // Draw Scale to screen
  void drawScale() {
    fill(240);
    rect(390, 200, 180, 140);
    fill(0);
    textAlign(CENTER);
    text("Axis Length", 482, 225);
    textAlign(NORMAL);
    line(410, 250, 550, 250);
    
    // Draw tick marks
    for (int i = 0; i <= 5; i++ ) {
        line(410+(i*28), 256, 410+(i*28), 244);
    }
    
    // Draw markers
    text("0", 410, 268);
    text("Y", 552, 268);
    
    // Label scale
    line(410, 295, 550, 295);
    line(410, 280, 410, 295);
    line(550, 280, 550, 295);
    line(480, 295, 480, 305);
    
    // Show maxValue value
    textAlign(CENTER);
    if (maxValue < 10)
      text(maxValue, 480, 320);
    else 
      text((int)maxValue, 480, 320);
    textAlign(NORMAL);
  }
  
  float getMaxValue(float maxValue) { 
     String strMax = "";
     float result;
     if (maxValue < 10) {
       strMax += maxValue;
       result = pow(10, strMax.length-2);
     } else {
       strMax += (int)maxValue;
       result = pow(10, strMax.length);
     }
     if (maxValue < 1) result = 1;
     if (maxValue < 0.1) result = 0.1;
     if (maxValue < result/2) result/=2;
     if (maxValue < result/2) result/=2;
     return result;
  }
  
}








// SCROLLBAR CLASS
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposmaxValue; // maxValue and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  boolean dragged;
  float ratio;
  int axis;
  String axisText;

  HScrollbar (float xp, float yp, int sw, int sh, int l, int axis) {
    this.axis = axis;
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)(sw / widthtoheight);
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposmaxValue = xpos + swidth - sheight;
    loose = l;
  }
  
  void draw() {
    update();
    display();
  }

  void update() {
    if (overEvent()) {
      over = true;
      cursor(HAND);
    } 
    else {
      over = false;
    }
    if (mousePressed && over) {
      dragging = true;
      dragged = true;
      locked = true;
    }
    if (!mousePressed) {
      dragging = false;
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposmaxValue);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    } else {
       if (dragged && released) {
        dragged = false;
        updateRotatedValues(axis);
       }
    }
  }

  float constrain(float val, float minv, float maxValue) {
    return min(max(val, minv), maxValue);
  }

  boolean overEvent() {
    if (!dragging && mouseX > xpos && mouseX < xpos+swidth && mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
    fill(255);
    textAlign(CENTER,CENTER);
    switch(axis) {
      case 1: axisText = "X"; break;
      case 2: axisText = "Y"; break;
      case 3: axisText = "Z"; break;
    }
    fill(0);
    text(axisText, spos+(sheight/2)+2, ypos+(sheight/2)-4);
    textAlign(NORMAL, NORMAL);
    fill(0);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }

  void resetPos() {
    xpos = 0;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
  }
}






class Vector {
  float x, y, z;
  float ratioX, ratioY, ratioZ;
  float mapX, mapY, mapZ;
//  float xRotate, yRotate, zRotate;
  float xAngle, yAngle, zAngle;
  
  Vector(Vector vec) {
    this.x = vec.x;
    this.y = vec.y;
    this.z = vec.z; 
  }
  
  Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void draw() {

    pushMatrix();
    // move the origin to the pivot point
 
    translate(200, 200, 0);
    
    // Scale coordinate system correctly
    rotateX(radians(180));
    rotateY(radians(180));
    rotateZ(radians(180));
    
    mapX = 0;
    mapY = 0;
    mapZ = 0;
    
    // Map values to scale 
    mapX = x > 0 ? map(x, 0, maxValue, 0, 150) : map(x, 0, -1*maxValue, 0, -150);
    mapY = y > 0 ? map(y, 0, maxValue, 0, 150) : map(y, 0, -1*maxValue, 0, -150);
    mapZ = z > 0 ? map(z, 0, maxValue, 0, 150) : map(z, 0, -1*maxValue, 0, -150);
    mapZ *= -1;  // z is inverted
    
//    println("x: " + x + "  y: " + y + "  z: " + z + "   max: "+maxValue);
    
//    if (mapX != mapX) mapX = 0;  // fix if empty value returned
//    if (mapY != mapY) mapY = 0;
//    if (mapZ != mapZ) mapZ = 0;
    
    
    /**** DRAW ARROW HEAD ****
     *******  Warning: Code is confusing and not perfect!  *****
       **** If you have a better way to draw the arrow head, ***
       ************  please let me know!  ************/
       
    strokeWeight(1);
    stroke(0,0,100);  
    
    // Magnitude scaled to drawing space
    float mapMag = mappedMagnitude();
    float mag = magnitude();
    
    // Find length and width values for the head
    float distance = 0.8;
    float startX = mapY*distance;
    float startY = mapZ*distance;
    float startZ = mapX*distance;
    int headLength = (int)(mapMag*0.2);
    int headWidth = headLength/4;
    
    // Find x for shapes
    int xNeg = (y>0) ? 1 : -1;
    float xFix = (y<0) ? map(y/mag, 0, -1, headWidth, 0) : map(y/mag, 0, 1, headWidth, 0);
    if (xFix != xFix) xFix = 0;
    
    // Find y for shapes
    int yNeg = (z>0) ? 1 : -1;
    float yFix = (z<0) ? map(z/mag, 0, -1, headWidth, 0) : map(z/mag, 0, 1, headWidth, 0);
    if (yFix != yFix) yFix = 0;

    // Find z for shapes
    int zNeg = (x>0) ? -1 : 1; 
    float zFix = 0;
    if (x/mag > 0) {
       if (x/mag < 0.5) 
         zFix = map(x/mag, 0, 0.5, 0, headWidth);
       else
         zFix = map(x/mag, 0.5, 1, headWidth, 0);
    } else {
       if (x/mag > -0.5) 
         zFix = map(x/mag, 0, -0.5, 0, headWidth);
       else 
         zFix = map(x/mag, -0.5, -1, headWidth, 0);
    } 
    if (zFix != zFix) zFix = 0;
    
    
    // Rectangle arrow base
    beginShape();
    fill(100,100,200);
    vertex(startX -xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(startX +xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(startX +xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    vertex(startX -xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    endShape();
    
    // Triangular 
    beginShape(TRIANGLES);
    fill(0,200,0);
    vertex(startX -xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(startX -xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    vertex(mapY,                 mapZ,                 mapX);
    
    fill(0,0,200);
    vertex(startX +xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(startX -xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(mapY,                 mapZ,                 mapX);
    
    fill(250,0,0);
    vertex(startX +xFix *xNeg,   startY -yFix *yNeg,   startZ +zFix *zNeg);
    vertex(startX +xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    vertex(mapY,                 mapZ,                 mapX);
    
    fill(150,0,150);
    vertex(startX +xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    vertex(startX -xFix *xNeg,   startY +yFix *yNeg,   startZ -zFix *zNeg);
    vertex(mapY,                 mapZ,                 mapX);
    endShape();
    

    /**** DRAW VECTOR LINE ****/
    strokeWeight(3);
    stroke(0);
    fill(0);
    line(0,0,0,mapY,mapZ,mapX);
    
    
    // reset colors and line width
    strokeWeight(1);
    stroke(0);
    fill(0);
    popMatrix();
  } 
  
  // Magnitude of vector function
  float magnitude() {
     return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)); 
  }
  
  // Mapped Magnitude of vector for drawing
  float mappedMagnitude() {
    return sqrt(pow(mapX, 2) + pow(mapY, 2) + pow(mapZ, 2)); 
  }
  
  // Print vector
  String toString() {
    return "{ "+x+" "+y+" "+z+" }"; 
  }
  
  // Get Axis angle 
  int getAngle(int a) {
     switch (a) {
       case 1: println("x angle = " + degrees(acos(x/magnitude()))); break;
       case 2: println("y angle = " + degrees(acos(y/magnitude()))); break;
       case 3: println("z angle = " + degrees(acos(z/magnitude()))); break;
     }
     return 0;
  } 
  
  // Reset vector to (0,0,0);
  void reset() {
    x = 0;
    y = 0;
    z = 0;
    maxValue = 0;
  }
  
}








/********* VectorInput CLASS ***********/
class VectorInput {
  int containerX, containerY;
  int containerWidth = 124;
  int containerHeight = 30;
  int textBoxX, textBoxY;
  int textBoxWidth = 90;
  int textBoxHeight = 24;
  int textX, textY;
  int textWidth = 82;
  int textHeight = 16;
  int axis;
  String axisText;
  
  public String input = "0";
  public boolean clickedOn = false;
  public boolean highlighted = false;
  public boolean typing = false;

  VectorInput(int x, int y, int axis) {
    this.containerX = x;
    this.containerY = y;
    this.textBoxX = x+5;
    this.textBoxY = y+3;
    this.textX = textBoxX+4;
    this.textY = textBoxY+4;
    this.axis = axis;
  }
  void draw() {
    fill(205);
    if (over()) {
      fill(225);
    }
    // Container
    rect(containerX, containerY, containerWidth, containerHeight);
    fill(255);
    // Text Box Container
    rect(textBoxX, textBoxY, textBoxWidth, textBoxHeight);
    // Text Container
    fill(255);
    if (highlighted) 
      fill(100, 100, 220, 100);
    if (typing)
      fill(0,0,0,50);
    noStroke();
    rect(textX, textY, textWidth, textHeight);
    fill(0);
    text(input, textX+2, textY+12);
    switch(axis) {
      case 1: axisText = "x"; break;
      case 2: axisText = "y"; break;
      case 3: axisText = "z"; break;
    }
    text(axisText, textX+textBoxWidth+6, textY+14);
    text("^", textX+textBoxWidth+6, textY+7);
    stroke(0);
  }
  boolean over() {
    if (mouseX >= textBoxX && mouseY >= textBoxY && mouseX <= textBoxX + textBoxWidth && mouseY <= textBoxY + textBoxHeight) {
      cursor(TEXT);
      return true;
    }
    return false;
  }
  void checkMousePress() {
   if (over()) {
      if (!highlighted && !clickedOn) {
          highlighted = true;
          clickedOn = true;
      } else {
          typing = true;
      }
    } else {
      clickedOn = false;
      highlighted = false;
      typing = false;
    } 
  }
}







class rMatrix {
  int[][] xMatrix, yMatrix, zMatrix;
  int neg1;
  int neg2;
  
  Vector rotationX(Vector vec, float theta) {
     theta = radians(theta); // convert angle to radians
     float x = vec.x*1 + vec.y*0 + vec.z*0;
     float y = vec.x*0 + vec.y*cos(theta) + vec.z*-sin(theta);
     float z = vec.x*0 + vec.y*sin(theta) + vec.z*cos(theta); 
     // return result
     return new Vector(x,y,z);
  }
  
  Vector rotationY(Vector vec, float theta) {
     theta = radians(theta); // convert angle to radians
     float x = vec.x*cos(theta) + vec.y*0 + vec.z*sin(theta);
     float y = vec.x*0 + vec.y*1 + vec.z*0;
     float z = vec.x*-sin(theta) + vec.y*0 + vec.z*cos(theta); 
     // return result
     return new Vector(x,y,z);
  }
  
  Vector rotationZ(Vector vec, float theta) {
     theta = radians(theta); // convert angle to radians
     float x = vec.x*cos(theta) + vec.y*-sin(theta) + vec.z*0;
     float y = vec.x*sin(theta) + vec.y*cos(theta) + vec.z*0;
     float z = vec.x*0 + vec.y*0 + vec.z*1; 
     // return result
     return new Vector(x,y,z);
  }
  
}
         
         
         


















