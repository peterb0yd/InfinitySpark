// SCROLLBAR CLASS
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  boolean dragged;
  float ratio;
  Axis axis;

  HScrollbar (float xp, float yp, int sw, int sh, int l, Axis axis) {
    this.axis = axis;
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
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
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
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

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
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
    text(axis.toString(), spos+(sheight/2), ypos+(sheight/2)-2);
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
