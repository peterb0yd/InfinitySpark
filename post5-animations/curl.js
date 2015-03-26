var c = function( sketch ) {

  var dim,
  locs = [],
  moveX, moveY,
  length, angle,
  slider,
  myCanvas;

  sketch.setup = function() {
    myCanvas = sketch.createCanvas(sketch.windowWidth/1.4, sketch.windowWidth/3);
    myCanvas.parent('curlContainer');

    slider = sketch.makeSlider(-50, 50, 0);
    slider.position = sketch.createVector(10, sketch.height-20);
    slider.buttonPos = sketch.createVector(sketch.width/2, sketch.height-30);
    slider.size = sketch.createVector(sketch.width-30, 10);
    slider.buttonSize = sketch.createVector(10, 30);

    dim = sketch.width/20;
    sketch.colorMode(sketch.RGB);
    sketch.ellipseMode(sketch.RADIUS);

    var res = 30;
    var countX = sketch.ceil(sketch.width/res) + 1;
    var countY = sketch.ceil(sketch.height/res) - 1;

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

    // Update slider
    slider.update();

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
      sketch.push();
      var x = locs[i].x;
      var y = locs[i].y;
      var deltaX = moveX - x;
      var deltaY = moveY - y;
      angle = sketch.atan2(deltaY, deltaX);
      length = sketch.getLength(deltaX, deltaY);
      sketch.translate(x,y);
      sketch.rotate(angle);
      sketch.line(0, 0, length, 0);
      sketch.fill(0);
      sketch.triangle(length, 2, length, -2, length+3, 0);
      sketch.pop();
    }

    // Draw grav source in middle
    sketch.noStroke();
    sketch.drawGradient(moveX, moveY);
  };

  // Get length of each vector
  sketch.getLength = function(x, y) {
    if (x < 0) x *= -1;
    if (y < 0) y *= -1;
    var len = sketch.map(x+y, 0, 1000, 1.1, 0);
    if (slider.value < 0) {
      len = Math.pow(slider.value*-1, len);
      angle -= 180/Math.PI;
    } else {
      len = Math.pow(slider.value, len);
      angle += 180/Math.PI;
    }
    return len;
  };

  // Draw red heat source
  sketch.drawGradient = function(x, y) {
    var radius = 30;
    for (var r = radius; r > 0; --r) {
      var alpha = sketch.map(r, 0, radius, 100, 0);
      sketch.fill(20, 20, 200, alpha);
      sketch.ellipse(x, y, r, r);
    }
  };

  // Make Slider
  sketch.makeSlider = function(start, end, val) {
    this.start = start;
    this.end = end;
    this.value = val;
    this.newspos = 0;
    this.position = sketch.createVector(0,0);
    this.buttonPos = sketch.createVector(0,0);
    this.size = sketch.createVector(0,0);
    this.buttonSize = sketch.createVector(0,0);
    this.isDragging = false;
    this.mouseOver = function() {
      if ( sketch.contains(this.buttonPos, this.buttonSize) ) {
        sketch.cursor(sketch.HAND);
        return true;
      }
      sketch.cursor(sketch.ARROW);
      return false;
    };
    this.checkDragging = function() {
      if ( this.mouseOver() && sketch.mouseIsPressed ) {
        this.isDragging = true;
      }
      if (!sketch.mouseIsPressed) {
        this.isDragging = false;
      }
    }
    this.update = function() {
      this.checkDragging();
      if (this.isDragging) {
        newspos = sketch.constrain(sketch.mouseX-this.size.y/2, 10, sketch.width-30);
        if (Math.abs(newspos - this.buttonPos.x) > 1) {
          this.buttonPos.x = this.buttonPos.x + (newspos-this.buttonPos.x)/2;
        }
        this.buttonPos.x = sketch.constrain(sketch.mouseX, 10, sketch.width-30);
        this.value = sketch.map(this.buttonPos.x, 0, sketch.width, -50, 50);
      }
      sketch.fill(200);
      sketch.rect(this.position.x, this.position.y, this.size.x, this.size.y);
      sketch.fill(0);
      sketch.rect(this.buttonPos.x, this.buttonPos.y, this.buttonSize.x, this.buttonSize.y);
    };
    return this;
  };

  // shape contains mouse method
  sketch.contains = function(pos, size) {
     if (sketch.mouseX > pos.x && sketch.mouseX < pos.x + size.x 
      && sketch.mouseY > pos.y && sketch.mouseY < pos.y + size.y) {
      return true
     }
     return false;
  }

  // slider constrain
  sketch.constrain = function(val, minv, maxv) {
    return Math.min(Math.max(val, minv), maxv);
  }

  // check if mouse left canvas
  document.getElementById('curlContainer').onmouseover = function() {
    sketch.loop(); // start looping
  }
  document.getElementById('curlContainer').onmouseout = function() {
    sketch.noLoop(); // stop looping
  }

  $(window).resize(function(event) {
    document.getElementById('curlContainer').style.height = sketch.windowWidth/3;
    myCanvas.size(sketch.windowWidth/1.4, sketch.windowWidth/3);
    slider.position = sketch.createVector(10, sketch.height-10);
    slider.size = sketch.createVector(sketch.windowWidth/1.4-30, 10);
    slider.buttonPos.x = slider.position.x + (slider.size.x/2);
    slider.buttonPos.y = slider.position.y - 10;
  });

};

var myC = new p5(c, 'curlContainer');