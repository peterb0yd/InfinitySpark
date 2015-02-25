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
  Axis axis;
  
  public String input = "0";
  public boolean clickedOn = false;
  public boolean highlighted = false;
  public boolean typing = false;

  VectorInput(int x, int y, Axis axis) {
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
    text(axis.toString().toLowerCase(), textX+textBoxWidth+6, textY+14);
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

