<<<<<<< HEAD
//定数
import java.util.Iterator;
final float PLAYER_SIZE = 20.0;
final float PLAYER_SPEED = 6.0;
final int WIDTH = 640;
final int HEIGHT = 480;
float rad(float ang) {
    return ang / 180  * PI;
}

//MovingObject
abstract class GameObject {
  HashMap<String,Float> Value = new HashMap<String,Float>();
  HashMap<String,Float> defaultValue = new HashMap<String,Float>();
  ArrayList<VoidFunc> task = new ArrayList<VoidFunc>();
  ArrayList<VoidFunc> update = new ArrayList<VoidFunc>();
  int point = 0;
  boolean isNext = true;
  boolean destroyFlag = false;
  //ここにゲームオブジェクトのcommandを入力する
  abstract void run();
  //task処理および整理
  void processing() {
    if(isNext && point != task.size()) {
      update.add(task.get(point));
      point++;
    }
    Iterator<VoidFunc> it = update.iterator();
    int i = 0;
    while(it.hasNext()) {
      VoidFunc c = it.next();
      c.run();
      isNext = c.isNext;
      if(c.endflag) {
        it.remove();
      }
      i++;
    }
  }
  
  void isDestroy() {
    isScreen();
  }
  void isScreen() {
    float x = getValue_("x");
    float y = getValue_("x");
    if(WIDTH < x || x < 0 || HEIGHT < y || y < 0) {
      destroyFlag = true;
    }
  }
  void setupObject() {
    defaultKeySet();
    defaultSync();
    run();
  }
  void defaultKeySet() {
    defaultValue.put("x",320.0);
    defaultValue.put("y",240.0);
    defaultValue.put("speed",0.0);
    defaultValue.put("accele",0.0);
    defaultValue.put("size",4.0);
    defaultValue.put("ang",0.0);
  }
  void defaultSync() {
    for(String k :defaultValue.keySet()) {
       Value.put(k,defaultValue.get(k));
    }
  }
  void render() {
    float x = getValue_("x");
    float y = getValue_("y");
    float size = getValue_("size");
    rect(x,y,size,size);
  }
  void update() {
    float x = getValue_("x");
    float y = getValue_("y");
    println(x,y);
    float speed = getValue_("speed");
    float accele = getValue_("accele");
    float ang = getValue_("ang");
    float update;
    
    update = cos(rad(ang)) * speed;
    Value.replace("x",new Float(x+update));
    update = sin(rad(ang)) * speed;
    Value.replace("y",new Float(y+update));
    update = accele;
    Value.replace("speed",new Float(speed+update));
  }
  abstract class Command {
    ReturnFunc<? extends Number> value;
    boolean endflag = true;
    boolean isNext = true;
  }
  abstract class ReturnFunc<T> extends Command {
    abstract T run();
  }
  abstract class VoidFunc extends Command {
    abstract void run();
  }
  
  class Parse<T> extends ReturnFunc<T> {
    T v;
    Parse(T v) {
      this.v = v;
    }
    T run() {
      return v;
    }
  }
  class Compare<T extends Comparable<T>> extends ReturnFunc<Boolean> {
    ReturnFunc<T> a,b;
    Compare(ReturnFunc<T> a,ReturnFunc<T> b) {
      this.a = a;
      this.b = b;
    }
    Boolean run() {
      return b.run().compareTo(a.run()) == 1;
      //return this.a.run() < this.b.run();
    }
  }
  <T extends Comparable<T>> ReturnFunc<Boolean> compare(ReturnFunc<T> a,ReturnFunc<T> b) {
    ReturnFunc<Boolean> c = new Compare(a,b);
    return c;
  }
  
  class Equivalent extends ReturnFunc<Boolean> {
    ReturnFunc<? extends Number> a,b;
    Equivalent(ReturnFunc<? extends Number> a,ReturnFunc<? extends Number> b) {
      this.a = a;
      this.b = b;
    }
    Boolean run() {
      return this.a.run() != this.b.run();
    }
  }
  ReturnFunc<Boolean> equivalent(ReturnFunc<? extends Number> a,ReturnFunc<? extends Number> b) {
    ReturnFunc<Boolean> c = new Equivalent(a,b);
    return c;
  }
  
  //代入
  class SetValue extends VoidFunc {
    String k;
    SetValue(String k,ReturnFunc<? extends Number> value) {
      this.value = value;
      this.k = k;
    }
    void run() {
      //println("set",k,value.run().floatValue());
      GameObject.this.Value.replace( k,value.run().floatValue() );
    }
  }
  void setValue(String k,ReturnFunc<? extends Number> value) {
    VoidFunc c = new SetValue(k,value);
    task.add(c);
  }
  
  //取得
  class GetValue extends ReturnFunc<Float> {
    String k;
    GetValue(String k) {
      this.k = k;
    }
    Float run() {
      return GameObject.this.Value.get(k);
    }
  }
  ReturnFunc<Float> getValue(String k) {
    ReturnFunc<Float> c = new GetValue(k);
    return c;
  }
  
  //宣言
  class statement extends VoidFunc {
    String k;
    statement(String k,ReturnFunc<? extends Number> value) {
      this.k = k;
      this.value = value;
    }
    void run() {
      GameObject.this.Value.put(k,value.run().floatValue());
    }
  }
  void statement(String k,ReturnFunc<? extends Number> value) {
    VoidFunc c = new statement(k,value);
    task.add(c);
  }
  
  //指定されたフレーム数待つ
  class Wait extends VoidFunc {
    private int i = 0,frame;
    Wait(int frame) {
      this.frame = frame;
      isNext =  false;
      endflag =  false;
    }
    void run() {
      i++;
      if(i > frame) {
        isNext = true;
        endflag = true;
      }
    }
  }
  void wait(int value) {
    VoidFunc c = new Wait(value);
    task.add(c);
  }
  
  class Add2 extends ReturnFunc<Float> {
    ReturnFunc<Float> a,b;
    Add2(ReturnFunc<Float> a,ReturnFunc<Float> b) {
      this.a = a;
      this.b = b;
    }
    Float run() {
      return a.run() + b.run();
    }
  }
  ReturnFunc<Float> add2(ReturnFunc<Float> a,ReturnFunc<Float> b) {
    ReturnFunc<Float> c = new Add2(a,b);
    return c;
  }
  
  class Multiply2 extends ReturnFunc<Float> {
    ReturnFunc<Float> a,b;
    Multiply2(ReturnFunc<Float> a,ReturnFunc<Float> b) {
      this.a = a;
      this.b = b;
    }
    Float run() {
      return a.run() * b.run();
    }
  }
  ReturnFunc<Float> multiply2(ReturnFunc<Float> a,ReturnFunc<Float> b) {
    ReturnFunc<Float> c = new Multiply2(a,b);
    return c;
  }
  
  class AddValue extends VoidFunc {
    String k;
    AddValue(String k,ReturnFunc<? extends Number> value) {
      this.k = k;
      this.value = value;
    }
    void run() {
      float base = GameObject.this.Value.get(k);
      GameObject.this.Value.replace(k,base + value.run().floatValue() );
    }
  }
  void addValue(String k,ReturnFunc<Float> value) {
    VoidFunc c = new AddValue(k,value);
    task.add(c);
  }
  
  class MultiplyValue extends VoidFunc {
    String k;
    MultiplyValue(String k,ReturnFunc<? extends Number> value) {
      this.k = k;
      this.value = value;
    }
    void run() {
      float base = GameObject.this.Value.get(k);
      GameObject.this.Value.replace(k,base * value.run().floatValue() );
    }
  }
  void multiplyValue(String k,ReturnFunc<Float> value) {
    VoidFunc c = new MultiplyValue(k,value);
    task.add(c);
  }
  
  class RandomValue extends ReturnFunc<Float> {
    ReturnFunc<Float> min,max;
    RandomValue(ReturnFunc<Float> min,ReturnFunc<Float> max) {
      this.min = min;
      this.max = max;
    }
    Float run() {
      return random(min.run(),max.run());
    }
  }
  ReturnFunc<Float> RandomValue(ReturnFunc<Float> min,ReturnFunc<Float> max) {
    ReturnFunc<Float> c = new RandomValue(min,max);
    return c;
  }
  
  class MyIf extends VoidFunc {
    ReturnFunc<Boolean> bool;
    int end;
    MyIf(ReturnFunc<Boolean> bool,int end) {
      this.end = end;
      this.bool = bool;
    }
    void run() {
      if( !(bool.run()) ) {
        GameObject.this.point += end;
      }
    }
  }
  void myIf(ReturnFunc<Boolean> bool,int end) {
    VoidFunc c = new MyIf(bool,end);
    task.add(c);
  }
  
  class MyWhile extends VoidFunc {
    ReturnFunc<Boolean> bool;
    int end;
    boolean startFlag = true;
    int start;
    MyWhile(ReturnFunc<Boolean> bool,int end) {
      this.end = end;
      this.bool = bool;
      this.endflag = false;
     
    }
    void run() {
      int point = GameObject.this.point;
      int localPoint = point-start;
      if(point == start) {
        
      }
      if(startFlag) {
        start = point;
        startFlag = false;
      }
      if(start == point) {
        endflag = false;
      }
      if(localPoint >= end) {
        if( !(bool.run()) ) {
          endflag = true;
        } else {
          GameObject.this.point = start;
        }
      }
    }
  }
  void myWhile(ReturnFunc<Boolean> bool,int end) {
    VoidFunc c = new MyWhile(bool,end);
    task.add(c);
  }
  class Aim extends ReturnFunc<Float>{
    ReturnFunc<Float> x1,y1,x2,y2;
    Aim(ReturnFunc<Float> x1,ReturnFunc<Float> y1,ReturnFunc<Float> x2,ReturnFunc<Float> y2) {
      this.x1=x1;
      this.y1=y1;
      this.x2=x2;
      this.y2=y2;
    }
    Float run() {
      return atan2(y2.run()-y1.run(),x2.run()-x1.run()) * 180 / PI;
    }
  }
  ReturnFunc<Float> aim(ReturnFunc<Float> x1,ReturnFunc<Float> y1,ReturnFunc<Float> x2,ReturnFunc<Float> y2) {
    ReturnFunc<Float> c =  new Aim(x1,y1,x2,y2);
    return c;
  }
  
  class GetPlayerX extends ReturnFunc<Float> {
    Player pl;
    GetPlayerX(Player pl) {
      this.pl = pl;
    }
    Float run() {
      return pl.getX();
    }
  }
  ReturnFunc<Float> getPlayerX(Player pl) {
    ReturnFunc<Float> c = new GetPlayerX(pl);
    return c;
  }
  
  class GetPlayerY extends ReturnFunc<Float> {
    Player pl;
    GetPlayerY(Player pl) {
      this.pl = pl;
    }
    Float run() {
      return pl.getY();
    }
  }
  ReturnFunc<Float> getPlayerY(Player pl) {
    ReturnFunc<Float> c = new GetPlayerY(pl);
    return c;
  }
  
  class CreateObject extends VoidFunc{
    GameObject obj;
    CreateObject(GameObject obj) {
      this.obj = obj;    
    }
    void run() {
      //println("add");
      addData.add(obj);
    }
  }
  void createObject(GameObject obj) {
    VoidFunc c = new CreateObject(obj);
    task.add(c);
  }
  
 
  float getValue_(String k) {
    return Value.get(k);
  }
}
/*
class Bullet extends GameObject {
  float ang;
  int m;
  Player pl;
  Bullet(float ang,int m,Player pl) {
    this.ang = ang;
    this.m = m;
    this.pl = pl;
    setupObject();
  }
  void run() {
    setValue("ang",new Parse<Float>(ang));
    statement("ang_accele",new Parse<Float>(5.0 * m));
    statement("i",new Parse<Float>(0.0));
    setValue("speed",new Parse<Float>(0.0));
    setValue("accele",new Parse<Float>(0.01));
    myWhile(compare(getValue("i"),new Parse<Float>(50.0)),2);
      addValue("ang",getValue("ang_accele"));
      addValue("i",new Parse<Float>(1.0) );
    
    wait(100);
    setValue("ang",aim( getValue("x"),getValue("y"),getPlayerX(pl),getPlayerY(pl) ));
  }
}
*/

abstract class Stage extends GameObject {
  Enemy boss;
  void update() {}
  void render() {}
  abstract void run();
  abstract class Enemy extends GameObject {
    float hp;
    Enemy(float hp) {
      this.hp = hp;
    }
    void isDestroy() {
      isScreen();
      if(hp < 0) {
        destroyFlag = true;
      }
    }
    abstract void run();
    abstract class Bullet extends GameObject {
      abstract void run();
      void defaultKeySet() {
        defaultValue.put("x",Enemy.this.getValue_("x"));
        defaultValue.put("y",Enemy.this.getValue_("y"));
        defaultValue.put("speed",1.0);
        defaultValue.put("accele",0.1);
        defaultValue.put("size",4.0);
        defaultValue.put("ang",0.0);
      }
    }
  }
}

class Stage1 extends Stage{
  Player pl;
  Stage1(Player pl) {
   this.pl = pl;
   setupObject();
  }
  void run() {
    createObject(new Enemy0(5.0));
  }
  
  class Enemy0 extends Enemy {
    Enemy0(float hp) {
      super(hp);
      setupObject();
    }
    void run() {
      statement("i",new Parse<Float>(0.0));
      statement("j",new Parse<Float>(0.0));
      statement("tmp",new Parse<Float>(1.0));
      myWhile(compare(getValue("i"),new Parse<Float>(3.0)),7);
        myWhile(compare(getValue("j"),new Parse<Float>(360.0)),2);
          addValue("j",new Parse<Float>(18.0));
          createObject(new Bullet0(getValue("j"),getValue("tmp"),Stage1.this.pl));
        addValue("i",new Parse<Float>(1.0));
        multiplyValue("tmp",new Parse<Float>(-1.0));
        setValue("j",new Parse<Float>(0.0));
        wait(50);
    }
    
    
    
    class Bullet0 extends Bullet {
      ReturnFunc<Float> ang;
      ReturnFunc<Float> m;
      Player pl;
      Bullet0(ReturnFunc<Float> ang,ReturnFunc<Float> m,Player pl) {
        this.ang = ang;
        this.m = m;
        this.pl = pl;
        setupObject();
      }
      void run() {
        setValue("ang",ang);
        statement("ang_accele",multiply2(new Parse<Float>(5.0),m));
        statement("i",new Parse<Float>(0.0));
    
        setValue("speed",new Parse<Float>(0.0));
        setValue("accele",new Parse<Float>(0.001));
        myWhile(compare(getValue("i"),new Parse<Float>(50.0)),2);
          addValue("ang",getValue("ang_accele"));
          addValue("i",new Parse<Float>(1.0) );
        
        wait(40);
        setValue("ang",aim( getValue("x"),getValue("y"),getPlayerX(pl),getPlayerY(pl) ));
      }
    }
  }
}

//Input
int bit;
int shift = 0;
void keyPressed() {
    if (keyCode == RIGHT) bit |= (1<<0); //00000001
    if (keyCode == LEFT)  bit |= (1<<1); //00000010
    if (keyCode == UP)    bit |= (1<<2); //00000100  
    if (keyCode == DOWN)  bit |= (1<<3); //00001000
    if (keyCode == SHIFT) shift = 1;
  }
void keyReleased() {
    if (keyCode == RIGHT) bit &= ~(1<<0);
    if (keyCode == LEFT)  bit &= ~(1<<1);
    if (keyCode == UP)    bit &= ~(1<<2);
    if (keyCode == DOWN)  bit &= ~(1<<3);
    if (keyCode == SHIFT) shift = 0;
}
//Playerクラス
class Player {
  private float x,y,size,speed;
  Player (float _x,float _y,float _size,float _speed) {
    x =_x;
    y = _y;
    size = _size;
    speed = _speed;
  }
  //座標の更新　及び表示
  void update() {
      float sp = speed / (shift + 1);
      if ((bit&(1<<0))>0) x+=sp;
      if ((bit&(1<<1))>0) x-=sp;
      if ((bit&(1<<2))>0) y-=sp;
      if ((bit&(1<<3))>0) y+=sp;
      x=max(x,0);
      x=min(x,WIDTH);
      y=max(y,0);
      y=min(y,HEIGHT);
  }
  void render() {
    rect(x,y,size,size);
  }
  float getX() {    
=======
import java.util.Iterator;
import java.util.ArrayDeque;
//定数
final float PLAYER_SIZE = 40.0;
final float PLAYER_SPEED = 6.0;
final int WIDTH = 320;
final int HEIGHT = 480;
final float MARGIN = 100;

Collider collider = new Collider(6);
Player pl = new Player0(new Position(WIDTH/2,HEIGHT/2),PLAYER_SIZE,PLAYER_SPEED);
Stage stage = new Stage0();
Frame frame = new Frame();

abstract class GameObject {
  PImage image;
  float size=1,speed=0,collider_size;
  boolean destroyFlag = false;
  Position position = new Position(0,0);
  boolean collision = false;
  int objType = 0;
  int time;
  GameObject() {
    collider.cliner.regist(this);
    collider_size = size/2;
  }
  void processing() {
    run();
    update();
    render();
    time++;
    destroyFlag = isDestroy();
  }
  abstract void run();
  abstract void update();
  void render() {
    imageMode(CENTER);
    tint(200,150);
    image(image,position.x,position.y,size,size);
    
  }
  boolean isDestroy() {
    if(position.x > (WIDTH + MARGIN) || position.x < MARGIN*-0.5 || position.y > (HEIGHT + MARGIN) || position.y < MARGIN * -0.5) {
      return true;
    }
    return false;
  }
}

float distance(Position a,Position b) {
    return sqrt(sq(a.x-b.x) + sq(a.y-b.y));
}
float rad(float ang) {
    return ang / 180  * PI;
}

class Position {
  float x,y;
  Position(float x,float y) {
    this.x = x;
    this.y = y;
  }
  float getX() {
>>>>>>> add new file
    return x;
  }
  float getY() {
    return y;
  }
<<<<<<< HEAD
 
}

ArrayList<GameObject> objData  = new ArrayList<GameObject>();
ArrayList<GameObject> addData;
Player pl = new Player(WIDTH/2,HEIGHT/2,PLAYER_SIZE,PLAYER_SPEED);
Stage stage = new Stage1(pl);
void setup() {
  size(640,480);
  rectMode(CENTER);
  objData.add(stage);
}

void draw() {
  background(0);
  pl.update();
  pl.render();
  addData  = new ArrayList<GameObject>();
  Iterator<GameObject> it = objData.iterator();
  int i=0;
  while(it.hasNext()) {
    GameObject obj = it.next();
    obj.update();
    obj.render();
    obj.processing();
    /*
    if(obj.destroyFlag) {
      it.remove();
    }*/
    i++;
  }
  it = addData.iterator();
  while(it.hasNext()) {
    GameObject obj = it.next();
    objData.add(obj);
  }
=======
  Position getPosition() {
    return new Position(x,y);
  }
}
PImage frame_image,logo,player_text,bomb_text,score_text,window,oni,momotaro,life,hoshi;
PFont stateFont;

HashMap<String,PImage> BulletImage = new HashMap<String,PImage>();


void setup() {
  size(640,480,P3D);
  ellipseMode(CENTER);
  rectMode(CENTER);
  colorMode(RGB,256);
  objData.add(stage);
  objData.add(pl);
  logo = loadImage("logo.png");
  frame_image = loadImage("frame.png");
  score_text = loadImage("score_text.png");
  player_text = loadImage("player_text.png");
  bomb_text = loadImage("bomb_text.png");
  window = loadImage("window.png");
  oni = loadImage("oni.png");
  life = loadImage("life.png");
  hoshi = loadImage("hoshi.png");
  momotaro = loadImage("momotaro.png");
  stateFont = loadFont("AppleSDGothicNeo-Heavy-48.vlw");
  
  for(int i = 0; i<=7;i++) {
    for(int j = 0; j< 14; j++) {
      String id = "bullet" + Integer.toString(i) + '-' + Integer.toString(j);
      println(id);
      BulletImage.put(id,loadImage(id + ".tif"));
    }
  }
}

ArrayList<GameObject> objData  = new ArrayList<GameObject>();
ArrayList<GameObject> addData;

void draw() {
    background(0);
    addData  = new ArrayList<GameObject>();
    Iterator<GameObject> it = objData.iterator();
    int i=0;
    collider.cliner.allCollisionList();
    while(it.hasNext()) {
      GameObject obj = it.next();
      obj.processing();
      if(obj.destroyFlag) {
        it.remove();
      }
    }
    it = addData.iterator();
    while(it.hasNext()) {
      GameObject obj = it.next();
      objData.add(obj);
    }
    frame.run();
}

void drawOutlineText(String text, float x, float y, int size, int fgColor, int bgColor) {
  float outlineWidth = (float)(size / 24.0);
  textSize(size);
  fill(bgColor);
  text(text, x - outlineWidth, y + size - outlineWidth);
  text(text, x + outlineWidth, y + size - outlineWidth);
  text(text, x - outlineWidth, y + size + outlineWidth);
  text(text, x + outlineWidth, y + size + outlineWidth);
  fill(fgColor);
  text(text, x, y + size);
>>>>>>> add new file
}
