class Frame {
  float ang = 40,alpha = 0,frame = 40;
  void frame() {
    /*
    noStroke();
    rectMode(CORNER);
    fill(60);
    rect(0,0,335,20);
    rect(335,0,305,480);
    rect(0,0,20,480);
    rect(0,460,335,20);
    */
    image(frame_image,0,0,640,480);
    image(score_text,340,20,164,121);
    image(player_text,340,70,160,120);
    image(bomb_text,340,120,160,120);
  }
  
  void logo() {
    ang += (0-ang)/frame;
    alpha += (255-alpha)/frame;
    tint(255,alpha);
    
    pushMatrix();
    translate(350,250);
    rotate(rad(ang));
    imageMode(CORNER);
    image(logo,0,0,300,200);
    popMatrix();
  }
  void score() {
    textFont(stateFont);
    textAlign(CORNER);
    String score_text = Integer.toString(pl.score);
    int len = score_text.length();
    for(int i = 12; i > len && i > 0; i--) {
      score_text = '0' + score_text;
    }
    drawOutlineText(score_text,465,63,23,255,0);
  }
  void life() {
    int hp = pl.hp;
    for(int i = 0; i < hp; i++) {
      image(life,470 + i * 25,120,28,21);
    }
  }
  void bomb() {
    int bomb = pl.bomb;
    for(int i = 0; i < bomb; i++) {
      image(hoshi,470 + i * 25,170,28,21);
    }
  }
  void run() {
    imageMode(CORNER);
    noTint();
    frame();
    logo();
    //image(window,15,320,340,150);
    score();
    life();
    bomb();
  }
}
