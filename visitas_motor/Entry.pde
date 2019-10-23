class Entry {

  String[] data = new String[0];

  String[] field_keys = new String[0];

  String timestamp = "";

  Entry() {
    timestamp = day() + "/" + month() + "/" + year() + " - " + hour() + ":" + minute() + ":" + second();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setData(String [] d) {
    data = d;
    
    for(int i = 0 ; i < data.length ; i ++){
    
      data[i] = data[i].toLowerCase();
    }
    
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setKeys(String [] k) {
    field_keys = k;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void printData() {
    println("printing data");
    print(data);
    println("");
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void saveData(int index) {
    String[] output = new String[0];
    String row = "<xml>";
    output = append(output, row);
    for (int i = 0; i < data.length; i ++) { //<>//
      row = "<field id=\"" + field_keys[i] +  "\">" + data[i] + "</field>";
      output = append(output, row);
    }
    row = "<timestamp>" + timestamp + "</timestamp>";
    output = append(output, row);
    row = "</xml>";
    output = append(output, row);
    saveStrings("data/Repo/entrada_"+ index +".xml", output);
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setTimeStamp(String ts) {

    timestamp = ts;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}