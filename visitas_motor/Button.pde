 class Button {

  float x;
  float y;
  float w;
  float h;
  String id;
  PFont font = null;
  boolean hover = false;
  boolean pressed = false;

  String id_eng ="";

  Button(float x_, float y_, String id_) {

    x = x_;
    y = y_;
    id  = id_;
    calculateDimensions();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {
    calculateDimensions();
    pushStyle();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    stroke(#133E36);
    if (hover)
      fill(#00F5CA, 40);
    else 
    noFill();


    noStroke();
    fill(255, 30);
    rect(x, y, w, h, 5);
    if (hover)
      fill(#D8FFF7);
    else
      fill(200);
    if (font != null)
      textFont(font);
    if (lang.equals("CASTELLANO"))
      text(id, x, y-3);
    else
      text(id_eng, x, y-3);
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {

    if (mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2 ) {
      hover = true;
    } else 
    hover = false;
    
    calculateDimensions();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkMouse() {
    if (hover)
      press();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void calculateDimensions() {
    pushStyle();

    if (font != null)
      textFont(font);
    float margin_h = 3;
    float margin_w = 5;

    h = textAscent() + textDescent() + margin_h  * 2;
    if (lang.equals("CASTELLANO"))
      w = textWidth(id)  + margin_w  * 2;
    else
      w = textWidth(id_eng)  + margin_w  * 2;

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void press() {
    pressed = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void unPress() {
    pressed = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean isPressed() {
    return pressed;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFont(PFont f) {
    font = f;
    calculateDimensions();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setId(String id_) {
    id = id_;
    calculateDimensions();
  }


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setPosition(float x_, float y_) {
    x = x_;
    y = y_;
  }


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setIdEng(String id_) {
    id_eng = id_;
  }



  //
}