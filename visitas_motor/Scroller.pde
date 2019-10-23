class Scroller {

  float acc = 2;
  float damp = .9;

  float h_vector = 0;
  float v_vector = 0;
  float z_vector = 0;
  float d_vector = 0;

  float rh_vector = 0;
  float rv_vector = 0;

  float z = 0;
  float x = 0;
  float y = 0;
  
  float d = 200;

  float rx = 0;
  float ry = 0;

  Scroller() {

    mouseX = width/2;
    mouseY = height/2;

  }

  Scroller(float acc, float damp) {

    this.acc = acc;
    this.damp = damp;

    mouseX = width/2;
    mouseY = height/2;

  }

  Scroller(float x, float y, float z, float depth) {

    this.x = x;
    this.y = y;
    this.z = z;
    
    this.d = depth;

    mouseX = width/2;
    mouseY = height/2;

  }

  Scroller(float x, float y, float z, float acc, float damp) {

    this.acc = acc;
    this.damp = damp;

    this.x = x;
    this.y = y;
    this.z = z;

    mouseX = width/2;
    mouseY = height/2;

  }


  void update() { 

    if(mousePressed) {

      rh_vector += -(mouseY - pmouseY)/1000.0;
      rv_vector += (mouseX - pmouseX)/1000.0;

    } 
    //else {

      rh_vector *= damp;
      rv_vector *= damp;

    //}

    //map(mouseX, 0, width, -PI/2, PI/2)

    if(keyPressed) {
      if (key == CODED) {
        if (keyCode == UP) {
          v_vector += acc;
        } 
        if (keyCode == DOWN) {
          v_vector -= acc;
        }
        if (keyCode == LEFT) {
          h_vector += acc;
        } 
        if (keyCode == RIGHT) {
          h_vector -= acc;
        } 
      }
      if(key == ',' || key == '<') {
        d_vector -= acc;
      } 
      else if(key == '.' || key == '>') {
        d_vector += acc;
      }

      if(key == '-' || key == '_') {
        d_vector -= acc;
      } 
      else if(key == '=' || key == '+') {
        d_vector += acc;
      }

    } 
    else {
      h_vector *= damp;
      v_vector *= damp;
      z_vector *= damp;
      d_vector *= damp;
    }

    x += h_vector;
    y += v_vector;
    z += z_vector;
    d += d_vector;

    rx += rh_vector;
    ry += rv_vector;

  }



}