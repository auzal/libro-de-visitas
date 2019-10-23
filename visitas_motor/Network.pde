class Network {
  ArrayList <Node> nodes;
  PGraphics render;
  PGraphics background;

  PeasyCam cam;

  boolean auto_rotate = false;
  boolean mouse_moved = false;

  int action_timer;

  int search_results_timer = 0;

  float rotation_increment = 0;

  boolean highlight_activated = false;

  IntList connections;

  int connections_animation_timer = 0;

  PFont bold_font;


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Network(PApplet parent) {

    nodes = new ArrayList();
    createBackground();

    render = createGraphics(width, height, P3D);
    cam = new PeasyCam(parent, render, CAM_DISTANCE);
    cam.setMinimumDistance(0);
    cam.setMaximumDistance(CAM_DISTANCE*2.5);
    cam.reset();
    // cam.beginHUD();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {
    render.beginDraw();
    render.background(background);
    //render.textMode(SHAPE);
    for (Node node : nodes) {
      if (highlight_activated)
        node.renderHighlight(render);
      else
        node.render(render);
    }

    if (highlight_activated)
      renderConnections(render);
    render.endDraw();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void renderConnections(PGraphics g) {
    g.pushStyle();

    g.stroke(#F6FF03);
    g.strokeWeight(2);
    if (connections.size() > 1)
      for (int i = 1; i < connections.size(); i ++) {
        PVector start = nodes.get(connections.get(i)).getPosition();  
        PVector end = nodes.get(connections.get(i-1)).getPosition();  

        float amt = map(connections_animation_timer, CONNECTIONS_ANIMATION_TIME, 0, 0, 1);


        float x = lerp(start.x, end.x, amt);

        float y = lerp(start.y, end.y, amt);

        float z = lerp(start.z, end.z, amt);

        //g.line(start.x, start.y, start.z, end.x, end.y, end.z);

        // dashedLine(start.x, start.y, start.z, end.x, end.y, end.z, 10, g);

        dashedLine(start.x, start.y, start.z, x, y, z, 10, g);
      }

    g.popStyle();
  }




  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    if (mouseX == pmouseX && mouseY == pmouseY)
      mouse_moved = false;
    else
      mouse_moved = true;

    if (mouse_moved) {
      fireActionTimer();
    }

    if (millis() - action_timer > INACTIVE_TIMER_NETWORK) {
      auto_rotate = true;
    }


    if (millis() - search_results_timer > INACTIVE_TIMER_SEARCH_RESULTS) {
      highlight_activated = false;
    }

    if (auto_rotate) {

      if (rotation_increment < 0.3)
        rotation_increment += 0.0005;

      cam.rotateX(radians( rotation_increment));
      cam.rotateY(radians( rotation_increment));
    }

    for (Node node : nodes) {
      node.update();
    }

    if (connections_animation_timer > 0)
      connections_animation_timer -- ;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void createNode(Entry e) {
    Node aux = new Node(e);
    nodes.add(aux);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void arrange() {
    PVector [] coords = distribute(nodes.size(), NETWORK_RADIUS);
    PVector [] line_coords = distribute(nodes.size(), 75);
    for (int i = 0; i < coords.length; i ++) {

      nodes.get(i).setPosition(coords[i]);
      nodes.get(i).setLineStartPosition(line_coords[i]);
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  PGraphics getRender() {
    return render;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void createBackground() {
    background = createGraphics(width, height);
    background.beginDraw();
    color c1 = color(0);  // periferia
    color c2 = color(#462323);  // centro

    //   color c1 = color(#D1C19A);
    //   color c2 = color(#EDE3D0);
    background.noStroke();
    background.background(c1);
    for (int i = width; i > 0; i--) {
      color aux = lerpColor(c2, c1, map(i, 0, width, 0, 1));
      background.fill(aux);
      background.ellipse(width/2, height/2, i, i);
    }
    
   
    background.endDraw();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void erase() {
    nodes = new ArrayList();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void activateCamera() {
    cam.setActive(true);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void deActivateCamera() {
    cam.setActive(false);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void resetCamera() {



    if (isCamResetNecessary())
      cam.reset(2000);
    fireActionTimer();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkMouse() {
    fireActionTimer();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireActionTimer() {
    action_timer = millis();
    auto_rotate = false;
    rotation_increment = 0;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireSearchResultsTimer() {
    search_results_timer = millis();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean compare(String q) {
    boolean ret = false;

    connections = new IntList();

    for (int i = 0; i < nodes.size(); i ++) {
      if (isQueryContained(q, nodes.get(i).answers)) {
        ret = true;
        nodes.get(i).highlight = true;
        nodes.get(i).setFoundTimer();
        connections.append(i);
      } else {
        nodes.get(i).highlight = false;
        nodes.get(i).setFoundTimer();
      }
    }
    if (ret) {
      highlight_activated = true;
      fireSearchResultsTimer();
      fireAnimationTimer();
    } else {
      highlight_activated = false;
    }

    connections.shuffle();

    return ret;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireAnimationTimer() {

    connections_animation_timer = CONNECTIONS_ANIMATION_TIME;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean isCamResetNecessary() {

    boolean ret = false;

    float [] rot = cam.getRotations();

    for (int i = 0; i < rot.length; i ++) {

      if (rot[i] != 0)
        ret = true;
    }

    if (cam.getDistance() != CAM_DISTANCE)
      ret = true;

    float [] pan = cam.getLookAt();

    for (int i = 0; i < pan.length; i ++) {

      if (pan[i] != 0)
        ret = true;
    }
    return ret;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}