class Form {

  ArrayList <Textbox> fields;

  Button confirm;

  Button cancel;

  int action_timer;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Form() {

    fields = new ArrayList();

    confirm = new Button( width/2 + 70, height - 100, "Confirmar");
    confirm.setIdEng("Confirm");
    
    cancel = new Button( width/2  - 70, height - 100, "Cancelar");
    cancel.setIdEng("Cancel");
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    confirm.update();
    cancel.update();

    if (millis() - action_timer  > INACTIVE_TIMER_FORM) {
      cancel.press();
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void render() {

    for (Textbox box : fields) {
      box.render();
    }

    confirm.render();
    cancel.render();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkMouse() {
    fireTimer();
    for (Textbox box : fields) {
      box.checkMouse();
    }

    confirm.checkMouse();
    cancel.checkMouse();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void checkKeys() {
    fireTimer();
    for (Textbox box : fields) {
      box.checkKeys();
    }
    if (key == TAB) {
      for (int i = 0; i < fields.size(); i ++) {
        if (fields.get(i).is_focused) {
          fields.get(i).unFocus();
          fields.get((i+1)%(fields.size())).focus();
          break;
        }
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void addField(Textbox b) {
    fields.add(b);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void process() {
    String [] aux_data = new String[fields.size()];
    for (int i = 0; i < fields.size(); i ++) {  
      aux_data[i] = fields.get(i).getText();
    }

    String [] aux_keys = new String[fields.size()];
    for (int i = 0; i < fields.size(); i ++) {
      aux_keys[i] = fields.get(i).getId();
    }

    datamanager.addEntry(aux_data, aux_keys);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fireTimer() {
    action_timer = millis();
  }
  
  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
  
  void setFonts(PFont f, PFont id_f){
  
    for(int i = 0 ; i < fields.size() ; i++){
      
      fields.get(i).setFont(f);
       fields.get(i).setFontId(id_f);
    
    }
  
  }
  
  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
  
  boolean checkContent(){
    boolean ret = false;
    
    for(int i = 0 ; i < fields.size() ; i++){
      
      if(fields.get(i).text.length() > 2)  // wot
        ret = true;
    
    }
    
    
    return ret;
  
  
  }
}