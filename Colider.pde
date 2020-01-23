class Collider { 
  int maxlevel;
  int len;
  Cliner4TreeManager cliner;
  Collider(int maxlevel) {
    this.maxlevel = maxlevel;
    this.len = LinearQuadtree_getLead(maxlevel+1);
    this.cliner = new Cliner4TreeManager();
  }
  int getMortonNumber_Point(Position pos) {
    float x = pos.x / ((WIDTH + MARGIN) / pow(2,maxlevel));
    float y = pos.y / ((HEIGHT + MARGIN) / pow(2,maxlevel));
    return (bitSeparate32(int(x)) | (bitSeparate32(int(y))<<1));
  }
  int bitSeparate32(int n) {
    n = (n|(n<<8)) & 0x00ff00ff;
    n = (n|(n<<4)) & 0x0f0f0f0f;
    n = (n|(n<<2)) & 0x33333333;
    return (n|(n<<1)) & 0x55555555;
  }
  
  boolean isCollision(Position pos1,Position pos2,float size) {
    return sq(pos1.x-pos2.x) + sq(pos1.y-pos2.y) < sq(size);
  }
  int getMortonNumber_Object(GameObject obj) {
    Position upper_left_pos = new Position(obj.position.x - obj.collider_size + MARGIN,obj.position.y+obj.collider_size + MARGIN);
    Position lower_right_pos = new Position(obj.position.x + obj.collider_size + MARGIN,obj.position.y-obj.collider_size + MARGIN);
    int upper_left = getMortonNumber_Point(upper_left_pos);
    int lower_right = getMortonNumber_Point(lower_right_pos);
    int xor = upper_left ^ lower_right;
    int shift = 0;
    while(xor != 0) {
      if(shift > 10) break;
      xor >>=2;
      shift++;
    }
    //if(shift > 10)println(upper_left,lower_right,upper_left_pos.x,upper_left_pos.y,lower_right_pos.x,lower_right_pos.y);
    int re = lower_right >> shift * 2;
    
    return re;
  }
  int LinearQuadtree_getLead(int l) {
    return int((pow(4,l)-1)/3);
  }
  class Cliner4TreeManager {
    CCell[] cellArray = new CCell[len];
    int[] Level_FirstIndex =  new int[len];
    Cliner4TreeManager() {
      for(int i = 0;i<len; i++) cellArray[i] = new CCell();
      for(int i = 0;i<=maxlevel+1; i++){
        Level_FirstIndex[i] = LinearQuadtree_getLead(i);
      }
    }
    void collisionDetection(GameObject target,GameObject partner) {
      float size = target.collider_size+partner.collider_size; 
      if(isCollision(target.position,partner.position,size)) {
         target.collision = true;
         
      }
    }
    void regist(GameObject obj) {     
      int elem = getMortonNumber_Object(obj);
      if(elem >= 0 && elem < Level_FirstIndex[maxlevel+1])  {
        cellArray[elem].push(obj);
      } else {
        println("regist_error",obj,elem);
      }
      
    }
    void allCollisionList() {
      ArrayDeque<TargetList> targetList = new ArrayDeque<TargetList>();
      getCollisionList(0,0,targetList);
    }
    void getCollisionList(int index,int level,ArrayDeque<TargetList> targetList) {
      targetList.push(new TargetList());
      if(!cellArray[index].isEmpty) {
        TreeObject base = cellArray[index].first.next;
        ArrayList<TreeObject> list = targetList.peek().list;
        while(base != cellArray[index].last) {
          list.add(base);
          base.index = index;
          TreeObject target = base.next;
          int baseType = base.obj.objType;
          while(target != cellArray[index].last) {
            if(baseType == 2) break;
            int targetType = target.obj.objType;
            switch(baseType) {
              //Player
              case 0:
              if(targetType == 3 || targetType == 4) {
                collisionDetection(base.obj,target.obj);
              }
              break;
              //PlayerBullet
              case 1:
              if(targetType == 3) {
                collisionDetection(target.obj,base.obj);
              }
              break;
              //Enemy
              case 3:
              if(targetType == 0) {
                collisionDetection(target.obj,base.obj);
              }
              if(targetType == 1) {
                collisionDetection(base.obj,target.obj);
              }
              break;
              //EnemyBullet
              case 4:
              if(targetType == 0) {
                collisionDetection(target.obj,base.obj);
              }
              break;

            }
            target = target.next;
          }
          TreeObject tmp = base;
          base = base.next;
          tmp.processing();
        }
      }
      if(level+1 > maxlevel) {
        targetList.pop();
      } else {
        for(int i = 0; i< 4; i++) {
          int nextIndex = index*4+i+1;         
          getCollisionList(nextIndex,level+1,targetList);
        }
      }
      
    }
    class TargetList {
      ArrayList<TreeObject> list = new ArrayList<TreeObject>();
    }
    class CCell {
      boolean isEmpty = true;
      TreeObject first;
      TreeObject last;
      CCell() {
        createDummy();
      }
      void createDummy() {
        first = new TreeObject();
        last = new TreeObject();
        first.next = last;
        first.cell = this;
        last.cell = this;
        last.prev = first;
      }
      void push(GameObject obj) {      
        TreeObject node = new TreeObject();
        node.obj = obj;
        node.cell = this;
        node.next = first.next;
        node.prev = first;
        first.next.prev = node;
        first.next = node;
        isEmpty = false;
      }
    }
  
    class TreeObject {
       GameObject obj;
       TreeObject prev;
       TreeObject next;
       int index;
       CCell cell;
       void remove() {
         if(cell.first == prev && cell.last == next) {
           cell.isEmpty = true;
         }
         prev.next = next;
         next.prev = prev;
       }
       void processing() {        
         int morton = getMortonNumber_Object(obj);
         if(morton != index) {
           remove();
           regist(obj);
         }
         if(obj.destroyFlag) {
           remove();
         }
       }
    }
      
  }
}
