class Node {
  float x;
  float y;
  float z;
  Entry entry;
  PFont font = null;
  boolean render_sub = true;

  int sub_nodes =int( random(2, 10));
  int sub_rad = 50;

  PVector[] sub;

  boolean highlight = false;
  int new_timer = 0;

  PVector line_start = new PVector(0, 0, 0);

  color line_color = color(#FFCA67);


  String [] answers;
  int [] palette_indexes;

  int found_timer = 0;


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Node(Entry e) {

    entry = e;
    x = random(50, width-50);
    y = random(50, height-50);
    z = random(50, height-50);

    processAnswers();

    sub_nodes = answers.length;

    sub = distribute(sub_nodes, sub_rad, new PVector(x, y, z));
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void renderHighlight(PGraphics g) {
    g.pushStyle();
    g.rectMode(CENTER);
    g.pushMatrix();
    if (highlight) {
      g.textFont(slab_bold);
      float weight = map(found_timer, FOUND_ANIMATION_TIME, 0, 1, 2);
      g.strokeWeight(weight);
      g.stroke(line_color, 150);
    } else {
      g.strokeWeight(1);
      color to = color(line_color, 40);
      color from = color(line_color, 90);
      float amt = map(found_timer, FOUND_ANIMATION_TIME, 0, 0, 1);
      color co = lerpColor(from, to, amt);
      g.stroke(co);
      g.textFont(slab_light);
    }
    g.line(x, y, z, line_start.x, line_start.y, line_start.z );


    g.translate(x, y, z);
    g.textAlign(CENTER, CENTER);

    //String render_text = "";
    //for (int i = 0; i <  answers.length; i++) {
    //  render_text += answers[i] + "\n" ;
    //}
    //g.text(render_text, 0, 0);
    g.noFill();
    g.ellipse(0, 0, 5, 5);

    g.popMatrix();


    if (render_sub) {
      for (int i = 0; i < sub.length; i++) {
        g.pushMatrix();
        g.translate(sub[i].x, sub[i].y, sub[i].z);
        if (highlight) {



          if (found_timer == 0)
            g.fill(255);
          else {
            color to = color(255);
            color from = color(answers_palette.getColor(palette_indexes[i]));
            float amt = map(found_timer, FOUND_ANIMATION_TIME, 0, 0, 1);
            color co = lerpColor(from, to, amt);
            g.fill(co);
          }
        } else {
          color from = color(answers_palette.getColor(palette_indexes[i]));
          color to = color(answers_palette.getColor(palette_indexes[i]), 30);
          float amt = map(found_timer, FOUND_ANIMATION_TIME, 0, 0, 1);
          color co = lerpColor(from, to, amt);
          g.fill(co);
        }

        PVector rtVc = new PVector(x, y, z).copy().sub(new PVector(0, 0, 0)).setMag(1.0);//unit vector

        float rotx = -atan2(rtVc.y, rtVc.z);
        float roty = atan2(rtVc.x, sqrt(rtVc.y*rtVc.y + rtVc.z*rtVc.z));

        g.rotateX(rotx);
        g.rotateY(roty);


        String aux = textAsRows(answers[i]);

        if (highlight && i==0) {

          g.pushStyle();
          g.stroke(255,40);

          g.noFill();

          g.ellipse(0, 0, 300, 300);
          g.popStyle();
        }

        g.text(aux, 0, 0);
        //g.text(answers[i], 0, 0);
        //g.rect(0, 0, 10, 10);

        g.noFill();



        g.popMatrix();
        g.line(x, y, z, sub[i].x, sub[i].y, sub[i].z);
      }
    }

    g.popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render(PGraphics g) {
    g.pushStyle();
    g.rectMode(CENTER);
    g.pushMatrix();
    g.textFont(slab_light);

    g.stroke(line_color, 90);

    g.line(x, y, z, line_start.x, line_start.y, line_start.z );

    g.translate(x, y, z);

    //g.noStroke();
    g.noFill();
    g.ellipse(0, 0, 5, 5);

    g.textAlign(CENTER, CENTER);

    // String render_text = "";
    // for (int i = 0; i <  answers.length; i++) {
    //   render_text += answers[i] + "\n" ;
    // }
    //  g.text(render_text, 0, 0);
    g.popMatrix();
    g.noFill();

    if (render_sub) {
      for (int i = 0; i < sub.length; i++) {
        g.stroke(line_color, 90);
        g.pushMatrix();
        g.translate(sub[i].x, sub[i].y, sub[i].z);

        if (new_timer == 0)
          g.fill(answers_palette.getColor(palette_indexes[i]));
        else {
          color from = color(255);
          color to = color(answers_palette.getColor(palette_indexes[i]));
          float amt = map(new_timer, NEW_HIGHLIGHT_TIME, 0, 0, 1);
          color co = lerpColor(from, to, amt);
          g.fill(co);
        }

        // PVector rtVc = sub[i].copy().sub(new PVector(0, 0, 0)).setMag(1.0);//unit vector
        PVector rtVc = new PVector(x, y, z).copy().sub(new PVector(0, 0, 0)).setMag(1.0);//unit vector

        float rotx = -atan2(rtVc.y, rtVc.z);
        float roty = atan2(rtVc.x, sqrt(rtVc.y*rtVc.y + rtVc.z*rtVc.z));

        g.rotateX(rotx);
        g.rotateY(roty);


        //g.fill(answers_palette.getColor(palette_indexes[i]));


        String aux = textAsRows(answers[i]);


        g.text(aux, 0, 0);



        //   g.rect(0, 0, 10, 10);
        g.popMatrix();

        g.strokeWeight(2);
        g.line(x, y, z, sub[i].x, sub[i].y, sub[i].z);
        g.strokeWeight(1);
      }
    }

    g.popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  String textAsRows(String t) {

    int max_chars = 30;

    int count = 0;

    String aux = t;

    for (int i = 0; i < aux.length(); i ++) {
      count ++;

      if (count >= max_chars) {
        int index = i;
        for (int j = index; j >= 0; j-- ) {
          index = j;
          if (aux.charAt(index) == ' ') {
            index = j;
            // i = index;
            break;
          }
        }
        aux = aux.substring(0, index) + "\n" + aux.substring(index, aux.length());
        count = 0;
      }
    }

    return aux;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    if (new_timer>0)
      new_timer --;
    if (found_timer>0)
      found_timer --;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFont(PFont f) {
    font = f;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setPosition(PVector pos) {
    x = pos.x;
    y = pos.y;
    z = pos.z;
    sub = distribute(sub_nodes, sub_rad, new PVector(x, y, z));
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setLineStartPosition(PVector pos) {
    line_start = pos;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  PVector getPosition() {

    PVector pos = new PVector(x, y, z);

    return pos;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setNewTimer() {

    new_timer = NEW_HIGHLIGHT_TIME;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setFoundTimer() {

    found_timer = FOUND_ANIMATION_TIME;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void processAnswers() {

    answers = new String[0];
    palette_indexes = new int[0];
    for (int i = 0; i < entry.data.length; i ++ ) {
      if (i > 4)  // excepcion para ultima pregunta
        break;
      else {
        if ( entry.data[i].equals("") ||   entry.data[i].toLowerCase().equals("no")) {
          //lo dejo pasar de largo
        } else {
          answers = append(answers, entry.data[i]);
          palette_indexes = append(palette_indexes, i);
        }
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}