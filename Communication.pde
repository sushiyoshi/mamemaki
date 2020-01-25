class Communication {  
  Picture[] StandingPicture;
  Serif[] serifList;
  int serifLength;
  String text;
  String sp_text;
  int num = 0;
  PImage image;
  float y = 360;
  Communication(Serif[] serifList,Picture[] StandingPicture) {
    this.serifList = serifList;
    this.StandingPicture = StandingPicture;
    serifLength = serifList.length;
    kaiwa = true;
  }
  void run() {
    if(num >= serifLength)  {
      kaiwa = false;
    } else {
      Serif speaking = serifList[num];
      sp_text = speaking.speaker_text;
      int len = StandingPicture.length;
      for(int i = 0; i<len; i++) {
        StandingPicture[i].run(sp_text);
      }
      
      rectMode(CORNER);
      noStroke();
      fill(20,150);
      rect(30,y,310,65);
      
      textFont(serifFont);
      textAlign(CORNER);
      noTint();
      textSize(17);
      fill(255,255);
      text(speaking.text, 40, y+10,280,50);
      
      if(control) num++;
    }
  }
}
class Serif {
  String text;
  String speaker_text;
  Serif(String text,String speaker_text) {
    this.text = text;
    this.speaker_text = speaker_text;
  }
}
class Picture {
  PImage image;
  String name;
  float speaker_y = 330;
  float notSpeaker_y = 340;
  Position position = new Position(0,notSpeaker_y-30);
  float targetY = notSpeaker_y;
  float frame = 5;
  Picture(String name) {
    this.name = name;
    position.x  = 40;
  }
  Picture(PImage image,String name,boolean pos) {
    this.image = image;
    this.name = name;
    position.x  = pos ? 90 : 290;
  }
  void update() {
    position.y += (targetY-position.y) /frame;
  }
  void run(String str) {
    boolean bool = name == str;
    targetY = bool ? speaker_y : notSpeaker_y;
    imageMode(CENTER);
    if(bool) {
      noTint();
    } else {
      tint(100,150);
    }
    update();
    float size = bool ? 1.2:1.0;
    image(image,position.x,position.y,240*size,320*size);
  }
}
