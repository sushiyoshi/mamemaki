class BackGround {
  int i = 0;
  void run() {
    background(0);
    imageMode(CORNER);
    noTint();
    image(background,0,-480 + (i % 960),480,480);
    image(background,0,-480 + ((i + 480) % 960),480,480);
    i++;
    
    if(i % 100 == 0) {
      int i = int(random(0,10));
      int id  = int(random(0,5));
      float size = random(100,200);
      float speed = random(0.5,2);
      objData.add(new Kusa(i>5,id,size,speed));
    }
  }
  
  class Kusa extends GameObject{
    float ang;
    Kusa(boolean boolea,int id,float size,float speed) {
      this.size = size;
      float x = boolea ? -10: 410;
      float ang = boolea ? 0 : 180;
      this.position = new Position(x,-50);
      this.image = KusaImage[id];
      this.ang =ang;
      this.speed = speed;
    }
    void update() {
      position.y += speed;
    }
    boolean isDestroy() {
      if(position.y > (HEIGHT+MARGIN)) return true;
      return false;
    }
    void render() {
      imageMode(CORNER);
      tint(255,120-size/5);
      //noTint();
      pushMatrix();
      translate(position.x,position.y);
      rotate(rad(ang));
      image(image,0,0,size,size);
      popMatrix();
    }
  }
}
