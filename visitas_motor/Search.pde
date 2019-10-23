class Search {
  float x;
  float y;
  Textbox box;
  PImage icon;
  String query;
  PFont font = null;
  PFont small_font = null;
  boolean active = false;
  boolean draw_cursor = false;
  float x_cursor;
  float aprox_width = 115;
  float aprox_height = 25;
  int offset = 5;
  int notification_opacity = 0;
  boolean show_notification = false;
  String notification = "";

  Table table;



  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Search() {
    icon = loadImage("glyph_search_2.png");
    reset();
    loadQuerys();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {
    pushStyle();
    image(icon, x, y+3);

    if (font != null) {
      textFont(font);
    }
    float line_height = textAscent() + textDescent();
    fill(200);
    textAlign(LEFT, TOP);    
    text(query, x + icon.width + 10, y);
    stroke(200);
    line(x + icon.width + 10, y+line_height, x+115, y+line_height);

    if (active && draw_cursor) {
      strokeWeight(2);
      stroke(#FFFCA5, 128);
      line(x_cursor + 2, y + 3, x_cursor + 2, y + line_height - 3);
      strokeWeight(1);
    }

    if (show_notification) {
      pushStyle();
      textSize(18);
      if (small_font != null)
        textFont(small_font);
      fill(#FFD255, notification_opacity);
      if (lang.equals("ENGLISH")) {
        if (notification.equals( "Ingrese al menos 3 caracteres")) {
          text("Type at least three characters", x + icon.width + 10, y + line_height + offset);
        } else if (notification.equals( "No hay resultados")) {
          text("There are no results", x + icon.width + 10, y + line_height + offset);
        }
      } else
        text(notification, x + icon.width + 10, y + line_height + offset);
      popStyle();
    }  

    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    pushStyle();
    if (active) {
      if (font != null)
        textFont(font);
      x_cursor = x + icon.width + 10 + textWidth(query);
      if (frameCount % 20 == 0) {
        draw_cursor = ! draw_cursor;
      }

      if (show_notification) {
        if (notification_opacity < 255)
          notification_opacity += 2;
      }
    }
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setPosition(float x_, float y_) {
    x = x_;
    y = y_;
    x_cursor = x + 10;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFonts(PFont f, PFont f_s) {
    font = f;
    small_font = f_s;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkMouse() {
    if (mouseX > x  && mouseX < x + aprox_width && mouseY > y && mouseY < y + aprox_height) {
      if (! active) {
        active = true;
        query = "";
      }
    } else {
      reset();
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean keys() {
    boolean ret = false;

    if (active) {
      ret = true;
      updateQuery(key);
    }
    return ret;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void updateQuery(char k) {
    if (k == ENTER  || k==RETURN) {
      fireSearch();
    } else if ( k == BACKSPACE) {
      String aux = query;
      query = "";
      for (int i = 0; i < aux.length () -1; i++) {
        query += aux.charAt(i);
      }
    } else {
      if (k !=CODED && k != TAB)
        query += k;
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireSearch() {
    notification = "";
    if (query.length() < 3) {
      notification = "Ingrese al menos 3 caracteres";
      show_notification = true;
      notification_opacity = 0;
    } else {
      boolean has_results = network.compare(query);
      if (!has_results) {
        notification = "No hay resultados";
        show_notification = true;
        notification_opacity = 0;
      }
      addQuery(query);
    }
  }

  void checkQueryLang() {
    if (lang.equals("CASTELLANO")){
      if (query.equals("Search"))
        query = "Búsqueda";
    }else if (lang.equals("ENGLISH")){
       if (query.equals("Búsqueda"))
        query = "Search";
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void reset() {
    active = false;
    if (lang.equals("CASTELLANO"))
    query = "Búsqueda";
    else
      query = "Search";
    show_notification = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void loadQuerys() {

    try {
      table = loadTable("data/Repo/Busquedas.csv");
    }
    catch(Exception e) {

      table = null;
    }

    if (table == null) {

      table = new Table();

      table.addColumn("Búsqueda");
      table.addColumn("Fecha y hora");
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void addQuery(String s) {

    TableRow newRow = table.addRow();

    String ts  = day() + "/" + month() + "/" + year() + " - " + hour() + ":" + minute() + ":" + second();

    newRow.setString(0, s);
    newRow.setString(1, ts);

    saveTable(table, "data/Repo/Busquedas.csv");
  }
}