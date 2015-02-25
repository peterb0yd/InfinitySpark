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
    drawMarks(Axis.X);
    text("X", 0, 0, 155);
    text("-X", 0, 0, -155);

    // Y Coordinate
    line(150, 0, 0, -150, 0, 0);
    drawMarks(Axis.Y);
    text("Y", 155, 0, 0);
    text("-Y", -165, 0, 0);

    // Z Coordinate
    line(0, 150, 0, 0, -150, 0);
    drawMarks(Axis.Z);
    text("Z", 0, -160, 0);
    text("-Z", 0, 160, 0);

    popMatrix();
  }


  // Draw Axis Marks
  void drawMarks(Axis axis) {
    switch (axis) {
    case X:
      for (int i = 0; i <= 10; i++ ) {
        line(0, 5, -150+(i*30), 0, -5, -150+(i*30));
      }
      break;
    case Y:
      for (int i = 0; i <= 10; i++ ) {
        line(-150+(i*30), 5, 0, -150+(i*30), -5, 0);
      }
      break;
    case Z:
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
    text("X rotation = " + deg1 + "°", 400, 100);    
    text("Y rotation = " + deg2 + "°", 400, 120);
    text("Z rotation = " + deg3 + "°", 400, 140);
  }
  
  // Draw Scale to screen
  void drawScale() {
    fill(240);
    rect(390, 200, 180, 140);
    fill(0);
    textAlign(CENTER);
    text("Axis Length", 480, 230);
    textAlign(NORMAL);
    line(410, 250, 550, 250);
    
    // Draw tick marks
    for (int i = 0; i <= 5; i++ ) {
        line(410+(i*28), 256, 410+(i*28), 244);
    }
    
    // Draw markers
    text("0", 405, 271);
    text("Y", 545, 271);
    
    // Label scale
    line(410, 295, 550, 295);
    line(410, 280, 410, 295);
    line(550, 280, 550, 295);
    line(480, 295, 480, 305);
    
    // Show Max value
    textAlign(CENTER);
    if (max < 10)
      text(max, 480, 320);
    else 
      text((int)max, 480, 320);
    textAlign(NORMAL);
  }
  
  float getMax(float max) { 
     float result = pow(10, Float.toString(max).length()-2);
     if (max < 1) result = 1;
     if (max < 0.1) result = 0.1;
     if (max < result/2) result/=2;
     if (max < result/2) result/=2;
     return result;
  }
  
}

