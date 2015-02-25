import java.util.Arrays;
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
public float max = 0;
boolean error = false;

void setup() {
  size(600, 620, P3D);
  smooth();
  
  vector = new Vector(0,0,0);
  rMat = new rMatrix();
  graph = new Graph_3d();
  
  // Set Horizontal Scrollbars properties
  hs1 = new HScrollbar(0, 380, width, 16, 16, Axis.X); // hs1 is Z
  hs2 = new HScrollbar(0, 400, width, 16, 16, Axis.Y); // hs2 is X
  hs3 = new HScrollbar(0, 420, width, 16, 16, Axis.Z); // hs3 is Y
  scrollBars.addAll(Arrays.asList(hs1, hs2, hs3));

  // Set button properties
  resetGraphButton = new Button(width/2-90, 444, 180, 40, "Reset Graph");
  updateVectorButton = new Button(width/2+10, 500, 100, 45, "Update");
  resetVectorButton = new Button(width/2+10, 545, 100, 45, "Reset");
  
  // Set Vector Input properties
  vecX = new VectorInput(width/2+110, 500, Axis.X);
  vecY = new VectorInput(width/2+110, 530, Axis.Y);
  vecZ = new VectorInput(width/2+110, 560, Axis.Z);
  vectorInputs.addAll(Arrays.asList(vecX, vecY, vecZ));
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
          vecInput.input += key;
        } 
        vecInput.highlighted = false;
        vecInput.typing = true;
      } else {
        if (key == BACKSPACE && vecInput.input.length() > 0) {
          vecInput.input = vecInput.input.substring(0, vecInput.input.length()-1);
        } else {
          if (vecInput.input.length() < 10 && keyIsNumber(key)) {
             vecInput.input += key;
          }
        }
      }
    }
  }
}

// Draw vector to graph
void updateVector() {
    float originalMax = max;
    try {
      float[] comp = new float[3];  // vector component holder
      max = 0;
      for (int i = 0; i < 3; i++) {
         VectorInput vecInput = vectorInputs.get(i);
         if (vecInput.input.isEmpty()) {  // vector input empty
            comp[i] = 0;
            vecInput.input = "0";
         } else {
            comp[i] = Float.parseFloat(vecInput.input);  // convert input to float
         }
         
         // Get max component for Scaling
         if (comp[i] < 0) {  
           if (comp[i]*-1 > max) max = comp[i]*-1;   // max is negative
         } else {
           if (comp[i] > max) max = comp[i];   // max is positive
         } 
      }
      error = false;
      max = (float)Math.round((max*1.2) * 100) / 100;
      max = graph.getMax(max);
      vector = new Vector(comp[0], comp[1], comp[2]);  // initialize vector
      checkGraphRotation();
    } catch (NumberFormatException e) {  // input error
      error = true;
      max = originalMax;
      return;
    }
    
}

void mouseReleased() {
  released = true;
}

// Update rotation vector values
void updateRotatedValues(Axis a) {
  switch (a) {
     case X: rotatedVector = new Vector(rMat.rotationX(vector, graph.deg1)); break;  // normal X
     case Y: rotatedVector = new Vector(rMat.rotationY(vector, graph.deg2)); break;  // normal Y  
     case Z: rotatedVector = new Vector(rMat.rotationZ(vector, graph.deg3)); break;  // normal Z
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
   text("x: " + rotatedVector.x, 200, 540);
   text("y: " + rotatedVector.y, 200, 560);
   text("z: " + rotatedVector.z, 200, 580);
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
   if (Float.isNaN(xAngle)) xAngle = 0;
   if (Float.isNaN(yAngle)) yAngle = 0;
   if (Float.isNaN(zAngle)) zAngle = 0;
   text("x: " + xAngle, 80, 540);
   text("y: " + yAngle, 80, 560);
   text("z: " + zAngle, 80, 580);
}

// Check if Typed Key is number
boolean keyIsNumber(char k) {
   String nums = "0123456789.-";
   String s = "" + k;
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
    updateRotatedValues(Axis.X);
  } 
  if (graph.deg2 != 0) {            // check Y rotation value  
    updateRotatedValues(Axis.Y);  
  }
  if (graph.deg3 != 0) {            // check Z rotation value
    updateRotatedValues(Axis.Z);
  }
}


// Show input-error message
void showInputError() {
   fill(255,0,0);
   text("Error: incorrect value(s) entered", width/2-90, 610);
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

