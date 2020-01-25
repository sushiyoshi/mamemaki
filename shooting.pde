import java.util.Iterator;
import java.util.ArrayDeque;
//定数
final float PLAYER_SIZE = 40.0;
final float PLAYER_SPEED = 6.0;
final int WIDTH = 340;
final int HEIGHT = 480;
final float MARGIN = 100;

Collider collider = new Collider(6);
Player pl = new Player0(new Position(WIDTH/2,HEIGHT/2),PLAYER_SIZE,PLAYER_SPEED);
Stage stage = new Stage0();
Frame frame = new Frame();
BackGround back = new BackGround();

abstract class GameObject {
  PImage image;
  float size=1,speed=0,collider_size;
  boolean destroyFlag = false;
  Position position = new Position(0,0);
  boolean collision = false;
  int objType = 0;
  int time;
  GameObject() {
    
  }
  void processing() {
    run();
    update();
    render();
    time++;
    destroyFlag = isDestroy();
  }
  void run(){}
  abstract void update();
  void render() {
    imageMode(CENTER);
    noTint();
    if(image != null)image(image,position.x,position.y,size,size);
    
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
    return x;
  }
  float getY() {
    return y;
  }
  Position getPosition() {
    return new Position(x,y);
  }
 
}

ArrayList<GameObject> objData  = new ArrayList<GameObject>();
ArrayList<GameObject> addData;

PImage frame_image,logo,player_text,bomb_text,score_text,window,oni,momotaro,life,hoshi,inu,background,oni_tatie;
PFont stateFont,serifFont;

HashMap<String,PImage> BulletImage = new HashMap<String,PImage>();
PImage[] KusaImage = new PImage[5];

void setup() {
  size(640,480,P2D);
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
  inu = loadImage("inu.png");
  background = loadImage("background.png");
  oni_tatie = loadImage("oni_tatie.png");
  
  
  
  stateFont = loadFont("AppleSDGothicNeo-Heavy-48.vlw");
  serifFont = createFont("MS PGothic.vlw",48,true);
  textFont(serifFont, 48);
  for(int i = 0; i<=7;i++) {
    for(int j = 0; j< 14; j++) {
      String id = "bullet" + Integer.toString(i) + '-' + Integer.toString(j);
      BulletImage.put(id,loadImage(id + ".png"));
    }
  }
  for(int i = 0; i<5;i++) {
    String id = "kusa" + Integer.toString(i+1);
    KusaImage[i] = loadImage(id+".png");
  }
}


boolean kaiwa = false;
Communication com = null;


void draw() {
    back.run();
    addData  = new ArrayList<GameObject>();
    Iterator<GameObject> it = objData.iterator();
    int i=0;
    collider.cliner.allCollisionList();
    while(it.hasNext()) {
      GameObject obj = it.next();
      obj.processing();
      if(obj.destroyFlag) {
        println(obj);
        it.remove();
      }
      i++;
    }
    it = addData.iterator();
    while(it.hasNext()) {
      GameObject obj = it.next();
      objData.add(obj);
    }
    if(kaiwa && com != null) com.run();
    
    frame.run();
    
    println(frameRate,i);
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
  //println(text);
  
}
