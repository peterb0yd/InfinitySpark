var g = function( sketch ) {
  
  var dim,
  locs = [],
  moveX, moveY,
  myCanvas;

  sketch.setup = function() {
    myCanvas = sketch.createCanvas(sketch.windowWidth/1.4, sketch.windowWidth/3);
    myCanvas.parent('gradientContainer');

    dim = sketch.width/20;
    sketch.colorMode(sketch.RGB);
    sketch.ellipseMode(sketch.RADIUS);

    var res = 30;
    var countX = sketch.ceil(sketch.width/res) + 1;
    var countY = sketch.ceil(sketch.height/res) + 1;

    // Set all vector locations
    for (var j = 0; j < countY; j++) {
      for (var i = 0; i < countX; i++) {
        locs.push( new p5.Vector(res*i, res*j) );
      }
    };

    sketch.noFill();
    sketch.stroke(0);
    sketch.noLoop();
  };

  sketch.draw = function() {
    sketch.background(255);

    // Get device type
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
      moveX = sketch.touchX;
      mouveY = sketch.touchY;
    } else {
      moveX = sketch.mouseX;
      moveY = sketch.mouseY;
    }

    // Draw each vector
    for (var i = locs.length - 1; i >= 0; i--) {
      var x = locs[i].x;
      var y = locs[i].y;
      var deltaX = moveX - x;
      var deltaY = moveY - y;
      var angle = sketch.atan2(deltaY, deltaX);
      var length = sketch.getLength(deltaX, deltaY);
      sketch.push();
      sketch.translate(x,y);
      sketch.rotate(angle);
      sketch.line(0, 0, length, 0);
      sketch.fill(0);
      sketch.triangle(length, 2, length, -2, length+3, 0);
      sketch.pop();
    }

    // Draw heat source on mouse
    sketch.noStroke();
    sketch.drawGradient(moveX, moveY);
  };

  // Get length of each vector
  sketch.getLength = function(x, y)  {
    if (x < 0) x *= -1;
    if (y < 0) y *= -1;
    var len = sketch.map(x+y, 0, 2000, 0, 100);
    if (len > 50) len = 50;
    return len;
  };

  // Draw red heat source
  sketch.drawGradient = function(x, y)  {
    var radius = 20;
    for (var r = radius; r > 0; --r) {
      var alpha = sketch.map(r, 0, radius, 100, 0);
      sketch.fill(255, 0, 0, alpha);
      sketch.ellipse(x, y, r, r);
    }
  };

  // check if mouse left canvas
  document.getElementById('gradientContainer').onmouseover = function() {
    sketch.loop();
  }
  document.getElementById('gradientContainer').onmouseout = function() {
    sketch.noLoop();
  }

  $(window).resize(function(event) {
      document.getElementById('gradientContainer').style.height = sketch.windowWidth/3;
      myCanvas.size(sketch.windowWidth/1.4, sketch.windowWidth/3);
  });
};

var myG = new p5(g, 'gradientContainer');