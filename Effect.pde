abstract class Effect extends GameObject {
  float targetSize = 10,max,frame,sizeFrame = 1,ang=90;
  Position target = new Position(0,0);
  String moveType = "DEFAULT";
  void update() {
    switch(moveType) {
      case "TARGET":
      targetMove();
      break;
      default:
      defaultMove();
      break;
    }
  }
  void defaultMove() {
    position.x += cos(rad(ang)) * speed;
    position.y += sin(rad(ang)) * speed;
  }
  void targetMove() {
    float targetSpeed,defaultSpeed,speed;
    targetSpeed = (target.x-position.x) / frame;
    defaultSpeed = cos(rad(aim(position,target))) * max;
    speed =  abs(targetSpeed) < abs(defaultSpeed) ? targetSpeed : defaultSpeed;
    position.x += speed;
    targetSpeed = (target.y-position.y) / frame;
    defaultSpeed = sin(rad(aim(position,target))) * max;
    speed =  abs(targetSpeed) < abs(defaultSpeed) ? targetSpeed : defaultSpeed;
    position.y += speed;
  }
  void myResize() {
    size += (targetSize-size) / sizeFrame;
  }
  float aim(Position a,Position b) {
    return atan2(b.y-a.y,b.x-a.x) * 180 / PI;
  }
}

class Explosion extends Effect {
  float destroyTime = 20;
  float alpha = 255;
  Explosion(Position position,float size,float frame,PImage image) {
    this.position = position;
    this.targetSize = size;
    this.sizeFrame = frame;
    this.image = image;
  }
  void run() {
    myResize();
    alpha += alpha*-1 /sizeFrame;
    tint(255,alpha);
    time++;
  }
  boolean isDestroy() {
      if(time > sizeFrame) return true;
      return false;
    }
  void render() {
    imageMode(CENTER);
    if(image != null)image(image,position.x,position.y,size,size);
    //rect(position.x,position.y,size,size);
    
  }
}
