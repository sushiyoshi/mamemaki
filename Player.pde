//Input
int bit;
int shift = 0;
boolean shot = false;
abstract class Player extends GameObject{
  int hp=2,bomb=3,score=0;
  boolean deadFlag = false;
  boolean controlFlag = true;
  Player (Position position,float size,float speed) {
    this.position = position;
    this.size = size;
    this.speed = speed;
    this.objType = 0;
    this.collider_size = size/3;
    collider.cliner.regist(this);
  }
  //座標の更新　及び表示
  void update() {
      if(!deadFlag) {
        if(collision)  {
          hp--;
          collision = false;
          deadFlag = true;
          controlFlag = false;
          time = 0;
          position = new Position(WIDTH/2,HEIGHT);
        }
      } else {
        deadProcessing();
      }
      if(controlFlag) {
        float sp = speed / (shift + 1);
        if ((bit&(1<<0))>0) position.x+=sp;
        if ((bit&(1<<1))>0) position.x-=sp;
        if ((bit&(1<<2))>0) position.y-=sp;
        if ((bit&(1<<3))>0) position.y+=sp;
      }
      position.x=max(position.x,0);
      position.x=min(position.x,WIDTH);
      position.y=max(position.y,0);
      position.y=min(position.y,HEIGHT);
  }
  void render() {
    /*
    if(deadFlag) stroke(200,10,70);
    else stroke(2,200,45);
    */
    if(deadFlag) tint(200,150);
    else noTint();
    //float alpha = deadFlag ? 40 : 0;
    imageMode(CENTER);
    image(oni,position.x,position.y,size,size);
  }
  void deadProcessing() {
    if(time < 60) {
      position.y-=1.5;
    } else if(time == 150) {
      deadFlag = false;
    } else {
      controlFlag = true;
    }
    collision = false;
  }
}

class Player0 extends Player {
  GameObject target = null;
  Player0(Position position,float size,float speed) {
    super(position,size,speed);
    //this.image = oni;
  }
  void run(){
    
    if(time % 4 == 0) {
      int i,len = objData.size();
      target = null;
      if(len != 0) {
        boolean flag = false;
        for(i = 0; i < len; i++) {
          if(objData.get(i).objType == 3) {
            flag = true;
            break;
          }
        }
        
        if(flag) target = objData.get(i);
      }
    }
      
    if(time % 4 == 0 && shot && !deadFlag) {
      Position pos;
      pos = new Position(position.x + 10,position.y-10);
      addData.add(new PlayerBullet0(pos,BulletImage.get("bullet2-12")));
      pos = new Position(position.x - 10,position.y-10);
      addData.add(new PlayerBullet0(pos,BulletImage.get("bullet2-12")));
      pos = new Position(position.x + 15,position.y);
      addData.add(new PlayerBullet0(pos,BulletImage.get("bullet2-13")));
      pos = new Position(position.x - 15,position.y);
      addData.add(new PlayerBullet0(pos,BulletImage.get("bullet2-13")));
      if(time % 8 == 0) {
        float ang;
        if(target != null) {
          ang = aim(position,target.position);
        } else {
          ang = -90;
        }
        //ang = -90;
        pos = new Position(position.x + 20,position.y);
        addData.add(new PlayerBullet1(pos,ang));
        pos = new Position(position.x - 20,position.y);
        addData.add(new PlayerBullet1(pos,ang));
      }
    }
  }
  float aim(Position a,Position b) {
    return atan2(b.y-a.y,b.x-a.x) * 180 / PI;
  }
}
void keyPressed() {
    if (keyCode == RIGHT) bit |= (1<<0); //00000001
    if (keyCode == LEFT)  bit |= (1<<1); //00000010
    if (keyCode == UP)    bit |= (1<<2); //00000100
    if (keyCode == DOWN)  bit |= (1<<3); //00001000
    if (keyCode == SHIFT) shift = 1;
    if (keyCode == 'Z') shot = true;
  }
void keyReleased() {
    if (keyCode == RIGHT) bit &= ~(1<<0);
    if (keyCode == LEFT)  bit &= ~(1<<1);
    if (keyCode == UP)    bit &= ~(1<<2);
    if (keyCode == DOWN)  bit &= ~(1<<3);
    if (keyCode == SHIFT) shift = 0;
    if (keyCode == 'Z') shot = false;
}
