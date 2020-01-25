class Stage0 extends Stage {
  int step = 0;
  Position[] Enemy0Pattern = {
    new Position(200,50),
    new Position(100,50),
    new Position(300,50),
    new Position(150,50),
    new Position(250,50)
  };
  void run() {
    /*
    if(time %10== 0) {
      
      addData.add(new Explosion(new Position(50,50),50,10,BulletImage.get("bullet0-0")));
    }*/
    
    if(step == 0) {
      if(time == 0) {
        speed = 0;
      }
      for(int i = 0; i < 5; i++) {
        if(time == (i+1)*40) {
          Enemy0 en = new Enemy0(Enemy0Pattern[i],15);
          createObject(en);
        }
      }
      if(time == 500) {
        Serif[] serif = {
          new Serif("ちくしょう、今年も遂に始まってしまった...","鬼"),
          new Serif("全日本豆まき選手権！","鬼"),
          new Serif("そこで暴れている鬼に告ぐ！直ちに抵抗をやめなさい！","桃太郎"),
          new Serif("貴様...桃太郎か！","鬼"),
          new Serif("抵抗をやめたところでどうせ豆をぶつけられるんだろう！","鬼"),
          new Serif("これは人類の無病息災を祈って行われる神聖な行事なんだ","桃太郎"),
          new Serif("鬼にとってこんなにはた迷惑な行事があるものか","鬼"),
          new Serif("こちらからすると貴方がたの方がはた迷惑な存在だが","桃太郎"),
          new Serif("黙れ！","鬼"),
          new Serif("毎年毎年一方的に豆を投げつけられる恐怖に慄くのはもう懲り懲りだ","鬼"),
          new Serif("今こそ叛旗を翻せ！","鬼"),
          new Serif("なんてことだ...鬼が抵抗力を持ってしまっては大会が壊れてしまう！","桃太郎"),
          new Serif("何としてでも阻止せねば！","桃太郎"),
        };
        Picture[] pic = {
          new Picture(oni_tatie,"鬼",true),
          new Picture(momotaro,"桃太郎",false)
        };
        com = new Communication(serif,pic);
      }
      if(time > 500 && !kaiwa) {
        step++;
        time = 0;
      }
      
    } else if(step == 1) {
      if(time == 10) {
        Boss boss = new Boss(new Position(0,0),500);
        createObject(boss);
      }
    }
    
    
  }
  class Enemy0 extends Enemy {
    Enemy0(Position position,int hp) {
      super(position,hp);
      speed = 2.0;        
      image = inu;
      size = 30.0;
    }
    void render() {
      imageMode(CENTER);
      noTint();
      if(image != null)image(image,position.x,position.y,size,size*1.8);
      
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
        this.image = BulletImage.get("bullet0-1");
        addData.add(new Explosion(position.getPosition(),50,5,image));
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
            Position pos = position.getPosition();
            float ang = random(0,360);
            pos.x += cos(rad(ang)) * 20;
            pos.y += sin(rad(ang)) * 20;
            EnemyBullet bl = new EnemyBullet0(pos,ang,random(2.0,5.0),int(random(0,12) ) );
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
      EnemyBullet0(Position pos,float ang,float speed,int col) {
          this.position =pos;
          this.ang = ang;
          this.speed = speed;
          image = BulletImage.get("bullet6-" + Integer.toString(col));
          
          addData.add(new Explosion(position.getPosition(),50,5,image));
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
