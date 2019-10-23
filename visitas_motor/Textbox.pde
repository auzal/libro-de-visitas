class Textbox {

  float x = 0;
  float y = 0;
  float w;
  float h;
  String text;
  String state; 
  boolean draw_cursor;
  boolean is_focused;
  boolean is_number;
  boolean is_int = false;
  float value;
  float p_value;
  boolean is_float;
  int line_height;

  boolean change_flag = false;

  color BORDE;
  color FONDO;
  color ACTIVO;
  color CURSOR;
  color FUENTE;
  color NOMBRE;

  PFont font;

  String id;
  PFont font_id;

  int decimals = 3;

  int margin;

  boolean display_saved;

  String id_eng;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Textbox(float x_, float y_, float w_, float h_) {

    pushStyle();
    colorMode(RGB, 255);
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    text = "";
    state = "STAND BY";

    FONDO = color(255, 90);    
    BORDE = color(255);
    ACTIVO = color(241, 92, 9, 70);
    CURSOR = color(#FFFCA5);
    FUENTE = color(255);
    NOMBRE = color(200);

    popStyle();

    is_float = false;
    is_number = false;

    font = createFont("Arial", 10);
    font_id = createFont("Arial", 10);

    id = "id";
    margin = 5;
    line_height  = 15; //// ESTO ESTA PUESTO A MANO MAL, VA EN FUNCION DE LA FUENTE FONT
    is_focused = false;

    value = 0;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {

    pushStyle();

    colorMode(RGB, 255);

    fill(FONDO);
    stroke(BORDE);
    strokeWeight(1);

    if (state == "CARGANDO") 
      fill(255, 40);
    else
      noFill();
    rectMode(CORNER);
    rect(x, y, w, h, 5);

    // stroke(70);
    //  line(x, y+h+1, x+w, y+h+1);
    // stroke(22);
    //  line(x+1, y+1, x+w-1, y+1);
    fill(FUENTE);
    textFont(font);
    textAlign(LEFT, CENTER);

    String [] rows = new String[0];
    String buffer = "";
    String aux = text;
    if (is_number) {
    }
    for (int i = 0; i < aux.length (); i++) {

      buffer += aux.charAt(i);
      // println("ANCHO TEXTO"+ ancho);
      if (textWidth(buffer) > w - 10) {
        rows = append(rows, buffer);
        aux = aux.substring(i);
        // println("LO QUE QUEDA  " + aux);
        i = 0;
        buffer = "";
        // break;
      }
    }
    if ( ! buffer.equals("")) {

      rows = append(rows, buffer);
    }

    if (rows.length == 0)
      rows = append(rows, "");

    for (int i = 0; i < rows.length; i++) {

      text(rows[i], x + margin, y + line_height /2 + i*line_height + 3);
    }

    if (state == "CARGANDO") {
      stroke(ACTIVO);
      noFill();
      strokeWeight(1);
      //  rect(x-2, y-2, w + 4, h +4);
      drawCursor(rows);
    }

    fill(NOMBRE);
    textFont(font_id);
    if (lang.equals("ENGLISH"))
      text(id_eng, x, y + h+13);
    else
      text(id, x, y + h+13);

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update( char k) {

    if (!is_number) {

      if (k == ENTER  || k==RETURN) {
        unFocus();
        state = "STAND BY";
        // println("+" + texto + "+");
      } else if ( k == BACKSPACE) {

        String aux = text;
        text = "";
        for (int i = 0; i < aux.length () -1; i++) {
          text += aux.charAt(i);
        }
      } else {
        if (k !=CODED && k != TAB){
          if(text.length() < CHAR_LIMIT)
          text += k;
        }
      }
    } else {   ///------------------------- ESTE ES EL CODIGO DEL MODO NUMERICO



      if (k == ENTER || k==RETURN) {
        state = "STAND BY";

        unFocus();
        // println("+" + texto + "+");
        int factor = 100;
        float aux_num = float(text);
        //  value = int(aux_num * factor);
        // value = value/(factor*1.0);
        value = aux_num;

        checkDecimals();

        if (value != p_value) 
          raiseFlag();


        //  value  = float(text);
        // println("el valor en numeritos es:  " + valor);
      } else if ( k == BACKSPACE) {

        if (text.length() <= 1)
          text = "";
        else {
          String aux = text;
          text = "";  
          for (int i = 0; i < aux.length () -1; i++) {
            text += aux.charAt(i);
          }
          if (aux.charAt(aux.length()-1) == 46) {
            is_float = false;
          }
        }
      }

      /// desde aca la carga
      else if (((k > 47 && k < 58) || k == 46 || (k == 45 && text.length() == 0)) && k != TAB  ) {


        int curr_decimals = 0;

        if (is_float) {

          int decimal_index = 0;
          for (int i = 0; i < text.length (); i++) {
            if (text.charAt(i) == 46) {
              decimal_index = i;
            }
          }

          if (decimal_index!=0) {

            curr_decimals  = (text.length() - 1 ) - decimal_index;
          }
        }

        if (k == 46 && !is_float && !is_int) {
          text += k;
          is_float = true;
        } else if (k != 46  && curr_decimals < decimals)
          text += k;
      }
    }  ///---------------------------------------------- HASTA ACA
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkMouse() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      state = "CARGANDO";
      focus();      // texto = "";
    } else {
      state = "STAND BY";
      unFocus();
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean checkKeys() {

    boolean flag = false;
    if (state == "CARGANDO") {

      flag = true;
      update(key);
    }
    return flag;
  }

  //*****************************************************************

  void drawCursor(String[] r) {

    pushStyle();
    if (frameCount % 10 == 0)
      draw_cursor = !draw_cursor;

    if (draw_cursor) {

      float w_cursor = 5;
      float h_cursor = textAscent() + textDescent() - 4;
      float x_cursor;

      if (r.length > 1)
        x_cursor = textWidth(r[r.length-1]);
      else
        x_cursor = textWidth(text);
      float y_cursor = y + r.length * line_height - h_cursor/2;

      stroke(CURSOR, 128);
      strokeWeight(2);
      noFill();
      rectMode(CENTER);
      line(x + x_cursor  +8, y_cursor, x + x_cursor + 8, y_cursor  + h_cursor);
      // rect(x+x_cursor + 7, y_cursor -3, w_cursor, h_cursor);
      popStyle();
      //line(x+x_cursor,y,x+x_cursor,y+20);
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  String getText() {
    return text;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean getFocus() {
    return is_focused;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  float getValue() {
    return value;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  int getIntValue() {
    return int(value);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setText(String s) {
    text = "";
    is_float = false;
    p_value = value;


    for (int i = 0; i < s.length(); i++ ) {
      if (is_int) {
        if (s.charAt(i) == 46) {
          break;
        }
      }

      update(s.charAt(i));
    }

    update(RETURN);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void addText(String s) {
    text += s;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void erase() { 
    text="";
    if (is_number)
      is_float = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void focus() {
    state = "CARGANDO";
    is_focused = true;
    p_value = value;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void unFocus() {

    if (is_number) {
      if (text.equals("-") || text.equals("-0")) {

        text = "";
      }
    }

    state = "STAND BY";
    is_focused = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setNumber() {

    is_number = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setNotNumber() {

    is_number = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setEdgeColor(color c) {

    BORDE = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setBackColor(color c) {

    FONDO = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFontColor(color c) {

    FUENTE = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setCursorColor(color c) {

    CURSOR = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setActiveColor(color c) {

    ACTIVO = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void  setIdColor(color c) {

    NOMBRE = c;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setId(String s) {

    id = s;
  }
   //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setIdEng(String s) {

    id_eng = s;
  }


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  String getId() {

    return id;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFont(PFont f) {

    font = f;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFontId(PFont f) {
    font_id = f;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void move(int dx, int dy) {
    x += dx;
    y += dy;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setPosition(float x_, float y_) {
    x = x_;
    y = y_;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setAsInt() {
    is_int = true;
    setText(text);
  }
  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void raiseFlag() {
    change_flag = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void lowerFlag() {
    change_flag = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkDecimals() {

    int curr_decimals = 0;

    if (is_float) {

      int decimal_index = 0;
      for (int i = 0; i < text.length (); i++) {
        if (text.charAt(i) == 46) {
          decimal_index = i;
        }
      }

      if (decimal_index!=0) {

        curr_decimals  = (text.length() - 1 ) - decimal_index;
      }

      if (curr_decimals < decimals ) {

        for (int i = curr_decimals; i < decimals; i++) {
          text += '0';
        }
      }
    }
  }
}