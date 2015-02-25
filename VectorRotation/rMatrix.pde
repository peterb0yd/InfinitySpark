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
         
