abstract class EnemyObject extends GameObject{
  float accele = 0,ang=90,frame,max;
  EnemyObject() {
    speed = 1;
    size =15;
  }
  Position target = new Position(-1,-1);
  String moveType = "DEFAULT"; 
  boolean moveFlag = false;
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
    speed += accele;
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
  void createObject(EnemyObject obj) {
    addData.add(obj);
  }
  float aim(Position a,Position b) {
    return atan2(b.y-a.y,b.x-a.x) * 180 / PI;
  }
  /*
  void move(Position target,float speed) {
    ang = aim(position,target);
    this.speed = speed;
    float dis = distance(position,target);
    accele = sq(speed)/(2*dis) * -1.0; 
  }*/
  void targetMode(Position target,float frame,float max) {
    moveType = "TARGET";
    this.target = target;
    this.frame = frame;
    this.max = max;
  }
}
abstract class Stage extends EnemyObject {
  void render(){}
  Stage() {
    this.objType = 2;
    collider_size = 0;
    speed =0;
  }
  abstract class Enemy extends EnemyObject{
    int hp;
    float defeatScore = 1000;
    float shotScore = 100;
    Enemy(Position position,int hp) {
      collider.cliner.regist(this);
      collider_size = size/2;
      this.objType = 3;
      this.collider_size = size/3;
      this.position = position;
      this.hp = hp;
    }
    boolean isDestroy() {
      if(collision) {
        hp--;
        pl.score += shotScore;
        collision = false;
      }
      if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
        return true;
      }
      if(hp < 0) {
        pl.score += defeatScore;
        addData.add(new Explosion(position.getPosition(),100.0,10.0,image));
        return true;
      }
      return false;
    }
    abstract class EnemyBullet extends EnemyObject{
      EnemyBullet() {      
        this.objType = 4;
        this.collider_size = size/3;
        collider.cliner.regist(this);
        collider_size = size/2;
        position.x = Enemy.this.position.x;
        position.y = Enemy.this.position.y;
      }
    }
  }
}
