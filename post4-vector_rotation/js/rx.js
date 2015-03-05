function rotationX(vec, theta) {
   var x = vec.x*1 + vec.y*0 + vec.z*0;
   var y = vec.x*0 + vec.y*Math.cos(theta) + vec.z*Math.sin(theta);
   var z = vec.x*0 + vec.y*-Math.sin(theta) + vec.z*Math.cos(theta); 
   return new THREE.Vector3(x,y,z);
}

function rotationY(vec, theta) {
   var x = vec.x*Math.cos(theta) + vec.y*0 + vec.z*-Math.sin(theta);
   var y = vec.x*0 + vec.y*1 + vec.z*0;
   var z = vec.x*Math.sin(theta) + vec.y*0 + vec.z*Math.cos(theta); 
   return new THREE.Vector3(x,y,z);
}

function rotationZ(vec, theta) {
   var x = vec.x*Math.cos(theta) + vec.y*Math.sin(theta) + vec.z*0;
   var y = vec.x*-Math.sin(theta) + vec.y*Math.cos(theta) + vec.z*0;
   var z = vec.x*0 + vec.y*0 + vec.z*1; 
   return new THREE.Vector3(x,y,z);
}