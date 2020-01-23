class Frame {
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
    image(logo,310,150,360,480);
    image(score_text,340,20,164,121);
    image(player_text,340,70,160,120);
    image(bomb_text,340,120,160,120);
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
    //image(window,15,320,340,150);
    score();
    life();
    bomb();
  }
}
