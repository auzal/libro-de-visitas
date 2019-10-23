class ColorPalette {
  PImage img;
  color [] colors;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  ColorPalette(String filename) {
    img = loadImage(filename);
    createArray();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void createArray() {
    colors = new color[0];
    for (int i = 0; i < img.width; i++) {
      color aux = img.get(i, 0);
      colors = append(colors, aux);
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  color getColor(int i) {
    color aux = color(0);
    if (i < colors.length) {
      aux = colors[i];
    } else {
      println("index out of bounds! returning black instead.");
    }
    return aux;
  }
  
  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
  
  int getColorsNumber(){
    return colors.length;
  
  }
}