class FX{

}
class emiter{
  float x1=0;
  float x2=0;
  float v1=0;
  float v2=0;
  float r1=0;
  float r2=0;
  PImage img;
  boolean hasImg=false;
  float red1,green1,blue1,red2,green2,blue2;
  int curTime=0;
  int frame1=0;
  int frame2=0;
  int perFrame;
  emiter(){
    hasImg=false;
    curTime=0;
    frame1=0;
    frame2=0;
    perFrame=0; 
  }
  emiter(float d1,float d2,float s1,float s2,float tr1,float tr2,color c1,color c2,int init, int fin){
    x1=d1;
    x2=d2;
    v1=s1;
    v2=s2;
    r1=tr1;
    r2=tr2;
    red1=red(c1);
    red2=red(c2);
    green1=green(c1);
    green2=green(c2);
    blue1=blue(c1);
    blue2=blue(c2);
    hasImg=false;
    frame1=init;
    frame2=fin;
  }
  sprite[] upDate(){
    curTime++;
    sprite[] nSprites = new sprite[perFrame];
    if(frame1<=curTime&&curTime<=frame2){

      float theta;
      float tx;
      float tv;
      for(int i = 0; i < nSprites.length; i++){
        theta = random(TWO_PI);
        tx=random(x1,x2);
        tv=random(v1,v2);
        if(hasImg){
          nSprites[i]=new sprite(tx*cos(theta),tx*sin(theta),tv*cos(theta),tv*sin(theta),random(r1,r2),color(random(red1,red2),random(green1,green2),random(blue1,blue2)),img);
        }
        else{
          nSprites[i]=new sprite(tx*cos(theta),tx*sin(theta),tv*cos(theta),tv*sin(theta),random(r1,r2),color(random(red1,red2),random(green1,green2),random(blue1,blue2)));
        }
      }
    }
    return nSprites; 
  }
}
class sprite{
  float x=0;
  float y=0;
  color c;
  float xv=0;
  float yv=0;
  float r = 0;
  PImage img;
  boolean hasImg=false;
  sprite(){
    hasImg=false;
  }
  sprite(float x1, float y1, float xv1, float yv1,float r1,color c1){
    c=c1;
    x=x1;
    y=y1;
    xv=xv1;
    yv=yv1;
    r=r1;
    hasImg=false;
  }
  sprite(float x1, float y1, float xv1, float yv1,float r1,color c1, PImage img1){
    c=c1;
    x=x1;
    y=y1;
    xv=xv1;
    yv=yv1;
    img = img1;
    r=r1;
    hasImg=true;
  }
  void upDate(){
    x+=xv;
    y+=yv; 
  }
  void draw(vector p){
    if(p.z()<r){
      float x1 =-(p.x()+x)*cameraZ/p.z()+width/2;
      float x2 = -(p.y()+y)*cameraZ/p.z()+height/2;
      float x3= -r*cameraZ/p.z();
      if(x1>0&&width>x1&&x2>0&&height>x2){
        if(hasImg){
          imageMode(CORNER);
          image(img,x1-x3/2,x2-x3/2,x3,x3);
        }
        else{
          stroke(c);
          point(x1,x2);
        } 
      }
    }
  }
}
