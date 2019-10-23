PVector[] distribute(int num_points, int rad) {
  // calculating sphere distribution
  // constants 
  float dphi = PI*(3-sqrt(5));
  float phi = 0;
  float dz = 2.0/float(num_points);
  float z = 1 - dz/2.0;

  PVector [] points = new PVector[num_points];
  for (int i = 0; i < num_points; i++) {

    float r = rad*sqrt(1-z*z); 
    float posx = r*cos(phi); 
    float posy = r*sin(phi); 
    float posz = rad*z;

    PVector vector_aux = new PVector(posx, posy, posz);
    // println(vector_aux);
    points[i] = (PVector)vector_aux;      
    // println(nodes.length());
    z = z - dz;
    phi = phi + dphi;
  }

  return points;
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

PVector[] distribute(int num_points, int rad, PVector offset) {
  // calculating sphere distribution
  // constants 
  float dphi = PI*(3-sqrt(5));
  float phi = 0;
  float dz = 2.0/float(num_points);
  float z = 1 - dz/2.0;

  PVector [] points = new PVector[num_points];
  for (int i = 0; i < num_points; i++) {

    float r = rad*sqrt(1-z*z); 
    float posx = r*cos(phi); 
    float posy = r*sin(phi); 
    float posz = rad*z;

    posx += offset.x;
    posy += offset.y;
    posz += offset.z;

    PVector vector_aux = new PVector(posx, posy, posz);
    // println(vector_aux);
    points[i] = (PVector)vector_aux;      
    // println(nodes.length());
    z = z - dz;
    phi = phi + dphi;
  }
  return points;
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

String removeAccents(String s) {

  for (int i = 0; i < s.length(); i++) {

    if (s.charAt(i) == 225) { // á

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "a" + end;
    } else if (s.charAt(i) == 233) { // é

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "e" + end;
    } else if (s.charAt(i) == 237) { // í

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "i" + end;
    } else if (s.charAt(i) == 243) { // ó

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "o" + end;
    } else if (s.charAt(i) == 250) { // ú

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "u" + end;
    } else if (s.charAt(i) == 193) { // Á

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "A" + end;
    } else if (s.charAt(i) == 201) { // É

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "E" + end;
    } else if (s.charAt(i) == 205) { // Í

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "I" + end;
    } else if (s.charAt(i) == 211) { // Ó

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "O" + end;
    } else if (s.charAt(i) == 218) { // Ú

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "U" + end;
    } else if (s.charAt(i) == 241) { // ñ

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "n" + end;
    } else if (s.charAt(i) == 209) { // Ñ

      String start = s.substring(0, i);
      String end = s.substring(i + 1, s.length());
      s = start + "N" + end;
    }
  }
  return s;
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

String[] createEquivalentVersions(String s) {

  String [] v = new String[0];

  String [] words = splitTokens(s, ",. ");

  for (int i = 0; i < words.length; i ++) { // i  apunta a la oracion inicial

    for (int j = 0; j < EQUIVALENTS.length; j ++ ) {  // j apunta a la cada lista de palabras

      for (int k = 0; k < EQUIVALENTS[j].length; k++) { // k a cada palabra equivalente

        if (words[i].equals(EQUIVALENTS[j][k])) {  // si hay una coincidencia

          for (int l = 0; l < EQUIVALENTS[j].length; l++) {

            String version = "";

            for (int m = 0; m < words.length; m++) {

              if (m != i)
                version += words[m] + " ";
              else
                version += EQUIVALENTS[j][l] + " ";
            }

            v = append(v, version);
          }

          break;
        }
      }
    }
  }

  return v;
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

boolean isQueryContained(String q, String[]d) {
  boolean ret = false;

  q = q.toLowerCase();
  q = removeAccents(q);



  for (int i = 0; i < d.length; i++) {

    String aux = d[i].toLowerCase();
    aux = removeAccents(aux);
    if (aux.contains(q))
      ret = true;
    else {
      String [] equivalents = createEquivalentVersions(aux);

      for (int j = 0; j < equivalents.length; j++) {
        if (equivalents[j].contains(q)) {
          ret = true;
        }
      }
    }
  }

  if (!ret) {
  }

  return ret;
}

//•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void dashedLine(float x1, float y1, float x2, float y2, float dash_length ) {
  float steps = dist(x1, y1, x2, y2) / dash_length;
  for (int i = 0; i < steps - 1; i +=2 ) {
    float xa = lerp(x1, x2, i/steps);
    float ya = lerp(y1, y2, i/steps);
    float xb = lerp(x1, x2, (i + 1)/steps);
    float yb = lerp(y1, y2, (i + 1)/steps);
    line(xa, ya, xb, yb);
  }
}

//•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void dashedLine(float x1, float y1, float z1, float x2, float y2, float z2, float dash_length ) {
  float steps = dist(x1, y1, x2, y2) / dash_length;
  for (int i = 0; i < steps - 1; i +=2 ) {
    float xa = lerp(x1, x2, i/steps);
    float ya = lerp(y1, y2, i/steps);
    float za = lerp(z1, z2, i/steps);
    float xb = lerp(x1, x2, (i + 1)/steps);
    float yb = lerp(y1, y2, (i + 1)/steps);
    float zb = lerp(z1, z2, (i + 1)/steps);
    line(xa, ya, za, xb, yb, zb);
  }
}

//•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void dashedLine(float x1, float y1, float z1, float x2, float y2, float z2, float dash_length, PGraphics g ) {
  float steps = dist(x1, y1, x2, y2) / dash_length;
  for (int i = 0; i < steps - 1; i +=2 ) {
    float xa = lerp(x1, x2, i/steps);
    float ya = lerp(y1, y2, i/steps);
    float za = lerp(z1, z2, i/steps);
    float xb = lerp(x1, x2, (i + 1)/steps);
    float yb = lerp(y1, y2, (i + 1)/steps);
    float zb = lerp(z1, z2, (i + 1)/steps);
    g.line(xa, ya, za, xb, yb, zb);
  }
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void createFields() {

  int field_w = int(width*0.8);
  int field_h = 30;

  int fields_total_height = 500;

  int y_increment = fields_total_height /  FIELD_IDS.length;

  int fields_y_start = 90;
  int fields_x = 50;

  form = new Form();

  form.confirm.setFont(slab_med_bold);
  form.cancel.setFont(slab_med_bold);

  for (int i = 0; i < FIELD_IDS.length; i++) {
    Textbox aux = new Textbox(fields_x, fields_y_start + (y_increment * i), field_w, field_h);

    aux.setId(FIELD_IDS[i]);
    aux.setIdEng(FIELD_IDS_ENG[i]);

    form.addField(aux);
  }

  form.setFonts(slab_bold, slab_med_light);
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void manageStates() {
  if (state.equals("ENCUESTA")) {
    if (form.confirm.isPressed()) {
      if (form.checkContent()) {
        state = "NOTIFICACION";
        notification.fireTimer();

        form.process();
      } 
      form.confirm.unPress();
    } else if (form.cancel.isPressed()) {
      state = "VISUALIZACION";
      network.activateCamera();
      network.resetCamera();
      network.fireActionTimer();
    } else if (help_button.pressed) {
      state = "AYUDA ENCUESTA";
      form_help.fireTimer();
      help_button.unPress();
    } else if (lang_button.pressed) {
      switchLanguage();
      lang_button.unPress();
    }
  } else if (state.equals("AYUDA ENCUESTA")) {
    if (!form_help.alive) {
      state = "ENCUESTA";
    }
  } else if (state.equals("NOTIFICACION")) {
    if (!notification.alive) {
      state = "VISUALIZACION";
      createNetwork(true);
      network.activateCamera();
      network.resetCamera();
    }
  } else if (state.equals("VISUALIZACION")) {
    if (enter_form.isPressed()) {
      state = "ENCUESTA";
      blur_rad = 0;
      createFields();
      enter_form.unPress();
      network.deActivateCamera();
      form.fireTimer();
      form.fields.get(0).focus();
    } else if (help_button.pressed) {
      state = "AYUDA VISUALIZACION";
      viz_help.fireTimer();
      help_button.unPress();
      blured.copy(network.getRender(), 0, 0, blured.width, blured.height, 0, 0, blured.width, blured.height);
    } else if (lang_button.pressed) {
      switchLanguage();
      lang_button.unPress();
    }
  } else if (state.equals("AYUDA VISUALIZACION")) {
    if (!viz_help.alive) {
      state = "VISUALIZACION";
    }
  }
  //renderState();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void renderState() {
  pushStyle();
  fill(255);
  text(state, width-200, height-50);

  text(str(network.highlight_activated), width-200, height-25);
  popStyle();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void createNetwork(boolean is_new) {
  network.erase();
  for (int i = 0; i < datamanager.entries.size(); i++) {
    network.createNode(datamanager.entries.get(i));
  }
  if (is_new)
    network.nodes.get(network.nodes.size()-1).setNewTimer();
  network.arrange();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void drawGuides() {
  pushStyle();
  stroke(#F500E5);
  line(0, TOP_MARGIN, width, TOP_MARGIN);
  line(0, height-BOTTOM_MARGIN, width, height-BOTTOM_MARGIN);
  line(LEFT_MARGIN, 0, LEFT_MARGIN, height);
  line(width-RIGHT_MARGIN, 0, width-RIGHT_MARGIN, height);
  popStyle();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void switchLanguage() {

  if (lang.equals("CASTELLANO")) {
    lang = "ENGLISH";
  } else if (lang.equals("ENGLISH")) {
    lang = "CASTELLANO";
  }

  search.checkQueryLang();

  println("switching to -> " + lang);
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void drawCursor() {
  pushStyle();
  pushMatrix();
  translate(mouseX, mouseY);
  fill(255);
  fill(50);
  stroke(150);
  //rotate(radians(-30));
  beginShape();
  vertex(0, 0);
  vertex(8, 20);
  vertex(0, 16);
  vertex(-8, 20);
  endShape(CLOSE);

  popMatrix();

  popStyle();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void renderFrame() {
  pushStyle();
  stroke(150);
  strokeWeight(2);
  noFill();
  rect(0, 0, width, height);
  popStyle();
}