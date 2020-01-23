class Stage0 extends Stage {
  Position[] Enemy0Pattern = {
    new Position(200,50),
    new Position(100,50),
    new Position(300,50),
    new Position(150,50),
    new Position(250,50)
  };
  void run() {
    if(time == 0) {
        speed = 0;
    }
    for(int i = 0; i < 5; i++) {
      if(time == (i+1)*40) {
        Enemy0 en = new Enemy0(Enemy0Pattern[i],15);
        createObject(en);
      }
    }
    if(time == 400) {
      Boss en = new Boss(new Position(100,20),300);
      createObject(en);
    }
  }
  class Enemy0 extends Enemy {
    Enemy0(Position position,int hp) {
      super(position,hp);
      speed = 2.0;                                                                                                                                                                                                   
    }
    void run() {  
      if(time % 100 == 0 && (time / 100) <= 3) {
        for(int i = 0; i<18; i++) {
          EnemyBullet0 bl = new EnemyBullet0(i*20);
          createObject(bl);
        }
      }
    }
    class EnemyBullet0 extends EnemyBullet {
      float accele;
      EnemyBullet0(float ang) {
        this.ang = ang;
      }
      void run() {
        if(time == 0) {
          speed = 1.0;
          accele = -1.0;
        }
        if(time == 20) {
          speed = 0.0;
          accele = 0.0;
        }
        if(time ==  40) {
          speed = 2.0;
          ang = aim(position,pl.position.getPosition());
        }
      }
    }
  }
  
  class Boss extends Enemy {
    int type = 0;
    int count = 0;
    Boss(Position position,int hp) {
      super(position,hp);
      size = 80.0;
    }
    void render() {
      noTint();
      imageMode(CENTER);
      image(momotaro,position.x,position.y,size,size);
    }
    void run() {
      if(time == 0) {
        type = 0;
      }
      if(type % 3 == 0) {
        if(time == 1) {
          targetMode(new Position(160 + random(-100,100),80 +  + random(0,-20)),20,1.5);
        }
        if(time >= 50) {
          for(int i = 0; i< 2; i++) {
            EnemyBullet bl = new EnemyBullet0(random(0,360),random(2.0,5.0),int(random(0,3) ) );
            createObject(bl);
          }
          if(time >= 150) {
            if(time >= 300 || random(0,100) == 0) {
              type++;
              time = 1;
            }
          }
        }
      }
      if(type % 3 == 1) {
        if(time == 20) {
          targetMode(new Position(max(20,min(WIDTH-100,position.x + random(-150,150))),max(100,min(70,position.y+ random(-60,60)))),20, 1.5);
        }
        if(time >= 20 && time % 8 == 0 && time <= 100) {
           for(int i = 0;i<5;i++) {
             float aim_ang = aim(position,pl.position.getPosition());
             for(int j = 0; j<3; j++) {
               EnemyBullet bl = new EnemyBullet1(aim_ang + (i*20-40),j*0.5+3);
               createObject(bl);
             }
           }
        }
        if(time >= 100) {
           type++;
           time = 1;
        }
      }
      if(type % 3 == 2) {
        if(time >= 150) {
          time = 0;
          type++;
          count++;
        }
      }
      
    }
    class EnemyBullet0 extends EnemyBullet {
      EnemyBullet0(float ang,float speed,int col) {
          this.ang = ang;
          this.speed = speed;
          image = BulletImage.get("bullet0-" + Integer.toString(col));
        
      }
      void run() {
        if(Boss.this.type == Boss.this.count * 3 + 1) {
          speed = 0;
          accele = 0;
          image = BulletImage.get("bullet0-12");
        }
        if(Boss.this.type == Boss.this.count * 3 + 2 && Boss.this.time == 30) {
          accele = 0.01;
          ang = random(0,360);
        }
      }
    }
    class EnemyBullet1 extends EnemyBullet {
      EnemyBullet1(float ang,float speed) {
        this.ang = ang;
        this.speed = speed;
        this.image = BulletImage.get("bullet0-8");
      }
      void run() {}
    }
  }
}
