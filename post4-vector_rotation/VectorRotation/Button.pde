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
