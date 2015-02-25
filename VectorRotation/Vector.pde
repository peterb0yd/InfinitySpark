class Vector {
  public float x, y, z;
  float ratioX, ratioY, ratioZ;
  float mapX, mapY, mapZ;
  float rotateX, rotateY, rotateZ;
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
    
    // Map values to scale 
    mapX = x > 0 ? map(x, 0, max, 0, 150) : map(x, 0, -1*max, 0, -150);
    mapY = y > 0 ? map(y, 0, max, 0, 150) : map(y, 0, -1*max, 0, -150);
    mapZ = z > 0 ? map(z, 0, max, 0, 150) : map(z, 0, -1*max, 0, -150);
    mapZ *= -1;  // z is inverted
    if (Float.isNaN(mapX)) mapX = 0;  // fix if empty value returned
    if (Float.isNaN(mapY)) mapY = 0;
    if (Float.isNaN(mapZ)) mapZ = 0;


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
    if (Float.isNaN(xFix)) xFix = 0;
    
    // Find y for shapes
    int yNeg = (z>0) ? 1 : -1;
    float yFix = (z<0) ? map(z/mag, 0, -1, headWidth, 0) : map(z/mag, 0, 1, headWidth, 0);
    if (Float.isNaN(yFix)) yFix = 0;

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
    if (Float.isNaN(zFix)) zFix = 0;
    
    
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
  int getAngle(Axis a) {
     switch (a) {
       case X: println("x angle = " + degrees(acos(x/magnitude()))); break;
       case Y: println("y angle = " + degrees(acos(y/magnitude()))); break;
       case Z: println("z angle = " + degrees(acos(z/magnitude()))); break;
     }
     return 0;
  } 
  
  // Reset vector to (0,0,0);
  void reset() {
    x = 0;
    y = 0;
    z = 0;
    max = 0;
  }
  
}
