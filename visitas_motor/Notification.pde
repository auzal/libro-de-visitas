class Notification {
  float x;
  float y;
  PFont font = null;
  String [] text;
  int life_time = NOTIFICATION_LIFE_TIME;
  int fire_time = 0;
  boolean alive = false;
  String [] text_eng;

  Notification() {
    x = width/2;
    y = height/2;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {
    pushStyle();
    textAlign(LEFT, CENTER);
    if (font != null )
      textFont(font);
    fill(#00BFB3);

    String[] render_text = text;
    if (lang.equals("ENGLISH"))
      render_text = text_eng;

    float line_height = textAscent() + textDescent();

    line_height *= 1.5;

    float h = line_height * render_text.length;

    float text_y = height / 2 - h / 2;

    for (int i = 0; i < render_text.length; i ++) {

      text(render_text[i], x-300, text_y + ( line_height  * i));
    }

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    if (millis() - fire_time > life_time)
      alive = false;


    if (millis() - fire_time >1000) {
      if (mousePressed || keyPressed)
        alive = false;
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFont(PFont f) {

    font = f;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireTimer() {
    fire_time = millis();
    alive = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setText(String []  t) {

    text = t;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••



  void setTextEng(String []  t) {

    text_eng = t;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}