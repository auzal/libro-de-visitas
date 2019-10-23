

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••//
//••••••••••••••••••••••••••• LIBRO DE VISITAS •••••••••••••••••••••••••••••••••//
//•••••••••••••••••••••• MUSEO DE LA PATAGONIA, 2017 •••••••••••••••••••••••••••//
//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••//
//•••••••••••••••••••••• Desarrollado por ARIEL UZAL •••••••••••••••••••••••••••//
//••••••••••••••••••• http://cargocollective.com/auzal••••••••••••••••••••••••••//
//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••//


import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import java.awt.Robot;
import java.awt.MouseInfo;
import java.awt.Point;

Robot rbt;

String state = "VISUALIZACION";

String lang = "CASTELLANO";

Form form;

DataManager datamanager;

Network network;

Scroller ease;

Notification notification;

Notification viz_help;
Notification form_help;

PFont politica;
PFont assistant;
PFont slab_bold;
PFont slab_light;
PFont slab_small_bold;
PFont slab_small_light;
PFont slab_med_light;
PFont slab_med_bold;
PFont slab_large_bold;

boolean blur = false;

PImage blured ;

PImage grain;

Button enter_form;

Button help_button;

Button lang_button;

Search search;

int blur_rad = 0;

ColorPalette answers_palette;

PImage cursor;

void setup() {

  fullScreen(P2D);

 // size(1280, 800, P2D);
 
 pixelDensity(2);

  network = new Network(this);

  ease = new Scroller(0, 0, 0, 0);

  politica = loadFont("Politica-24.vlw");

  assistant = loadFont("Assistant-Light-20.vlw");

  //slab_bold = createFont("RobotoSlab-Bold.ttf", 20);

  //slab_light = createFont("RobotoSlab-Light.ttf", 20);

  //slab_large_bold = createFont("RobotoSlab-Bold.ttf", 30);

  //slab_small_bold = createFont("RobotoSlab-Bold.ttf", 15);

  //slab_small_light = createFont("RobotoSlab-Light.ttf", 12);

  //slab_med_light  = createFont("RobotoSlab-Light.ttf", 18);

  //slab_med_bold = createFont("RobotoSlab-Bold.ttf", 18);
  
   slab_bold = createFont("DIN Bold.ttf", 20);

  slab_light = createFont("DIN Light.ttf", 20);

  slab_large_bold = createFont("DIN Bold.ttf", 30);

  slab_small_bold = createFont("DIN Bold.ttf", 15);

  slab_small_light = createFont("DIN Light.ttf", 12);

  slab_med_light  = createFont("DIN Light.ttf", 18);

  slab_med_bold = createFont("DIN Bold.ttf", 18);

  cursor = loadImage("cursor-01.png");
  
  grain = loadImage("grain.png");

  datamanager = new DataManager();

  createFields();

  createNetwork(false);

  blured = createImage(network.getRender().width, network.getRender().height, RGB );

  enter_form = new Button(width-60, 25, "Participar");
  enter_form.setFont(slab_med_light);
  enter_form.setIdEng("Take part");

  help_button = new Button(40, height - 25, "Ayuda");
  help_button.setFont(slab_med_light);
  help_button.setIdEng("Help");

  lang_button = new Button(width-90, height - 25, "English/Castellano");
  lang_button.setFont(slab_med_light);
  lang_button.setIdEng("Castellano/English");

  search = new Search();
  search.setPosition(LEFT_MARGIN, TOP_MARGIN);
  search.setFonts(slab_med_light, slab_small_light);

  notification = new Notification();
  notification.setFont(slab_large_bold);
  notification.setText(FORM_END_TEXT);
  notification.setTextEng(FORM_END_TEXT_ENG);

  form_help = new Notification();
  form_help.setFont(slab_med_bold);
  form_help.setText(FORM_HELP_TEXT);
  form_help.setTextEng(FORM_HELP_TEXT_ENG);

  viz_help = new Notification();
  viz_help.setFont(slab_bold);
  viz_help.setText(VIZ_HELP_TEXT);
  viz_help.setTextEng(VIZ_HELP_TEXT_ENG);

  answers_palette = new ColorPalette("answers_palette9.png");

  cursor(cursor, 1, 0);

  try {
    rbt = new Robot();
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


void draw() {


  Point mouse;
  mouse = MouseInfo.getPointerInfo().getLocation();
  // println( "X=" + mouse.x + " Y=" + mouse.y );
  int x = mouse.x;
  int y = mouse.y;
  int limit = 740;
  // println(x);
  // println(y);
 // if (y > limit)
  //  rbt.mouseMove(x, limit);


  surface.setTitle(str(frameRate));
  ease.update(); // updates the ease' point coordinates with user input
  network.cam.pan(ease.h_vector, ease.v_vector);

  enter_form.setPosition(width - RIGHT_MARGIN - enter_form.w/2, TOP_MARGIN + enter_form.h/2);
  help_button.setPosition(LEFT_MARGIN +  help_button.w/2, height - BOTTOM_MARGIN - help_button.h/2);
  lang_button.setPosition(width - RIGHT_MARGIN - lang_button.w/2, height - BOTTOM_MARGIN - lang_button.h/2);

  if (state.equals("ENCUESTA")) {
    if (blur_rad < 9) {
       blured.copy(network.getRender(), 0, 0, blured.width, blured.height, 0, 0, blured.width, blured.height);
      if (frameCount % 2 == 0) {
        blur_rad ++;
      }
    }
   

    network.render();
    
    

    image(network.getRender(), 0, 0);
    
     fastblur(blured, blur_rad);
    image(blured, 0, 0);
    pushStyle();
    int op = 150;
    fill(0, op);
    noStroke();
    rect(0, 0, width, height);
    popStyle();
    form.render();
    form.update();
    help_button.render();
    help_button.update();
    lang_button.render();
    lang_button.update();
  } else if (state.equals("VISUALIZACION")) {
    network.update();
    network.render();

    image(network.getRender(), 0, 0);
    enter_form.render();
    enter_form.update();

    help_button.render();
    help_button.update();
    lang_button.render();
    lang_button.update();
   search.render();
    search.update();
  } else if (state.equals("NOTIFICACION")) {
    fastblur(blured, blur_rad);
    image(blured, 0, 0);
    pushStyle();
    int op = 30;
    fill(0, op);
    noStroke();
    rect(0, 0, width, height);
    popStyle();
    notification.render();
    notification.update();
  } else if (state.equals("AYUDA ENCUESTA")) {
    fastblur(blured, blur_rad);
    image(blured, 0, 0);
    pushStyle();
    int op = 30;
    fill(0, op);
    noStroke();
    rect(0, 0, width, height);
    popStyle();
    form_help.render();
    form_help.update();
  } else if (state.equals("AYUDA VISUALIZACION")) {
    fastblur(blured, 9);
    image(blured, 0, 0);
    pushStyle();
    int op = 30;
    fill(0, op);
    noStroke();
    rect(0, 0, width, height);
    popStyle();
    viz_help.render();
    viz_help.update();
  }




  manageStates();

 //renderFrame();

  //  drawCursor();
  // drawGuides()  ;

}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void mousePressed() {

  if (state.equals("ENCUESTA")) {

    form.checkMouse();
    help_button.checkMouse();
    lang_button.checkMouse();
  }
  if (state.equals("VISUALIZACION")) {

    network.checkMouse();
    enter_form.checkMouse();
    help_button.checkMouse();
    lang_button.checkMouse();
    search.checkMouse();
  }
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void keyPressed() {

  if (key == ESC) { 
  //  key = 0;
  }

  if (state.equals("ENCUESTA")) {

    form.checkKeys();
  } else  if (state.equals("VISUALIZACION")) {
    if (!search.keys()) {
      // if (key == ' ')
      //   network.cam.setActive(!network.cam.isActive());
      if (key == 'r' || key == 'R') {
        network.resetCamera();
      } else if (key == 'b' || key == 'B')
        blur = !blur;
    }
  }

  if (key == 's' || key == 'S') {
    println("s");
    String f = "capture/capture_" + frameCount + ".tiff";
    saveFrame(f);
  }
}