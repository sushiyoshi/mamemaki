abstract class PlayerBullet extends GameObject {
  float power,min_power = 3,max_power = 10,ang,accele;
  PlayerBullet(Position position) {
    this.position = position;
    this.objType = 1;
  }
  void update() {
    position.x += cos(rad(ang)) * speed;
    position.y += sin(rad(ang)) * speed;
    speed += accele;
  }
}
class PlayerBullet0 extends PlayerBullet {
  PlayerBullet0(Position position,PImage image) {
    super(position);
    ang = -90;
    speed = 10.0;
    size = 13.0;
    collider_size = 25.0;
    this.image =image;
  }
  void run(){};
}
class PlayerBullet1 extends PlayerBullet {
  PlayerBullet1(Position position,float ang) {
    super(position);
    this.ang = ang;
    speed = 3.0;
    accele = 1.0;
    size = 30.0;
    collider_size = 50.0;
    this.image =BulletImage.get("bullet1-0");
  }
  void render() {
    imageMode(CENTER);
    tint(200,150);
    pushMatrix();
    translate(position.x,position.y);
    rotate(rad(ang+90));
    image(image,0,0,size,size);
    popMatrix();
  }
  void run() {
    if(time == 0) {
      power = min(power-1,min_power);
    }
  }
}
