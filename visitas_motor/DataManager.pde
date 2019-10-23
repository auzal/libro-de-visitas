class DataManager {

  ArrayList <Entry> entries;

  int index = 0;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  DataManager() {
    entries = new ArrayList();
    loadIndex();
    loadData();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void addEntry(String [] aux_data, String [] aux_keys) {
    updateIndex();
    Entry aux = new Entry();
    aux.setData(aux_data);
    aux.setKeys(aux_keys);
    aux.printData();
    aux.saveData(index);
    entries.add(aux);
    createTable();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void updateIndex() {
    index++;
    String[] output = new String[0];
    String row = "<xml>";
    output = append(output, row);
    row = "<index>" + index + "</index>";
    output = append(output, row);
    row = "</xml>";
    output = append(output, row);
    saveStrings("data/Repo/index.xml", output);
  }


  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void loadIndex() {
    XML xml;
    try {
      xml = loadXML("data/Repo/index.xml");
    }
    catch(Exception e) {

      xml = null;
    }
    if (xml != null) {
      XML firstChild = xml.getChild("index");
      index = firstChild.getIntContent();
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void loadData() {
    for (int i = 0; i < index; i++) {

      XML xml;
      try {
        xml = loadXML("data/Repo/entrada_"+ (i+1) +".xml");
      }
      catch(Exception e) {

        xml = null;
      }

      if (xml != null) {


        Entry aux_entry = new Entry();

        String [] data_aux = new String[0];
        String [] keys_aux = new String[0];

        XML[] children = xml.getChildren("field");
        for (int j = 0; j < children.length; j++) {
          String id = children[j].getString("id");
          String data = children[j].getContent();
          data_aux = append(data_aux, data);
          keys_aux = append(keys_aux, id);
        }

        XML time = xml.getChild("timestamp");
        String ts = time.getContent();
        aux_entry.setData(data_aux);
        aux_entry.setKeys(keys_aux);
        aux_entry.setTimeStamp(ts);
        aux_entry.printData();

        entries.add(aux_entry);
      }
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void createTable() {

    Table table = new Table();

    table.addColumn("id");

    for (int i = 0; i <  FIELD_IDS.length; i ++) {
      table.addColumn(FIELD_IDS[i]);
    }

    table.addColumn("Fecha y hora");

    for (int i = 0; i < entries.size(); i++) {
      Entry e = entries.get(i);
      TableRow newRow = table.addRow();
      newRow.setInt(0, i);
      for (int j = 0; j < e.data.length; j++) {

        newRow.setString(j+1, e.data[j]);
      }
      newRow.setString("Fecha y hora", e.timestamp);
    }
    saveTable(table, "data/Repo/Entradas.csv");
  }
}