import processing.core.*; import ddf.minim.signals.*; import ddf.minim.*; import ddf.minim.analysis.*; import ddf.minim.effects.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class mFlight_0007 extends PApplet {




int curTarget=0;
//import processing.opengl.*;
PFont font;
guy[] peeps=new guy[128];
float camBack = 256;
PImage back;
dotRender render = new dotRender(512,4096,24*1024,28*1024,color(0));
block b=new block();
float cameraZ;
int follow=0;
fig ring;
boolean showMap=false;
boolean firstStart=true;
int score = 0;
int kills=0;
vector[] estments=new vector[32];
AudioPlayer song;

static public void main(String args[]) {
  PApplet.main(new String[] { 
    "--present", "mFlight_0007"           }
  );
}

public void setup(){
  //
  if(firstStart){
   //66142_newgrounds_god_of.mp3
   firstStart=false;
     //Minim.start(this);
 
  // this loads mysong.wav from the data folder
  //song = Minim.loadFile("66142_newgrounds_god_of.mp3");
  //song.play();

  }
  score = 0;
  kills=0;
  size(PApplet.parseInt(640),PApplet.parseInt(480),P3D);
  back=loadImage("paper_parchment01.jpg");
  ring=new fig("ring",color(255,0,255));
  //ring = new fig("lantern",color(255,0,255));
  for(int i = 0; i < deb.length; i++){
    deb[i]=new proj(); 
  }
  loadMods();
  peeps[0]=new guy(0,"Wizard");
  peeps[0].p=new vector(8*4*bw,-6*4*bh,8*4*bw);
  keysPressed = new boolean[256];
  pKeysPressed = new boolean[256];
  font= loadFont("ArialNarrow-32.vlw");
  pCam=new vector();
  cam=new M4();
  //size(screen.width,screen.height,P3D);
  float fov = PI/3.0f;
  cameraZ = ((height/2.0f) / tan(PI*60.0f/360.0f));
  perspective(fov, PApplet.parseFloat(width)/PApplet.parseFloat(height), cameraZ/10.0f, cameraZ*100.0f);
  /*b.builds = new bding[1024];
   for(int i = 0; i < b.builds.length; i++){
   b.builds[i]=new bding(new vector(int(random(-48,48))*8,0,int(random(-48,48))*8),int(random(4,16)),int(random(16,64)),int(random(4,16)));
   }*/
  renderBlock(128,128,1,4,8,2,32);
    for(int i = 0; i < estments.length; i++){
    estments[i]=new vector(random(32*4*bw,96*4*bw),random(-24*4*bh,0),random(32*4*bw,96*4*bw));
    while(b.bIn(new vector(estments[i].x()/bw,estments[i].y()/bh,estments[i].z()/bw))){
      estments[i]=new vector(random(32*4*bw,96*4*bw),random(-24*4*bh,0),random(32*4*bw,96*4*bw));
    }
  }
  for(int i = 0; i < peeps.length;i++){
    if(i!=0){
      peeps[i]=new guy(i,"lantern");
      //peeps[i].target=i;
    }
    else{
      peeps[i]=new guy(i,"Wizard");
      // peeps[i].target=0;
    }
        if(i!=0){
    peeps[i].bAi=true;
    int k = floor(random(estments.length));
    peeps[i].p.x(estments[k].x());
    peeps[i].p.y(estments[k].y());
    peeps[i].p.z(estments[k].z());
    }
    if(i==0){
      boolean done = false;
      for(int j = 0; j < b.builds.length&&!done; j++){
        if(32*4<b.builds[j].p.x()+b.builds[j].x/2&&96*4>b.builds[j].p.x()+b.builds[j].x/2&&32*4<b.builds[j].p.z()+b.builds[j].z/2&&96*4>b.builds[j].p.z()+b.builds[j].z/2){
          peeps[i].p.x((b.builds[j].p.x()+b.builds[j].x/2)*bw);
          peeps[i].p.y((b.builds[j].p.y()-b.builds[j].y)*bh-16);
          peeps[i].p.z((b.builds[j].p.z()+b.builds[j].z/2)*bw);
          done=true;
        }
      } 
    }
  }
  peeps[0].bAi=false;
  println(b.builds.length);
  frameRate(45);
}
public void draw(){
  tap();
  render.back=color(max(128*1.5f*-sin(PApplet.parseFloat(frameCount)/(2048.1f)*PI),0));
  M4 M = new M4();
  if(keysPressed[ENTER]){
    setup(); 
  }
  if(keysPressed[ascii('i')]){
    camBack-=8; 
  }
  if(keysPressed[ascii('k')]){
    camBack+=8; 
  }

  for(int i = 0; i < peeps.length;i++){
    peeps[i].upDate(); 
  }
  if(peeps[curTarget].bActive==false){
    score++;
  }
  int attempts=0;
  while(peeps[curTarget].bActive==false||curTarget==0&&attempts<=512){
    curTarget=floor(random(peeps.length));
    attempts++;
  }
  for(int i = 0; i < peeps.length; i++){
    if(peeps[i].bActive==false&&i!=0){
      peeps[i]=new guy(curTarget,"lantern");
      peeps[i].bAi=true;
    int k = floor(random(estments.length));
    peeps[i].p.x(estments[k].x());
    peeps[i].p.y(estments[k].y());
    peeps[i].p.z(estments[k].z());
    } 
  }
  M = new M4();
  M4 M1 = new M4();
  M.MRot(0,0,peeps[follow].r.z());
  M1.MRot(peeps[follow].r.x()*.75f,0,0);
  M1=MMulti(M1,M);
  M.MRot(0,peeps[follow].r.y(),0);
  M=MMulti(M,M1);
  camBack = constrain(camBack,64,1024);
  pCam=peeps[follow].p.vPlus(new vector(0,-16,camBack).vMRot(M));
  cam=M;
  cam.MTrans();
  //background(232,224,190);
  //background(0);
  //image(back,0,0,width,height);
  ring.draw(peeps[curTarget].p.vPlus(new vector(0,-128,0)),new M4());
  b.draw();
  drawObj();
  projUpdate();
  for(int i = 0; i < peeps.length;i++){
    peeps[i].draw(); 
  }
  fill(255);
  render.draw3();
  if(keysTapped[ascii('m')]){
    showMap=!showMap;
  }
  if(showMap){
    drawMap(16,48);
  }
  //println(peeps[0].target);
  textFont(font,16);
  text(frameRate,16,32);
  text(frameCount,64,32);
  text(score,width-64,32);
  text(kills,width-16,32);
}
public void renderBlock(int x, int y,int rWid,int bMin,int bMax,int hMin,int hMax){
  b.builds=new bding[0];
  boolean[][] m = new boolean[x][y];
  for(int i = 0; i < x; i++){
    for(int j = 0; j < y; j++){
      m=new boolean[x][y];
    }
  }
  int xMax,yMax;
  int yCur=0;
  int xCur=0;
  int wCur=0;
  int hCur=0;
  int dCur=0;
  xMax=0;
  yMax=0;

  while(yMax<y){
    xCur=0;
    while(xCur<x){
      wCur=PApplet.parseInt(random(bMin,bMax));
      hCur=PApplet.parseInt(random(bMin,bMax));
      dCur=PApplet.parseInt(random(hMin,hMax));
      yCur=0;
      for(int i = xCur+rWid; i<xCur+rWid+wCur&&i<x; i++){
        for(int j = y-1; j >= 0; j--){
          if(j>yCur&&m[i][j]){
            yCur=j; 
          }
        } 
      }
      if(yCur>y){
        yCur=0; 
      }
      for(int i = xCur+rWid; i<=xCur+rWid+wCur&&i<x;i++){
        for(int j = yCur+rWid; j<=yCur+rWid+hCur&&j<y;j++){
          m[i][j]=true;
        }
      }
      int choice = floor(random(0,1.999f));
      int breakAt=0;
      switch(choice){
      case 0:
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),wCur*4,dCur*4,hCur*4);
        break; 
      case 1:
        breakAt=PApplet.parseInt(random(4,(wCur-1)*4));
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),breakAt-rWid,4*PApplet.parseInt(random(hMin,hMax)),hCur*4);
        b.addBuilding(new vector((xCur+rWid)*4+breakAt,0,(yCur+rWid)*4),wCur*4-breakAt,dCur*4,hCur*4);
        break;
      case 2:
        breakAt=PApplet.parseInt(random(4,(hCur-1)*4));
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),wCur*4,4*PApplet.parseInt(random(hMin,hMax)),breakAt-rWid);
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4+breakAt),wCur*4,dCur*4,hCur*4-breakAt);
        break;
      }
      //b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),wCur*4,dCur*4,hCur*4);
      xCur=xCur+rWid+wCur;
      if(yCur+rWid+hCur>yMax){
        yMax=yCur+rWid+hCur; 
      }
    }
  }
}
public void drawMap(float x, float y){
  fill(255);
  noStroke();
  rectMode(CORNER);
  for(int i = 0; i < b.builds.length; i++){
    fill(b.builds[i].y*(256/(4*24)));
    rect(b.builds[i].p.x()/2+x,b.builds[i].p.z()/2+y,b.builds[i].x/2,b.builds[i].z/2);
  }
  for(int i = 0; i < estments.length; i++){
    fill(255,255,0);
    rect(estments[i].x()/(2*bw)+x-2,estments[i].z()/(2*bw)+y-2,4,4); 
  }
  ellipseMode(CENTER);
  for(int i = 0; i < peeps.length;i++){
    if(peeps[i].bActive){
      if(i==follow){
        fill(255,0,0);
        stroke(255,0,0);
      }
      else{
        if(i==curTarget){
          fill(0,255,0);
          stroke(0,255,0); 
        }
        else{
          fill(0,0,255);
          stroke(0,0,255);
        }
      }
      ellipse(peeps[i].p.x()/(2*bw)+x,peeps[i].p.z()/(2*bw)+y,2,2);
      vector dir = new vector(0,0,-4).vMRot(0,peeps[i].r.y(),0);
      line(peeps[i].p.x()/(2*bw)+x,peeps[i].p.z()/(2*bw)+y,peeps[i].p.x()/(2*bw)+x+dir.x(),peeps[i].p.z()/(2*bw)+y+dir.z());
    }
  }
  noStroke();
}
public void stop()
{
  song.close();
  super.stop();
}

class fig{
  int iAm =-1;
  vector[][] l = new vector[0][2];
  int[] lc = new int[0];
  pTrail[] tTrail = new pTrail[0];
  vector[] pTrail = new vector[0];
  int[] pc = new int[0];
  vector[] points = new vector[0];
  pTrail[] tt = new pTrail[0];
  fig(){
  }
  fig(String name){
    vector[] tp;
    vector[][] tl;
    float[] tr;
    int[] tc;
    String[] data = loadStrings(name+"/model.txt");
    String[] row = new String[0];
    for(int j= 0; j < data.length; j++){
      row=split(data[j],' ');
      if(row[0].equals("line")){
        tl=new vector[l.length+1][2];
        tc=new int[lc.length+1];
        for(int i = 0; i < l.length;i++){
          tl[i]=l[i];
          tc[i]=lc[i]; 
        }
        tl[tl.length-1][0]=new vector(PApplet.parseFloat(row[1]),PApplet.parseFloat(row[2]),PApplet.parseFloat(row[3]));
        tl[tl.length-1][1]=new vector(PApplet.parseFloat(row[4]),PApplet.parseFloat(row[5]),PApplet.parseFloat(row[6]));
        tc[tc.length-1]=color(PApplet.parseFloat(row[7]),PApplet.parseFloat(row[8]),PApplet.parseFloat(row[9]));
        l=tl;
        lc=tc;
      }
      if(row[0].equals("point")){
        tp=new vector[points.length+1];
        tc=new int[pc.length+1];
        for(int i = 0; i < points.length; i++){
          tp[i]=points[i];
          tc[i]=pc[i];
        } 
        tp[tp.length-1]=new vector(PApplet.parseFloat(row[1]),PApplet.parseFloat(row[2]),PApplet.parseFloat(row[3]));
        if(row.length>=7){
          tc[tc.length-1]=color(PApplet.parseFloat(row[4]),PApplet.parseFloat(row[5]),PApplet.parseFloat(row[6])); 
        }
        else{
          tc[tc.length-1]=render.nullC;  
        }
        pc=tc;
        points=tp;
      }
      if(row[0].equals("trail")){
        tt=new pTrail[tTrail.length+1];
        tp = new vector[pTrail.length+1];
        for(int i = 0; i < tTrail.length; i++){
          tt[i]=tTrail[i];
          tp[i]=pTrail[i];
        }
        tt[tt.length-1]=new pTrail(PApplet.parseInt(row[1]),PApplet.parseFloat(row[2]));
        tp[tp.length-1]=new vector(PApplet.parseFloat(row[3]),PApplet.parseFloat(row[4]),PApplet.parseFloat(row[5]));
        tTrail=tt;
        pTrail=tp;
      }
    }
  }
  fig(String name,int col){
    vector[] tp;
    vector[][] tl;
    float[] tr;
    int[] tc;
    String[] data = loadStrings(name+"/model.txt");
    String[] row = new String[0];
    for(int j= 0; j < data.length; j++){
      row=split(data[j],' ');
      if(row[0].equals("line")){
        tl=new vector[l.length+1][2];
        tc=new int[lc.length+1];
        for(int i = 0; i < l.length;i++){
          tl[i]=l[i];
          tc[i]=lc[i]; 
        }
        tl[tl.length-1][0]=new vector(PApplet.parseFloat(row[1]),PApplet.parseFloat(row[2]),PApplet.parseFloat(row[3]));
        tl[tl.length-1][1]=new vector(PApplet.parseFloat(row[4]),PApplet.parseFloat(row[5]),PApplet.parseFloat(row[6]));
        tc[tc.length-1]=col;
        l=tl;
        lc=tc;
      }
      if(row[0].equals("point")){
        tp=new vector[points.length+1];
        tc=new int[pc.length+1];
        for(int i = 0; i < points.length; i++){
          tp[i]=points[i];
          tc[i]=pc[i];
        } 
        tp[tp.length-1]=new vector(PApplet.parseFloat(row[1]),PApplet.parseFloat(row[2]),PApplet.parseFloat(row[3]));
        if(row.length>=7){
          tc[tc.length-1]=col; 
        }
        else{
          tc[tc.length-1]=col;  
        }
        pc=tc;
        points=tp;
      }
      if(row[0].equals("trail")){
        tt=new pTrail[tTrail.length+1];
        tp = new vector[pTrail.length+1];
        for(int i = 0; i < tTrail.length; i++){
          tt[i]=tTrail[i];
          tp[i]=pTrail[i];
        }
        tt[tt.length-1]=new pTrail(PApplet.parseInt(row[1]),PApplet.parseFloat(row[2]));
        tp[tp.length-1]=new vector(PApplet.parseFloat(row[3]),PApplet.parseFloat(row[4]),PApplet.parseFloat(row[5]));
        tTrail=tt;
        pTrail=tp;
      }
    }
  }

  public void draw(vector pAt, M4 rAt){
    if(pAt.vMinus(pCam).vMag()<render.lineFade){
      for(int i = 0; i < l.length; i++){
        render.addLine(pAt.vPlus(l[i][0].vMRot(rAt)),pAt.vPlus(l[i][1].vMRot(rAt)),lc[i]); 
      }
      for(int i = 0; i < tTrail.length;i++){
        tTrail[i].addPoint(pAt.vPlus(pTrail[i].vMRot(rAt)));
        tTrail[i].draw();
      }
      for(int i = 0; i < points.length; i++){
        render.addPoint(pAt.vPlus(points[i].vMRot(rAt)),pc[i]);
      }
    }
    else{
      if(pAt.vMinus(pCam).vMag()<render.pointFade){
        if(points.length>0){
          render.addPoint(pAt,pc[0]);
        }
        else{
          if(l.length>0){
            render.addPoint(pAt,lc[0]); 
          }
        }
      } 
    }
  } 

  /*void draw(vector p, QUAT r){
   //render.addDot((new vector(32,-128,-32).vMRot(r).vPlus(p)),24,color(255));
   //render.addDot((new vector(-32,-128,-32).vMRot(r).vPlus(p)),24,color(255));    
   
   render.addDot((new vector(0,-112,0).vMRot(r).vPlus(p)),48,color(255));             
   render.addDot((new vector(0,-32,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(0,48,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(64,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(112,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(-64,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(-112,-48,0).vMRot(r).vPlus(p)),16,color(255)); 
   render.addDot((new vector(-32,128,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(-64,216,0).vMRot(r).vPlus(p)),40,color(255));
   render.addDot((new vector(140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(104,-80,0).vMRot(r).vPlus(p)),8,color(255)); 
   render.addDot((new vector(32,128,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(64,216,0).vMRot(r).vPlus(p)),40,color(255));
   render.addDot((new vector(144,-48,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(104,-80,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-144,-48,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(-140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-104,-80,0).vMRot(r).vPlus(p)),8,color(255));
   }*/
}

float sin30 = sin(PI/6);
float cos30=cos(PI/6);
public vector hexCoord(vector p,float r){
  int x = floor(p.x());
  int y = floor(p.y());
  int z = floor(p.z());
  return new vector((x+z*cos30)*r,y*r,z*sin30+r);
}
public void pCell(vector p,float r){
  vector nP=new vector(p.x(),p.y(),p.z());
  for(float i = -1; i < 2; i++){
     for(float j=-1; j < 2; j+=2){
       nP=new vector(p.x()+i/2,p.y(),p.z()+j/2);
       render.addPoint(hexCoord(nP,r));
     }
  }
}

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
  emiter(float d1,float d2,float s1,float s2,float tr1,float tr2,int c1,int c2,int init, int fin){
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
  public sprite[] upDate(){
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
  int c;
  float xv=0;
  float yv=0;
  float r = 0;
  PImage img;
  boolean hasImg=false;
  sprite(){
    hasImg=false;
  }
  sprite(float x1, float y1, float xv1, float yv1,float r1,int c1){
    c=c1;
    x=x1;
    y=y1;
    xv=xv1;
    yv=yv1;
    r=r1;
    hasImg=false;
  }
  sprite(float x1, float y1, float xv1, float yv1,float r1,int c1, PImage img1){
    c=c1;
    x=x1;
    y=y1;
    xv=xv1;
    yv=yv1;
    img = img1;
    r=r1;
    hasImg=true;
  }
  public void upDate(){
    x+=xv;
    y+=yv; 
  }
  public void draw(vector p){
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

class vector{
  float x=0;
  float y=0;
  float z=0;
  M4 M = new M4();
  vector(){
  }
  vector(float x1,float y1, float z1){
    x=x1;
    y=y1;
    z=z1; 
  }
  public void normalize(){
    float fMag = mag(x,y,z);
    x/=fMag;
    y/=fMag;
    z/=fMag; 
  }
  public vector vNormalize(){
    vector tVector = new vector(x,y,z);
    tVector.normalize();
    return tVector;
  }
  public float vMag(){
    return mag(x,y,z); 
  }
  public float x(){
    return x;
  }
  public float y(){
    return y;
  }
  public float z(){
    return z;
  }
  public void x(float x1){
    x=x1;
  }
  public void y(float y1){
    y=y1;
  }
  public void z(float z1){
    z=z1;
  }
  public vector vPlus(vector v2){
    vector v3 = new vector();
    v3.x(x+v2.x());
    v3.y(y+v2.y());
    v3.z(z+v2.z());
    return v3;
  }
  public vector vMinus(vector v2){
    vector v3 = new vector();
    v3.x(x-v2.x());
    v3.y(y-v2.y());
    v3.z(z-v2.z());
    return v3;
  }
  public vector vTimes(float k){
    return new vector(x*k,y*k,z*k); 
  }
  public float vDot(vector v2){
    return x*v2.x()+y*v2.y()+z*v2.z(); 
  }
  public vector vCross(vector v2){
    vector v3=new vector(y*v2.z()-z*v2.y(), z*v2.x()-x*v2.z(),x*v2.y()-y*v2.x());
    return v3;
  }
  public vector vRot(float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M=new M4();
    fTemp[0]=x;
    fTemp[1]=y;
    fTemp[2]=z;
    M.MRot(xr,0,0);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    M.MRot(0,yr,0);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    M.MRot(0,0,zr);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    vTemp.x(fTemp[0]);
    vTemp.y(fTemp[1]);
    vTemp.z(fTemp[2]);
    return vTemp;
  }
  public vector vMRot(float xr, float yr,float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M = new M4();
    M.MRot(xr,yr,zr);
    fTemp = M.MMulti(x,y,z);
    vTemp.x(fTemp[0]);
    vTemp.y(fTemp[1]);
    vTemp.z(fTemp[2]);
    return vTemp;
  }
  public vector vMRot(vector v2){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M.MRot(v2.x(),v2.y(),v2.z());
    fTemp = M.MMulti(x,y,z);
    return new vector(fTemp[0],fTemp[1],fTemp[2]);
  }
  public vector vMRot(M4 M1){
    float[] fTemp = M1.MMulti(x,y,z);
    return new vector(fTemp[0],fTemp[1],fTemp[2]);
  }
  public vector vRot(float xc, float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vMRot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  public vector vRotAbout(vector v1, float theta){
    vector v2 = new vector(x,y,z);
    v2=v2.vAlign(v1);
    v2=v2.vMRot(theta,0,0);
    return v2.vUnalign(v1); 
  }
  public vector vRotAbout(vector v1){
    vector v2 = new vector(x,y,z);
    v2=v2.vAlign(v1);
    v2=v2.vMRot(v1.vMag(),0,0);
    return v2.vUnalign(v1); 
  }
  public vector vUnrot(float xr,float yr, float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M=new M4();
    fTemp[0]=x;
    fTemp[1]=y;
    fTemp[2]=z;
    M.MRot(0,0,zr);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    M.MRot(0,yr,0);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    M.MRot(xr,0,0);
    fTemp=M.MMulti(fTemp[0],fTemp[1],fTemp[2]);
    vTemp.x(fTemp[0]);
    vTemp.y(fTemp[1]);
    vTemp.z(fTemp[2]);
    return vTemp;
  }
  public vector vUnrot(float xc,float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vUnrot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  public vector vAlong(vector v2){
    vector v1 = new vector(x,y,z);
    if(v2.vMag()!=0&&v1.vMag()!=0){
      return v2.vTimes(v1.vDot(v2)/(sq(v2.vMag())*v1.vMag()));
    }
    return new vector();
  }
  public float vMagAlong(vector v2){
    vector v1 = new vector(x,y,z);
    return v2.vDot(v1)/(v2.vMag());
  }
  public vector vAlign(vector v2){
    float xr,yr,zr;
    xr=yr=zr=0;
    vector v3 = new vector(x,y,z);
    if(v2.x()!=0){
      yr = atan(v2.z()/v2.x());
      if(v2.z<0&&abs(yr)<PI/2){
        yr=PI-yr;
      }
    }
    else{
      if(v2.z()>0)
        yr=PI/2;
      if(v2.x()<0)
        yr=-PI/2; 
    }
    if(v2.x()!=0){
      zr = atan(v2.y()/mag(v2.x(),v2.z()));
      if(v2.y<0&&abs(zr)<PI/2){
        zr=PI-zr; 
      }
    }
    else{
      if(v2.y()>0)          
        zr=PI/2;
      if(v2.y()<0)           
        zr=-PI/2;  
    }
    println(str(xr)+' '+str(yr)+' '+str(zr));
    return v3.vRot(xr,yr,zr);
  }
  public vector vUnalign(vector v2){
    float xr,yr,zr;
    xr=yr=zr=0;
    vector v3 = new vector(x,y,z);
    if(v2.z()!=0){
      xr = atan(v2.y()/v2.z());
      if(v2.y<0&&abs(yr)<PI/2){
        xr=PI-xr; 
      }
    }
    else{
      if(v2.y()>0)
        xr=PI/2;
      if(v2.y()<0)
        xr=-PI/2; 
    }
    if(v2.x()!=0){
      yr = atan(mag(v2.y(),v2.z())/v2.x());
      if(v2.x<0&&abs(yr)<PI/2){
        yr=PI-yr; 
      }
    }
    else{
      if(v2.z()>0)          
        yr=PI/2;
      if(v2.z()<0)           
        yr=-PI/2;  
    }
    return v3.vUnrot(-xr,-yr,-zr);
  }
  public void vPrint(){
    println(str(x)+' '+str(y)+' '+str(z)); 
  }
  public vector vReflect(vector v2){
    vector v3 = new vector(x,y,z);
    float a;
    float r1,r2,theta,phi;
    r1=atan2(v3.z(),v3.x());
    r2=atan2(v2.z(),v2.x());
    theta=r2+(r2-r1);
    r1=atan2(v3.y(),mag(v3.z(),v3.x()));
    r2=atan2(v2.y(),mag(v2.z(),v2.x()));
    phi=r2+(r2-r1);
    a=v3.vMag();
    vector vResult=new vector();
    vResult.x(cos(theta)*cos(phi)*a);
    vResult.y(sin(phi)*a);
    vResult.z(sin(theta)*cos(phi)*a);
    return vResult;
  }
}
class M4{
  float mat[] = new float[16];
  M4(){
    for(int j = 0; j < 4; j++){
      for(int i = 0; i < 16; i += 4){
        if(i/4 == j){
          mat[i+j]=1;
        }
        else{
          mat[i+j]=0;
        }
      } 
    }
  }
  M4(float angle_x,float angle_y,float angle_z){
    float A       = cos(angle_x);
    float B       = sin(angle_x);
    float C       = cos(angle_y);
    float D       = sin(angle_y);
    float E       = cos(angle_z);
    float F       = sin(angle_z);

    float AD      =   A * D;
    float BD      =   B * D;

    mat[0]  =   C * E;
    mat[1]  =  -C * F;
    mat[2]  =  -D;
    mat[4]  = -BD * E + A * F;
    mat[5]  =  BD * F + A * E;
    mat[6]  =  -B * C;
    mat[8]  =  AD * E + B * F;
    mat[9]  = -AD * F + B * E;
    mat[10] =   A * C;

    mat[3]  =  mat[7] = mat[11] = mat[12] = mat[13] = mat[14] = 0;
    mat[15] =  1;
  }
  M4(vector v){
    float A       = cos(v.x());
    float B       = sin(v.x());
    float C       = cos(v.y());
    float D       = sin(v.y());
    float E       = cos(v.z());
    float F       = sin(v.z());

    float AD      =   A * D;
    float BD      =   B * D;

    mat[0]  =   C * E;
    mat[1]  =  -C * F;
    mat[2]  =  -D;
    mat[4]  = -BD * E + A * F;
    mat[5]  =  BD * F + A * E;
    mat[6]  =  -B * C;
    mat[8]  =  AD * E + B * F;
    mat[9]  = -AD * F + B * E;
    mat[10] =   A * C;

    mat[3]  =  mat[7] = mat[11] = mat[12] = mat[13] = mat[14] = 0;
    mat[15] =  1;
  }
  M4(vector v, float W){
    float X,Y,Z;
    X=v.x();
    Y=v.y();
    Z=v.z();
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z; 
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
  }
  public void QUAT(vector v, float W){
    float X,Y,Z;
    X=v.x();
    Y=v.y();
    Z=v.z();
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z;
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
  }
  public void QUAT(QUAT Q){
    float X,Y,Z,W;
    X=Q.v.x();
    Y=Q.v.y();
    Z=Q.v.z();
    W=Q.w;
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z;
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
  }
  public float[] MDerot(){
    float tx,ty,angle_x,angle_y,angle_z=0;
    float D;
    angle_y = D = -asin( mat[2]);        /* Calculate Y-axis angle */
    float C           =  cos( angle_y );

    if ( abs( C ) > 0.005f )             /* Gimball lock? */
    {
      tx      =  mat[10] / C;           /* No, so get X-axis angle */
      ty      = -mat[6]  / C;
      angle_x  = atan2( ty, tx );
      tx      =  mat[0] / C;            /* Get Z-axis angle */
      ty      = -mat[1] / C;
      angle_z  = atan2( ty, tx );
    }
    else                                 /* Gimball lock has occurred */
    {
      angle_x  = 0;                      /* Set X-axis angle to zero */
      tx      = mat[5];                 /* And calculate Z-axis angle */
      ty      = mat[4];
      angle_z  = atan2( ty, tx );
    }
    //angle_x = constrain( angle_x, -TWO_PI, TWO_PI );  /* constrain all angles to range */
    //angle_y = constrain( angle_y, -TWO_PI, TWO_PI );
    // angle_z = constrain( angle_z, -TWO_PI, TWO_PI ); 
    float[] fAngle = new float[3];
    fAngle[0] = limit(angle_x);
    fAngle[1]=limit(angle_y);
    fAngle[2] = limit(angle_z);
    return fAngle;
  }
  public void MTrans(){
    M4 m2=new M4();
    for(int i = 0; i < 16; i++){
      m2.mat[i] = mat[i]; 
    }
    for(int i = 0; i<4; i++){
      for(int j = 0; j < 4; j++){ 
        m2.mat[(i*4)+j]=mat[(j*4)+i];
      }
    }
    for(int i = 0; i < 16; i++){
      mat[i] = m2.mat[i]; 
    }
  }
  public void MRot(float angle_x,float angle_y,float angle_z){
    float A       = cos(angle_x);
    float B       = sin(angle_x);
    float C       = cos(angle_y);
    float D       = sin(angle_y);
    float E       = cos(angle_z);
    float F       = sin(angle_z);

    float AD      =   A * D;
    float BD      =   B * D;

    mat[0]  =   C * E;
    mat[1]  =  -C * F;
    mat[2]  =  -D;
    mat[4]  = -BD * E + A * F;
    mat[5]  =  BD * F + A * E;
    mat[6]  =  -B * C;
    mat[8]  =  AD * E + B * F;
    mat[9]  = -AD * F + B * E;
    mat[10] =   A * C;

    mat[3]  =  mat[7] = mat[11] = mat[12] = mat[13] = mat[14] = 0;
    mat[15] =  1;
  }
  public float[] MMulti(float x,float y,float z){
    float[] mat2 = new float[4];
    mat2[0] = mat[0]*x+mat[1]*y+mat[2]*z;
    mat2[1] = mat[4]*x+mat[5]*y+mat[6]*z;
    mat2[2] = mat[8]*x+mat[9]*y+mat[10]*z;
    return mat2;
  }
}

public float[] trans(float x,float y,float z,float xt,float yt,float zt,float xr,float yr,float zr){
  M4 m = new M4();
  m.MRot(xr,yr,zr);
  float[] pos = new float[4];
  pos = m.MMulti(x,y,z);
  pos[0]+=xt;
  pos[1]+=yt;
  pos[2]+=zt;
  return pos;
}
public float[] trans(float x,float y,float z,float xr,float yr,float zr){
  M4 m = new M4();
  m.MRot(xr,yr,zr);
  float[] pos = new float[4];
  pos = m.MMulti(x,y,z);

  return pos;
}

public M4 MMulti(M4 m1, M4 m2){
  M4 m = new M4();
  for(int j = 0; j < 3; j++){
    for(int i = 0; i < 3; i++){
      m.mat[(i*4)+j]=(m1.mat[(i*4)+0]*m2.mat[(0*4)+j])+(m1.mat[(i*4)+1]*m2.mat[(1*4)+j])+(m1.mat[(i*4)+2]*m2.mat[(2*4)+j]);
    }
  }
  return m;
}

boolean[] keysPressed = new boolean[256];
boolean[] keysTapped = new boolean [256];
boolean[] pKeysPressed = new boolean[256];
float[] column = new float[2];
char[] type = new char[50];

public void drawColumn(float x, float y, float xm, float ym){
  rectMode(CENTER);
  ellipseMode(CENTER);
  stroke(0);
  noFill();
  rect(x,y,xm,ym);
  rect(x, y, xm/8, ym);
  rect(x, y, xm, ym/8);
  fill(255,200,0);
  ellipse(column[0]*(2*width/PI)*(xm/width)+x, column[1]*(2*height/PI)*(ym/height)+y, xm/8,ym/8);
}
public void columnUpdate(){
  column[0] = (mouseX-width/2)*(PI/(2*width));
  column[1] = (mouseY-height/2)*(PI/(2*width)); 
  if(abs(column[0])<PI/32){
    column[0]=0;
  }
  if(abs(column[1])<PI/32){
    column[1]=0;
  }
}
public void keyPressed() {
  if(ascii(key)==8&&type.length>0){
    type = subset(type,0,type.length-2); 
  }
  if(ascii(key)>=32){
    type = append(type, key); 
  }
  if(!(ascii(key) == -1)){
    keysPressed[ascii(key)] = true;
  }
  else{
    keysPressed[keyCode] = true;
  }
} 

public void keyReleased() { 
  if(!(ascii(key) == -1)){
    keysPressed[ascii(key)] = false;
  }
  else{
    keysPressed[keyCode] = false; 
  }
} 

public int ascii(char Char){
  for(int i = 0; i < 128; i++){
    if(Char == PApplet.parseChar(i)){
      return i;
    }
  }
  return -1;
}


public int find(String[] file,String code,int pos){
  String[] splitData = new String[0];
  for(int i = 0; i < file.length; i++){
    splitData = split(file[i],' ');
    if(splitData.length>pos){
      if (splitData[pos].equals(code)){
        return(i);
      }
    }
  }
  return(-1);  
}

public int find(String[] file,String code,int pos,int after){
  String[] splitData;
  if(after<file.length){
    for(int i = after; i < file.length; i++){
      splitData = split(file[i],' ');
      if(splitData.length>pos){
        if (splitData[pos].equals(code)){
          return(i);
        }
      }
    }
  }
  return(-1);  
}
int pressedX,pressedY = 0;
public void mousePressed(){
  pressedX = mouseX;
  pressedY = mouseY;
}
public float limit(float theta){
  while(theta>PI){
    theta-=TWO_PI;
  } 
  while(theta<=-PI){
    theta+=TWO_PI; 
  }
  return theta;
}
public void tap(){
  for(int i = 0; i < 128; i++){
    if(keysPressed[i] == true&&pKeysPressed[i]==false){
      keysTapped[i]=true;
    } 
    else{
      keysTapped[i] = false; 
    }
  }
  for(int i = 0; i < 128; i++){
    pKeysPressed[i] = keysPressed[i]; 
  }
}
class control{
  boolean[] bKeys;
  String sKeys;
  control(String sInput){
    sKeys = sInput;
    bKeys = new boolean[sKeys.length()]; 
  }
  public void upDate(){
    for(int i = 0; i < bKeys.length; i++){
      bKeys[i] = keysPressed[ascii(sKeys.charAt(i))];
    } 
  }
  public boolean test(String sInput){
    boolean aBool = true;
    boolean[] bBool = new boolean[bKeys.length];
    for(int i = 0; i < bBool.length; i++){
      bBool[i] = false; 
    }
    for(int i = 0; i < sKeys.length(); i++){
      for(int j = 0; j < sInput.length(); j++){
        if(sKeys.charAt(i)==sInput.charAt(j)){
          bBool[i] = true; 
        }
      }
    }
    for(int i = 0; i < bKeys.length; i++){
      if(bBool[i] !=bKeys[i]){
        aBool = false; 
      }
    }
    return aBool;
  }
}
class iDet{
  M4 M = new M4();
  float[] axes;
  float[][] verts;
  float[] vector1;
  float[][] vector2;
  float[][] result2;
  float[] tVector;
  vector vc,v0,vf,vMove,vWalls;
  float m,m1,m2,m3,b,b1,b2,b3,tx,ty,tz,a1,c1;
  iDet(){
  }
  public boolean circleLine(float x, float y, float r, float x1, float y1, float x2, float y2){
    m = (y2-y1)/(x2-x1);
    b = -(m*x2)+y2;
    a1 = (sq(m)+1);
    b1 = (2*((m*(x1-m*y1-y))-x));
    c1 = (sq(x1-m*y1-y)+sq(x)-sq(r));
    if(sq(b1)-4*a1*c1>0){
      return true; 
    }
    return false;
  }
  public boolean sphereLine(float x, float y, float z, float r, float x1, float y1, float z1, float x2, float y2, float z2){
    if(circleLine(x,y,r,x1,y1,x2,y2)&&circleLine(x,z,r,x1,z1,x2,z2)&&circleLine(y,z,r,y1,z1,y2,z2)){
      return true;
    } 
    return false;
  }

  public boolean triPoint(float x,float y, float x1,float y1,float x2,float y2,float x3,float y3){
    verts= new float[3][2];
    boolean impact = false;
    verts[0][0] = x1;
    verts[0][1] = y1;
    verts[1][0] = x2;
    verts[1][1] = y2;
    verts[2][0] = x3;
    verts[2][1] = y3;
    int left=-1;
    int top=-1;
    int bottom=-1;
    for(int i = 0; i < 3; i++){
      if(left==-1){
        left = i; 
      }
      else{
        if(verts[i][0]<verts[left][0]){
          left = i;
        } 
      }
    }
    for(int i = 0; i < 3; i++){
      if(i!=left){
        if(top==-1){
          top = i; 
        }
        else{
          if(verts[i][0]<verts[top][1]){
            top = i;
          } 
        }
      }
    }
    for(int i = 0; i < 3; i++){
      if(i!=left&&i!=top){
        bottom = i;
      }
    }
    m1 = (verts[left][1]-verts[top][1])/(verts[left][0]-verts[top][0]);
    b1 = -(m1*verts[top][0])+verts[top][1];
    m2 = (verts[left][1]-verts[bottom][1])/(verts[left][0]-verts[bottom][0]);
    b2 = -(m2*verts[bottom][0])+verts[bottom][1];
    m3 = (verts[top][1]-verts[bottom][1])/(verts[top][0]-verts[bottom][0]);
    b3 = -(m3*verts[bottom][0])+verts[bottom][1];
    boolean bImpact = false;
    if(m1<m2){
      if(m1*x+b1<=y&&m2*x+b2>=y){
        bImpact = true;
      }
    }
    if(m1>m2){
      if(m1*x+b1>=y&&m2*x+b2<=y){
        bImpact = true;
      }
    }
    if(bImpact){
      if(verts[top][0]<verts[bottom][0]){
        if(m3*x+b3<=y){
          impact = true; 
        }
      }
      else{
        if(verts[top][0]>verts[bottom][0]){
          if(m3*x+b3>=y){
            impact = true; 
          }
        }
        else{
          impact = true; 
        }
      }
    }
    return impact;
  }
  public boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt){
    if(x<x1+xExt/2&&x>x1-xExt/2&&y<y1+yExt/2&&y>y1-yExt/2){
      return true; 
    }
    return false;
  }
  public boolean rectLine(float x1, float y1, float x2, float y2, float xc, float yc, float xExt, float yExt){
    boolean intersect = false;
    float temp;
    if(x1>x2){
      temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }
    m = (y1-y2)/(x1-x2);
    b = -(m*x1)+y1;
    m1 = (x1-x2)/(y1-y2);
    b1 = -(m1*y1)+x1;
    stroke(0);
    line(0,m*0+b,width,m*width+b);
    line(m1*0+b1,0,m1*height+b1,height);
    if(((xc+xExt/2)*m+b<yc+yExt/2&&(xc+xExt/2)*m+b>yc-yExt/2)||((xc-xExt/2)*m+b<yc+yExt/2&&(xc-xExt/2)*m+b>yc-yExt/2)){
      intersect =  true;
    }
    if(((yc+yExt/2)*m1+b1<xc+xExt/2&&(yc+yExt/2)*m1+b1>xc-xExt/2)||((yc-yExt/2)*m1+b1<xc+xExt/2&&(yc-yExt/2)*m1+b1>xc-xExt/2)){
      intersect = true;
    }
    return intersect;
  }
  public boolean rectSeg(float x1, float y1, float x2, float y2, float xc, float yc, float xExt, float yExt){
    boolean intersect = false;
    float temp;
    if(x1>x2){
      temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }
    m = (y1-y2)/(x1-x2);
    b = -(m*x1)+y1;
    m1 = (x1-x2)/(y1-y2);
    b1 = -(m1*y1)+x1;
    if(((xc+xExt/2)*m+b<yc+yExt/2&&(xc+xExt/2)*m+b>yc-yExt/2)||((xc-xExt/2)*m+b<yc+yExt/2&&(xc-xExt/2)*m+b>yc-yExt/2)){
      intersect =  true;
    }
    if(((yc+yExt/2)*m1+b1<xc+xExt/2&&(yc+yExt/2)*m1+b1>xc-xExt/2)||((yc-yExt/2)*m1+b1<xc+xExt/2&&(yc-yExt/2)*m1+b1>xc-xExt/2)){
      intersect = true;
    }
    if(x1>xc+xExt/2||x2<xc-xExt/2){
      intersect = false; 
    }
    if(y1<y2){
      if(y1>yc+yExt/2||y2<yc-yExt/2){
        intersect = false;
      }
    }
    else{
      if(y2>yc+yExt/2||y1<yc-yExt/2){
        intersect = false;
      } 
    }
    return intersect;
  }
  public boolean cubeSeg(float x1,float y1,float z1,float x2,float y2,float z2,float xc,float yc,float zc,float xExt,float yExt,float zExt,float xr,float yr,float zr){
    boolean intersect=false;
    M.MRot(xr,yr,zr);
    vector1 = M.MMulti(x1-xc,y1-yc,z1-zc);
    x1 = vector1[0];
    y1 = vector1[1];
    z1 = vector1[2];
    vector1 = M.MMulti(x2-xc,y2-yc,z2-zc);
    x2 = vector1[0];
    y2 = vector1[1];
    z2 = vector1[2];
    if(rectSeg(x1,y1,x2,y2,0,0,xExt,yExt)&&rectSeg(x1,z1,x2,z2,0,0,xExt,zExt)&&rectSeg(z1,y1,z2,y2,0,0,zExt,yExt)){
      intersect = true;
    }
    return intersect;
  }
  public boolean cubeCube(float x1,float y1,float z1,float xr1,float yr1,float zr1,float xExt1,float yExt1,float zExt1,
  float x2,float y2,float z2,float xr2,float yr2,float zr2,float xExt2,float yExt2,float zExt2){
    M.MRot(-xr1,-yr1,-zr1);
    //y/z, +x plane, cube 1.
    vector1 = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //y/z, -x plane, cube 1.
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //connectors, cube 1
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //cube 2
    M.MRot(-xr2,-yr2,-zr2);
    //y/z, +x plane, cube 1.
    vector1 = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    //y/z, -x plane, cube 1.
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    //connectors, cube 1
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt2,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5f,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    return false;
  }
  public boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt,float r){
    M.MRot(0,0,-r);
    float[] vector;
    vector = M.MMulti(x-x1,y-y1,0);
    vector[0]+=x1;
    vector[1]+=y1;
    if(vector[0]<x1+xExt/2&&vector[0]>x1-xExt/2&&vector[1]<y1+yExt/2&&vector[1]>y1-yExt/2){
      return true; 
    }
    return false;
  }
  public boolean cubePoint(float x, float y, float z, float x1,float y1, float z1, float xExt,float yExt,float zExt){
    if(x<x1+xExt/2&&x>x1-xExt/2&&y<y1+yExt/2&&y>y1-yExt/2&&z<z1+zExt/2&&z>y1-zExt/2){
      return true; 
    }
    return false;
  }
  public boolean cubePoint(float x, float y, float z, float x1,float y1, float z1, float xExt,float yExt,float zExt,float xr,float yr, float zr){
    M.MRot(-xr,-yr,-zr);
    float[] vector;
    vector = M.MMulti(x-x1,y-y1,z-z1);
    vector[0]+=x1;
    vector[1]+=y1;
    vector[2]+=z1;
    if(vector[0]<x1+xExt/2&&vector[0]>x1-xExt/2&&vector[1]<y1+yExt/2&&vector[1]>y1-yExt/2&&vector[2]<z1+zExt/2&&vector[2]>y1-zExt/2){
      return true; 
    }
    return false;
  }
  public boolean rectCircle(float x,float y,float r,float x1,float y1,float xExt, float yExt){
    if((x<x1+xExt/2+r&&x>x1-xExt/2-r&&y<y1+yExt/2&&y>y1-yExt/2)||(x<x1+xExt/2&&x>x1-xExt/2&&y<y1+yExt/2+r&&y>y1-yExt/2-r)){
      return true;
    }
    else{
      if(sq(x-(x1+xExt/2))+sq(y-(y1+yExt/2))<sq(r)){
        return true; 
      }
      if(sq(x1-(x-xExt/2))+sq(y1-(y+yExt/2))<sq(r)){
        return true; 
      }
      if( sq(x-(x1-xExt/2))+sq(y-(y1-yExt/2))<sq(r)){
        return true; 
      }
      if(sq(x-(x1+xExt/2))+sq(y-(y1-yExt/2))<sq(r)){
        return true; 
      }
    }
    return false;
  }
  public float[] vRectCircle(float x, float y, float r, float x1, float y1, float xExt, float yExt){
    float[] vector=new float[2];
    if(rectCircle(x,y,r,x1,y1,xExt,yExt)){
      if(x>x1+xExt/2&&x<x1+xExt/2+r){
        vector[0]=x-x1-xExt/2;
      }
      if(x>x1-xExt/2-r&&x<x1-xExt/2){
        vector[0]=x-x1+xExt/2; 
      }
      if(y>y1+yExt/2&&y<y1+yExt/2+r){
        vector[1]=y-y1-yExt/2;
      }
      if(y>y1-yExt/2-r&&y<y1-yExt/2){
        vector[1]=y-y1+yExt/2; 
      }
    }
    return vector;
  }
  public float[] nRectCircle(float x, float y, float r, float x1, float y1, float xExt, float yExt){
    float[] vector=new float[2];
    if(rectCircle(x,y,r,x1,y1,xExt,yExt)){
      if(x>x1+xExt/2){
        vector[0]=x-x1-xExt/2;
      }
      if(x<x1-xExt/2){
        vector[0]=x-x1+xExt/2; 
      }
      if(y>y1+yExt/2){
        vector[1]=y-y1-yExt/2;
      }
      if(y<y1-yExt/2){
        vector[1]=y-y1+yExt/2; 
      }
    }
    float vMag = mag(vector[0],vector[1]);
    vector[0]/=vMag;
    vector[1]/=vMag;
    return vector;
  }
  public float[] vCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
    vector1 = new float[3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
        //y-axis
        if(ty<0&&ty<-yExt/2+(tx+xExt/2)&&ty<-yExt/2-(tx-xExt/2)&&ty<-yExt/2+(tz+zExt/2)&&ty<-yExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=-1;
          axes[2]=0; 
        }
        if(ty>0&&ty>yExt/2-(tx+xExt/2)&&ty>yExt/2+(tx-xExt/2)&&ty>yExt/2-(tz+zExt/2)&&ty>yExt/2+(tz-zExt/2)){
          axes[0]=0;
          axes[1]=1;
          axes[2]=0; 
        }
        //x-axis
        if(tx<0&&tx<-xExt/2+(ty+yExt/2)&&tx<-xExt/2-(ty-yExt/2)&&tx<-xExt/2+(tz+zExt/2)&&tx<-xExt/2-(tz-zExt/2)){
          axes[0]=-1;
          axes[1]=0;
          axes[2]=0; 
        }
        if(tx>0&&tx>xExt/2-(ty+yExt/2)&&tx>xExt/2+(ty-yExt/2)&&tx>xExt/2-(tz+zExt/2)&&tx>xExt/2+(tz-zExt/2)){
          axes[0]=1;
          axes[1]=0;
          axes[2]=0; 
        }
        //z-axis
        if(tz<0&&tz<-zExt/2+(tx+xExt/2)&&tz<-zExt/2-(tx-xExt/2)&&tz<-zExt/2+(tz+zExt/2)&&tz<-zExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=-1; 
        }
        if(tz>0&&tz>zExt/2-(tx+xExt/2)&&tz>zExt/2+(tx-xExt/2)&&tz>zExt/2-(ty+yExt/2)&&tz>zExt/2+(ty-yExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=1; 
        }
        vector1=axes;
      }
    }

    return vector1;
  }

  public float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
    vector1 = new float[3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
        //y-axis
        if(ty<0&&ty<-yExt/2+(tx+xExt/2)&&ty<-yExt/2-(tx-xExt/2)&&ty<-yExt/2+(tz+zExt/2)&&ty<-yExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=-1;
          axes[2]=0; 
        }
        if(ty>0&&ty>yExt/2-(tx+xExt/2)&&ty>yExt/2+(tx-xExt/2)&&ty>yExt/2-(tz+zExt/2)&&ty>yExt/2+(tz-zExt/2)){
          axes[0]=0;
          axes[1]=1;
          axes[2]=0; 
        }
        //x-axis
        if(tx<0&&tx<-xExt/2+(ty+yExt/2)&&tx<-xExt/2-(ty-yExt/2)&&tx<-xExt/2+(tz+zExt/2)&&tx<-xExt/2-(tz-zExt/2)){
          axes[0]=-1;
          axes[1]=0;
          axes[2]=0; 
        }
        if(tx>0&&tx>xExt/2-(ty+yExt/2)&&tx>xExt/2+(ty-yExt/2)&&tx>xExt/2-(tz+zExt/2)&&tx>xExt/2+(tz-zExt/2)){
          axes[0]=1;
          axes[1]=0;
          axes[2]=0; 
        }
        //z-axis
        if(tz<0&&tz<-zExt/2+(tx+xExt/2)&&tz<-zExt/2-(tx-xExt/2)&&tz<-zExt/2+(tz+zExt/2)&&tz<-zExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=-1; 
        }
        if(tz>0&&tz>zExt/2-(tx+xExt/2)&&tz>zExt/2+(tx-xExt/2)&&tz>zExt/2-(ty+yExt/2)&&tz>zExt/2+(ty-yExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=1; 
        }
        vector1=axes;
      }
    }
    float vMag = mag(vector1[0],vector1[1],vector1[2]);
    vector1[0]/=vMag;
    vector1[1]/=vMag;
    vector1[2]/=vMag;
    return vector1;
  }

  public float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
    vector1 = new float[3];
    result2 = new float[2][3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
        //y-axis
        if(ty<0&&ty<-yExt/2+(tx+xExt/2)&&ty<-yExt/2-(tx-xExt/2)&&ty<-yExt/2+(tz+zExt/2)&&ty<-yExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=-1;
          axes[2]=0; 
        }
        if(ty>0&&ty>yExt/2-(tx+xExt/2)&&ty>yExt/2+(tx-xExt/2)&&ty>yExt/2-(tz+zExt/2)&&ty>yExt/2+(tz-zExt/2)){
          axes[0]=0;
          axes[1]=1;
          axes[2]=0; 
        }
        //x-axis
        if(tx<0&&tx<-xExt/2+(ty+yExt/2)&&tx<-xExt/2-(ty-yExt/2)&&tx<-xExt/2+(tz+zExt/2)&&tx<-xExt/2-(tz-zExt/2)){
          axes[0]=-1;
          axes[1]=0;
          axes[2]=0; 
        }
        if(tx>0&&tx>xExt/2-(ty+yExt/2)&&tx>xExt/2+(ty-yExt/2)&&tx>xExt/2-(tz+zExt/2)&&tx>xExt/2+(tz-zExt/2)){
          axes[0]=1;
          axes[1]=0;
          axes[2]=0; 
        }
        //z-axis
        if(tz<0&&tz<-zExt/2+(tx+xExt/2)&&tz<-zExt/2-(tx-xExt/2)&&tz<-zExt/2+(tz+zExt/2)&&tz<-zExt/2-(tz-zExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=-1; 
        }
        if(tz>0&&tz>zExt/2-(tx+xExt/2)&&tz>zExt/2+(tx-xExt/2)&&tz>zExt/2-(ty+yExt/2)&&tz>zExt/2+(ty-yExt/2)){
          axes[0]=0;
          axes[1]=0;
          axes[2]=1; 
        }
        result2[1][0]= x1+(axes[0]*(xExt+r));
        result2[1][1]= y1+(axes[1]*(yExt+r));
        result2[1][2]= z1+(axes[2]*(zExt+r));
        vector1=axes;
      }
    }
    float vMag = mag(vector1[0],vector1[1],vector1[2]);
    vector1[0]/=vMag;
    vector1[1]/=vMag;
    vector1[2]/=vMag;
    result2[0]=vector1;
    return result2;
  }
  public float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
    M4 M = new M4();
    M4 unM=new M4();
    M.MRot(-xr,-yr,-zr);
    unM.MRot(xr,yr,zr);
    float[] tv=M.MMulti(x-x1,y-y1,z-z1);
    vector1 = nCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
    vector1 = unM.MMulti(vector1[0],vector1[1],vector1[2]);
    return vector1;
  }
  public float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
    M4 M = new M4();
    M4 unM=new M4();
    M.MRot(-xr,-yr,-zr);
    unM.MRot(xr,yr,zr);
    float[] tv=M.MMulti(x-x1,y-y1,z-z1);
    vector2 = dCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
    vector2[0] = unM.MMulti(vector2[0][0],vector2[0][1],vector2[0][2]);
    vector2[1]= unM.MMulti(vector2[1][0],vector2[1][1],vector2[1][2]);
    return vector2;
  }

  public boolean cubeSphere(float x,float y,float z,float r,float x1,float y1,float z1,float xExt,float yExt,float zExt){
    if(dist(x,y,z,x1,y1,z1)<=mag(xExt/2+r,yExt/2+r,zExt/2+r)){
      if(rectCircle(x,y,r,x1,y1,xExt,yExt)&&rectCircle(x,z,r,x1,z1,xExt,zExt)&&rectCircle(y,z,r,y1,z1,yExt,zExt)){
        return true;
      }
    }
    return false;
  }
  public boolean cubeSphere(float x,float y,float z,float r,float x1,float y1,float z1,float xExt,float yExt,float zExt,float xr,float yr,float zr){
    if(dist(x,y,z,x1,y1,z1)<=mag(xExt/2,yExt/2,zExt/2)){
      M4 M = new M4();
      M.MRot(-xr,-yr,-zr);
      vector1 = M.MMulti(x-x1,y-y1,z-z1);
      if(rectCircle(vector1[0],vector1[1],r,0,0,xExt,yExt)&&rectCircle(vector1[0],vector1[2],r,0,0,xExt,zExt)&&rectCircle(vector1[1],vector1[2],r,0,0,yExt,zExt)){
        return true;
      }
    }
    return false;
  }
  public float[] linearSolver(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4){
    float[] answer=new float[2];
    m1 = (y1-y2)/(x1-x2);
    m2 = (y3-y4)/(x3-x4);
    b1 = -(m1*x1)+y1;
    b2 = -(m2*x3)+y3;
    answer[0] = (b2-b1)/(m1-m2);
    answer[1] = m1*answer[0]+b1;
    return answer;
  }
  public float[] linearSolver(float m1, float b1,float m2,float b2){
    float[] answer=new float[2];
    answer[0] = (b2-b1)/(m1-m2);
    answer[1] = m1*answer[0]+b1;
    return answer;
  }
  public float sign(float input){
    return input/abs(input);  
  }
  public vector cubeSeg(float x0,float y0,float z0,float xf,float yf,float zf,float xc,float yc,float zc,float xExt,float yExt,float zExt){
    vector vPoint = new vector();
    vector vc = new vector(xc,yc,zc);
    vector v0 = new vector(x0-xc,y0-yc,z0-zc);
    vector vf = new vector(xf-xc,yf-yc,zf-zc);
    vector vMove = vf.vMinus(v0);
    vector vWalls = new vector();
    if(v0.x()>xExt/2){
      vWalls.x(xExt/2); 
    }
    if(v0.x()<-xExt/2){
      vWalls.x(-xExt/2); 
    }
    if(v0.y()>yExt/2){
      vWalls.y(yExt/2); 
    }
    if(v0.y()<-yExt/2){
      vWalls.y(-yExt/2); 
    }
    if(v0.z()>zExt/2){
      vWalls.z(zExt/2); 
    }
    if(v0.z()<-zExt/2){
      vWalls.z(-zExt/2); 
    }
    if(vWalls.x()!=0){
      if(v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))<yExt/2&&v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))>-yExt/2&&
        v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))<zExt/2&&v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))>-zExt/2){
        vPoint.x(vWalls.x());
        vPoint.y( v0.y()-((vMove.y()/vMove.x())*(v0.x()-vWalls.x())));
        vPoint.z(v0.z()-((vMove.z()/vMove.x())*(v0.x()-vWalls.x())));
      }
    }
    if(vWalls.y()!=0){
      if(v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))<xExt/2&&v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))>-xExt/2&&
        v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))<zExt/2&&v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))>-zExt/2){
        vPoint.y(vWalls.y());
        vPoint.x( v0.x()-((vMove.x()/vMove.y())*(v0.y()-vWalls.y())));
        vPoint.z(v0.z()-((vMove.z()/vMove.y())*(v0.y()-vWalls.y())));
      }
    }
    if(vWalls.z()!=0){
      if(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))<yExt/2&&v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))>-yExt/2&&
        v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))<xExt/2&&v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))>-xExt/2){
        vPoint.z(vWalls.z());
        vPoint.y(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z())));
        vPoint.x( v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z())));
      }
    }
    vPoint = vPoint.vPlus(vc);
    return vPoint;
  }

  public vector[] nCubeSeg(float x0,float y0,float z0,float xf,float yf,float zf,float xc,float yc,float zc,float xExt,float yExt,float zExt){
    vector vPoint = new vector();
    vector[] result = new vector[2];
    result[1] = new vector();
    vc = new vector(xc,yc,zc);
    v0 = new vector(x0-xc,y0-yc,z0-zc);
    vf = new vector(xf-xc,yf-yc,zf-zc);
    vMove = vf.vMinus(v0);
    vWalls = new vector();
    if(v0.x()>xExt/2&&vf.x()<xExt/2){
      vWalls.x(xExt/2); 
    }
    if(v0.x()<-xExt/2&&vf.x()>-xExt/2){
      vWalls.x(-xExt/2); 
    }
    if(v0.y()>yExt/2&&vf.y()<yExt/2){
      vWalls.y(yExt/2); 
    }
    if(v0.y()<-yExt/2&&vf.y()>-yExt/2){
      vWalls.y(-yExt/2); 
    }
    if(v0.z()>zExt/2&&vf.z()<zExt/2){
      vWalls.z(zExt/2); 
    }
    if(v0.z()<-zExt/2&&vf.z()>-zExt/2){
      vWalls.z(-zExt/2); 
    }
    if(vWalls.x()!=0){
      if(v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))<yExt/2&&v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))>-yExt/2&&
        v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))<zExt/2&&v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))>-zExt/2){
        vPoint.x(vWalls.x());
        vPoint.y( v0.y()-((vMove.y()/vMove.x())*(v0.x()-vWalls.x())));
        vPoint.z(v0.z()-((vMove.z()/vMove.x())*(v0.x()-vWalls.x())));
        result[1].x(sign(vWalls.x()));
      }
    }
    if(vWalls.y()!=0){
      if(v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))<xExt/2&&v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))>-xExt/2&&
        v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))<zExt/2&&v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))>-zExt/2){
        vPoint.y(vWalls.y());
        vPoint.x( v0.x()-((vMove.x()/vMove.y())*(v0.y()-vWalls.y())));
        vPoint.z(v0.z()-((vMove.z()/vMove.y())*(v0.y()-vWalls.y())));
        result[1].y(sign(vWalls.y()));
      }
    }
    if(vWalls.z()!=0){
      if(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))<yExt/2&&v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))>-yExt/2&&
        v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))<xExt/2&&v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))>-xExt/2){
        vPoint.z(vWalls.z());
        vPoint.y(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z())));
        vPoint.x( v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z())));
        result[1].z(sign(vWalls.z()));
      }
    }
    vPoint = vPoint.vPlus(vc);
    result[0]=vPoint;
    return result;
  }
}
public int sign(float input){
  return PApplet.parseInt(input/abs(input));  
}
class QUAT{
  vector v=new vector(1,1,1);
  float w = 0;
  QUAT(){
    v=new vector(1,1,1);
    v=v.vTimes(sin(0/2));
    w=cos(0/2);
  } 
  QUAT(float x1,float y1,float z1,float theta){
    v=new vector(x1,y1,z1);
    v=v.vTimes(sin(theta/2));
    w=cos(theta/2);
  }
  QUAT(vector v1,float theta){
    v=v1.vTimes(sin(theta/2));
    w=cos(theta/2); 
  }
  QUAT(M4 M){
    float T=M.mat[0]+M.mat[5]+M.mat[10]+1;
    float S,W,X,Y,Z;
    S=W=X=Y=Z=0;
    if(T>0){
      S = 0.5f / sqrt(T);
      W = 0.25f / S;
      X = ( M.mat[9] - M.mat[6] ) * S;
      Y = ( M.mat[2] - M.mat[8] ) * S;
      Z = ( M.mat[4] - M.mat[1] ) * S;
    }
    else{
      int Greatest=0;
      if(M.mat[0]>M.mat[5]&&M.mat[0]>M.mat[10]){
        Greatest=0; 
      }
      if(M.mat[5]>M.mat[0]&&M.mat[5]>M.mat[10]){
        Greatest=1; 
      }
      if(M.mat[10]>M.mat[0]&&M.mat[10]>M.mat[5]){
        Greatest=2; 
      }
      switch(Greatest){
      case 0:
        S  = sqrt( 1.0f + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;

        X = 0.5f / S;
        Y=  (M.mat[1] + M.mat[4] ) / S;
        Z =  (M.mat[2] + M.mat[8] ) / S;
        W =  (M.mat[6] + M.mat[9] ) / S;
        break;
      case 1:
        S  = sqrt( 1.0f + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;


        X=  (M.mat[1] + M.mat[4] ) / S;
        Y = 0.5f / S;
        Z =  (M.mat[6] + M.mat[9] ) / S;
        W =  (M.mat[2] + M.mat[8] ) / S;
        break;
      case 2:
        S  = sqrt( 1.0f + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;

        X=  (M.mat[2] + M.mat[8] ) / S;
        Y =  (M.mat[6] + M.mat[9] ) / S;
        Z = 0.5f / S;
        W =  (M.mat[1] + M.mat[4] ) / S;
        break;
      }
    }
    //println(S);
    float Mag = sqrt(sq(X)+sq(Y)+sq(Z)+sq(W));
    if(Mag!=0){
      X/=Mag;
      Y/=Mag;
      Z/=Mag;
      W/=Mag;
    }
    v=new vector(X,Y,Z);
    w=W;
  }
  public QUAT QMulti(QUAT Q){
    //Qr = Q1.Q2 = ( w1.w2 - v1.v2, w1.v2 + w2.v1 + v1 x v2 )
    QUAT result = new QUAT();
    result.v=(v.vTimes(Q.w).vPlus(Q.v.vTimes(w)).vPlus(v.vCross(Q.v)));
    result.w=(w*Q.w-v.vDot(Q.v));
    result.normalize();
    return result;
  }
  public void normalize(){
    float Mag=sqrt(sq(v.x())+sq(v.y())+sq(v.z())+sq(w));
    if(Mag!=0){
      v=v.vTimes(1/Mag);
      w/=Mag;
    }
  }
  public void QPrint(){
    print(w);
    print(' ');
    v.vPrint(); 
  }
}
public M4 MQMulti(M4 M1, M4 M2){
  QUAT Q1 = new QUAT(M1);
  QUAT Q2 = new QUAT(M2);
  Q1=Q1.QMulti(Q2);
  return new M4(Q1.v,Q1.w);
}

class block{
  bding[] builds = new bding[0];
  vector p=new vector(0,0,0);
  block(){
  }
  public void addBuilding(vector pAt, int x, int y, int z){
    bding[] tb = new bding[builds.length+1];
    for(int i = 0; i < builds.length;i++){
      tb[i]=builds[i]; 
    }
    tb[tb.length-1]=new bding(pAt,x,y,z);
    builds=tb;
  }
  public void draw(){
    for(int i = 0; i < builds.length; i++){
      if(builds[i].health<0&&frameCount%5==0){
        builds[i].y=max(0,builds[i].y-1); 
      }
      builds[i].draw(p); 
    }
  }
  public boolean bIn(vector pAt){
    vector nP=pAt.vMinus(p);
    for(int i = 0; i < builds.length; i++){
      if(builds[i].p.x()<=nP.x()&&builds[i].x+builds[i].p.x()>nP.x()&&builds[i].p.y()>=nP.y()&&builds[i].p.y()-builds[i].y<nP.y()&&builds[i].p.z()<=nP.z()&&builds[i].z+builds[i].p.z()>nP.z()){
        return true; 
      }
    }
    return false;
  }
  public vector center(int i){
    if(0<=i&&i<builds.length){
      return(builds[i].center(p)); 
    }
    return new vector();
  }
  public float rad(int i){
    if(0<=i&&i<builds.length){
      return(builds[i].rad());
    }
    return(0);
  }
  public imp hit(vector s, vector e){
    imp h1,h2;
    h1=new imp();
    h2=new imp();
    vector c=new vector();
    float r=0;
    float v=(e.vMinus(s).vMag());
    vector newE=new vector();
    newE.x(s.x()/bw-p.x());
    newE.y(s.y()/bh-p.y());
    newE.z(s.z()/bw-p.z());
    vector ext = new vector();
    ext=e.vMinus(s);
    ext.x(abs(ext.x/bw));
    ext.y(abs(ext.y/bw));
    ext.z(abs(ext.z/bw));

    for(int i = 0; i < builds.length; i++){
      if(builds[i].p.x()-ext.x()<newE.x()&&newE.x()<builds[i].p.x()+builds[i].x+ext.x()&&builds[i].p.y()+ext.y()>newE.y()&&newE.y()>builds[i].p.y()-builds[i].y-ext.y()&&builds[i].p.z()-ext.z()<newE.z()&&newE.z()<builds[i].p.z()+builds[i].z+ext.z()){
        h2=builds[i].hit(p,s,e); 
        if((h2.t()>0&&h2.t()<h1.t())||h1.t()<0){
          h1=h2;
          h1.iHit(i);
        }
      }
    }
    return h1;  
  }
}
class bding{
  vector init=new vector();
  vector fin = new vector();
  imp[] imps = new imp[3];
  vector to;
  vector tAt;
  vector nP;
  float health=100;
  vector p;
  int x,y,z;
  vector ext;
  int c;
  bding(vector p1,int x1,int y1, int z1){
    p=p1;
    x=x1;
    y=y1;
    z=z1;
    ext=new vector(x,y,z);
    c=color(255);
  }
  bding(vector p1,int x1,int y1, int z1,int c1){
    p=p1;
    x=x1;
    y=y1;
    z=z1;
    ext=new vector(x,y,z);
    c=c1;
  }
  public vector center(vector orig){
    return  new vector((p.x()+PApplet.parseFloat(x)/2+orig.x())*bw,(p.y()-PApplet.parseFloat(y)/2+orig.y())*bh,(p.z()+PApplet.parseFloat(z)/2+orig.z())*bw);
  }
  public float rad(){
    return(mag(x*bw,y*bh,z*bw)/2); 
  }
  public imp hit(vector orig,vector e,vector s){
    for(int i = 0; i < imps.length; i++){
      imps[i]=new imp(new vector(),new vector(),-1); 
    }
    init.x(e.x()/bw);
    init.y(e.y()/bh);
    init.z(e.z()/bw);
    fin.x(s.x()/bw);
    fin.y(s.y()/bh);
    fin.z(s.z()/bw);
    to = fin.vMinus(init);
    tAt = new vector();
    nP=p.vPlus(orig);
    if(init.x()<nP.x()&&fin.x()>nP.x()){
      tAt=init.vPlus(to.vTimes((nP.x()-init.x())/to.x()));
      if(nP.y()>tAt.y()&&tAt.y()>nP.y()-y&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[0]=new imp(tAt,new vector(-1,0,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.x()>nP.x()+x&&fin.x()<nP.x()+x){
      tAt=init.vPlus(to.vTimes((nP.x()+x-init.x())/to.x()));
      if(nP.y()>tAt.y()&&tAt.y()>nP.y()-y&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[0]=new imp(tAt,new vector(1,0,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.y()>nP.y()&&fin.y()<nP.y()){
      tAt=init.vPlus(to.vTimes((nP.y()-init.y())/to.y()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[1]=new imp(tAt,new vector(0,1,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.y()<nP.y()-y&&fin.y()>nP.y()-y){
      tAt=init.vPlus(to.vTimes((nP.y()-y-init.y())/to.y()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[1]=new imp(tAt,new vector(0,-1,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.z()<nP.z()&&fin.z()>nP.z()){
      tAt=init.vPlus(to.vTimes((nP.z()-init.z())/to.z()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.y()>tAt.y()&&tAt.y()>nP.y()-y){
        imps[2]=new imp(tAt,new vector(0,0,-1),tAt.vMinus(init).vMag());
      }
    }
    if(init.z()>nP.z()+z&&fin.z()<nP.z()+z){
      tAt=init.vPlus(to.vTimes((nP.z()+z-init.z())/to.z()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.y()>tAt.y()&&tAt.y()>nP.y()-y){
        imps[2]=new imp(tAt,new vector(0,0,1),tAt.vMinus(init).vMag());
      }
    }
    for(int i = 0; i < imps.length; i++){
      imps[i].p.x(imps[i].p.x()*bw);
      imps[i].p.y(imps[i].p.y()*bh);
      imps[i].p.z(imps[i].p.z()*bw); 
    }
    float goodness=imps[0].t();
    int best=0;
    for(int i = 0; i < imps.length; i++){
      if((imps[i].t()<goodness&&imps[i].t()>=0)||(goodness<0&&imps[i].t()>=0)){
        goodness=imps[i].t();
        best=i;
      }
    }
    if(goodness>=0){
      return(imps[best]);
    }
    return new imp();
  }
  public void draw(vector orig){
    vector[] verts = new vector[8];
    vector start=new vector();
    vector end = new vector();
    vector nP = p.vPlus(orig);
    nP.x(nP.x()-pCam.x()/bw);
    nP.y(nP.y()-pCam.y()/bw);
    nP.z(nP.z()-pCam.z()/bw);
    int dZone = 0;
    if(nP.x()*bw>d0||(nP.x()+x)*bw<-d0||nP.y()*bh<-d0||(nP.y()-y)*bh>d0||nP.z()*bw>d0||(nP.z()+z)*bw<-d0){
      dZone=1; 
    }
    if(nP.x()*bw>d1||(nP.x()+x)*bw<-d1||nP.y()*bh<-d1||(nP.y()-y)*bh>d1||nP.z()*bw>d1||(nP.z()+z)*bw<-d1){
      dZone=2; 
    }
    if(nP.x()*bw>d2||(nP.x()+x)*bw<-d2||nP.y()*bh<-d2||(nP.y()-y)*bh>d2||nP.z()*bw>d2||(nP.z()+z)*bw<-d2){
      dZone=3; 
    }
    if(nP.x()*bw>d3||(nP.x()+x)*bw<-d3||nP.y()*bh<-d3||(nP.y()-y)*bh>d3||nP.z()*bw>d3||(nP.z()+z)*bw<-d3){
      dZone=4; 
    }
    if(nP.x()*bw>d4||(nP.x()+x)*bw<-d4||nP.y()*bh<-d4||(nP.y()-y)*bh>d4||nP.z()*bw>d4||(nP.z()+z)*bw<-d4){
      dZone=5; 
    }
    if(nP.x()*bw>d5||(nP.x()+x)*bw<-d5||nP.y()*bh<-d5||(nP.y()-y)*bh>d5||nP.z()*bw>d5||(nP.z()+z)*bw<-d5){
      dZone=6; 
    }
    vector nNP = (nP.vMRot(cam));
    nP.y(nP.y()-y);
    nP = (nP.vMRot(cam));
    if(nP.z()<(x+y)&&nNP.z()<(x+y)){
      nP = p.vPlus(orig);

      if(dZone==6){
        /*start.x((nP.x()+x/2)*bw);
         start.y((nP.y())*bh);
         start.z((nP.z()+z/2)*bw);
         end.x((nP.x()+x/2)*bw);
         end.y((nP.y()-y)*bh);
         end.z((nP.z()+z/2)*bw);
         //render.addLine(start,end,c);
         render.addDot(start,bw*(x+z)/4,c);
         render.addDot(end,bw*(x+z)/4,c);
         render.addLine(start,end,c);*/
      }
      if(dZone<=5){
        int b1,b2,b3;
        b1=PApplet.parseInt(nP.x());
        b2=PApplet.parseInt(nP.y());
        b3=PApplet.parseInt(nP.z());
        int x1,x2,x3;
        int y1,y2;
        y1=floor(d3/bw);
        y2=floor(d3/bh);
        int y3,y4;
        y3=floor(d2/bw);
        y4=floor(d2/bw);
        x1=PApplet.parseInt(pCam.x());
        x2=PApplet.parseInt(pCam.y());
        x3=PApplet.parseInt(pCam.z());
        x1=floor(x1/bw);
        x2=floor(x2/bh);
        x3=floor(x3/bw);
        float d=0;
        float n=0;
        int c1;
        d=min(abs(b1-x1),abs(b1+x-x1));
        d=min(d,abs(b3-x3));
        d=min(d,abs(b3+z-x3));
        if(dZone<=1){
          start.y(max(nP.y()-y,x2-2)*bh);
          end.y(min(nP.y(),x2+2)*bh);
          for(int i = 0; i < verts.length; i++){
            verts[i]=new vector();
            if(i<4){
              verts[i].y(max(nP.y()-y,x2-2)*bh); 
            }
            else{
              verts[i].y(min(nP.y(),x2+2)*bh); 
            }
            verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
            if(i%4<2){
              verts[i].x((nP.x())*bw); 
            }
            else{
              verts[i].x((nP.x()+x)*bw); 
            }
            if((i+1)%4<2){
              verts[i].z((nP.z())*bw); 
            }
            else{
              verts[i].z((nP.z()+z)*bw); 
            }
          }
          c1 = color(32);
          for(int i = 0; i < 4; i++){
            render.addLine(verts[i],verts[(i+1)%4],c1);
            render.addLine(verts[i+4],verts[((i+1)%4)+4],c1);
          }
          for(int i = 0; i < verts.length; i++){
            if(i<4){
              verts[i].y(max(nP.y()-y,x2-12)*bh); 
            }
            else{
              verts[i].y(min(nP.y(),x2+12)*bh); 
            }
            verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
          }
          for(int i = 0; i < 4; i++){
            render.addLine(verts[i],verts[i+4],c1); 
          }
          if(dZone==0){
            for(int i = 0; i < verts.length; i++){
              if(i<4){
                verts[i].y(max(nP.y()-y,x2-1)*bh); 
              }
              else{
                verts[i].y(min(nP.y(),x2+1)*bh); 
              }
              verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
            }
            c1 = color(48);
            for(int i = 0; i < 4; i++){
              render.addLine(verts[i],verts[(i+1)%4],c1);
              render.addLine(verts[i+4],verts[((i+1)%4)+4],c1);
            }
            for(int i = 0; i < 4; i++){
              verts[i].y(constrain(x2,nP.y()-y,nP.y())*bh); 
            }
            c1 = color(64);
            for(int i = 0; i < 4; i++){
              render.addLine(verts[i],verts[(i+1)%4],c1); 
            }
          }
        }
        if(dZone<5){
          for(int i = b2-y;i<=b2; i+=PApplet.parseInt(pow(2,dZone))){
            start.y((nP.y()+i)*bh);
            start.x((nP.x())*bw);
            start.z((nP.z())*bw);
            render.addPoint(start);
            start.x((nP.x()+x)*bw);
            render.addPoint(start);
            start.z((nP.z()+z)*bw);
            render.addPoint(start);
            start.x((nP.x()*bw));
            render.addPoint(start);
          }
        }
        else{
          for(int i = b2-y;i<=b2; i+= y){
            start.y((nP.y()+i)*bh);
            start.x((nP.x())*bw);
            start.z((nP.z())*bw);
            render.addPoint(start);
            start.x((nP.x()+x)*bw);
            render.addPoint(start);
            start.z((nP.z()+z)*bw);
            render.addPoint(start);
            start.x((nP.x()*bw));
            render.addPoint(start);
          }
        }

        /*if(b2-y>x2-y4&&b2-y<x2+y4){
         start.y((b2-y)*bh);
         d=max(0,abs(b2-y-x2)-1)/float(y4);
         n=1-d;
         c1=color(n*red(c),n*green(c),n*blue(c));
         println("hi");
         for(int i = 0; i <= x; i+=1){
         for(int j = 0; j<=z; j+=1){
         start.x((b1+i)*bw);
         start.z((b3+j)*bw);
         render.addDot(start,bw/16,c1);
         }
         } 
         }
         if(b2>x2-y4&&b2-y<x2+y4){
         for(int k = max(b2-y,x2-y4);k<=min(b2,x2+y4);k+=1){
         start.y((k)*bh);
         d=max(0,abs(k-x2)-1)/float(y4);
         n=1-d;
         c1=color(n*red(c),n*green(c),n*blue(c));
         for(int i = 0; i <= x; i+=2){
         start.x((nP.x()+i)*bw);
         start.z((nP.z())*bw);
         render.addDot(start,bw/16,c1);
         start.z((nP.z()+z)*bw);
         render.addDot(start,bw/16,c1);
         }
         for(int i = 1; i <= z; i+=2){
         start.x((nP.x())*bw);
         start.z((nP.z()+i)*bw);
         render.addDot(start,bw/16,c1);
         start.x((nP.x()+x)*bw);
         render.addDot(start,bw/16,c1);
         }
         }
         }*/
      }
    }
  }
}

class pTrail{
  float perFrame=1;
  vector[]  p = new vector[0];
  int cur = 0;
  boolean[] filled=new boolean[0];
  pTrail(int l,float k){
    p=new vector[l];
    filled=new boolean[l];
    for(int i = 0; i < l; i++){
      filled[i]=false; 
    }
    cur = 0;
    perFrame = k;
    for(int i = 0; i < l; i++){
      p[i]=new vector();
    }
  }
  public void addPoint(vector nP){
    vector lp = p[cur];
    if(perFrame>=1){
      int pF = floor(perFrame); 
      for(int i = 0; i < pF;i++){
        cur=(cur+1)%p.length;
                filled[cur]=true;
        p[cur]=lp.vPlus((nP.vMinus(lp).vTimes(PApplet.parseFloat(i+1)/perFrame)));
      }
    }
    if(perFrame<1){
      if(frameCount%floor(1/perFrame)==0){
        filled[cur]=true;
        cur=(cur+1)%p.length;
        p[cur]=nP;
      } 
    }
  }
  public void draw(){
    for(int i = 0; i < p.length; i++){
      if(filled[i]);
      render.addPoint(p[i]);
    } 
  }

}
class lTrail{
  vector[]  p = new vector[0];
  int c;
  int cur = 0;
  boolean[] filled=new boolean[0];
  lTrail(int l,int col){
    p=new vector[l];
    c=col;
    filled=new boolean[l];
    for(int i = 0; i < l; i++){
      filled[i]=false; 
    }
    cur = 0;
    for(int i = 0; i < l; i++){
      p[i]=new vector();
    }
  }
  public void addVert(vector nP){
    cur=(cur+1)%p.length;
    p[cur]=nP;
    filled[cur]=true;
   
  }
  public void draw(){
    for(int i = 0; i < p.length; i++){
      if(filled[i]&&filled[(i+1)%p.length]);
      render.addLine(p[i],p[(i+1)%p.length],c);
    } 
  }

}

M4 cam = new M4();
vector pCam = new vector();
class dotRender{
  /*PImage[] tex = new PImage[0];
   color nullC = color(0,0,0);
   int[] wTex=new int[0];
   vector[] p=new vector[0];
   float[] r = new float[0];
   vector[] tP;
   float[] tR;
   color[] tC;
   int[] tW;*/
  int[] lC=new int[0];
  vector[][] lP=new vector[0][2];
  vector[] points = new vector[0];
  int[] pC=new int[0];
  int back;
  int eq = -1;
  int curLine=-1;
  int curPoint=-1;
  int maxDot=-1;
  int maxLine=-1;
  int maxPoint=-1;
  float dPoint=-1;
  float dLine=-1;
  int[] lineDist;
  int[] pointDist;
  int lineFade;
  int pointFade;
  int nullC=color(255);
  dotRender(int lines,int pts,int lDrawDist,int pDrawDist,int backgrnd){
    back=backgrnd;
    lineFade=lDrawDist;
    pointFade=pDrawDist;
    points=new vector[pts];
    pC=new int[pts];
    pointDist=new int[pts];
    lP=new vector[lines][2];
    lineDist=new int[lines];
    lC=new int[lines];

  }
  public void addPoint(vector nP,int c){
    nP = (nP.vMinus(pCam)).vMRot(cam);
    int d = floor(nP.vMag());
    if(nP.z()<0&&d<pointFade){
      if(curPoint<points.length-1){
        curPoint++;
        points[curPoint]=nP;
        pC[curPoint]=c;
        if(d>dPoint){
          dPoint=nP.vMag();
          maxPoint=curPoint; 
          pointDist[curPoint]=d;
        }
      }
      else{
        if(d<dPoint){
          points[maxPoint]=nP;
          pC[maxPoint]=c;
          pointDist[maxPoint]=d;
          maxPoint=-1;
          dPoint=-1;
          for(int i = 0; i < points.length;i++){
            if(pointDist[i]>dPoint){
              dPoint=pointDist[i];
              maxPoint=i;
            } 
          }
        }
      }
    }
  }
  public void addPoint(vector nP){
    nP = (nP.vMinus(pCam)).vMRot(cam);
    int d = floor(nP.vMag());
    if(nP.z()<0&&d<pointFade){
      if(curPoint<points.length-1){
        curPoint++;
        points[curPoint]=nP;
        pC[curPoint]=nullC;
        if(d>dPoint){
          dPoint=nP.vMag();
          maxPoint=curPoint; 
          pointDist[curPoint]=d;
        }
      }
      else{
        if(d<dPoint){
          points[maxPoint]=nP;
          pC[maxPoint]=nullC;
          pointDist[maxPoint]=d;
          dPoint=-1;
          maxPoint=-1;
          for(int i = 0; i < points.length;i++){
            if(pointDist[i]>dPoint){
              dPoint=pointDist[i];
              maxPoint=i;
            } 
          }
        }
      }
    }
  }
  public void addLine(vector start, vector end, int col){
    start=(start.vMinus(pCam)).vMRot(cam);
    end=(end.vMinus(pCam)).vMRot(cam);
    int d=floor(min(start.vMag(),end.vMag()));
    if(curLine<lP.length-1&&d<lineFade){
      curLine++;
      lP[curLine][0]=start;
      lP[curLine][1]=end;
      lC[curLine]=col;
      lineDist[curLine]=d;
      if(d>dLine){
        dLine=d;
        maxLine=curLine;
      }
    }
    else{
      if(d<dLine){
        lP[maxLine][0]=start;
        lP[maxLine][1]=end;
        lC[maxLine]=col;
        lineDist[maxLine]=d;
        dLine=-1;
        for(int i = 0; i < lP.length;i++){
          if(lineDist[i]>dLine){
            dLine=lineDist[i];
            maxLine=i;
          } 
        }
      }
    }
  }
  public void draw3(){
    background(back);
    loadPixels();
    float x=0;
    float y=0;
    float x1=0;
    float y1=0;
    float mole=0;
    float k = cameraZ;
    for(int i = 0; i <= curLine; i++){
      if(lP[i][0].z()<0||lP[i][1].z()<0){
        if(lP[i][0].z()>=0){
          lP[i][0]=lP[i][1].vPlus(lP[i][0].vMinus(lP[i][1]).vTimes((lP[i][1].z()+2)/(-lP[i][0].vMinus(lP[i][1]).z())));
        }
        if(lP[i][1].z()>=0){
          lP[i][1]=lP[i][0].vPlus(lP[i][1].vMinus(lP[i][0]).vTimes((lP[i][0].z()+2)/(-lP[i][1].vMinus(lP[i][0]).z())));
        }
        x=(-lP[i][0].x()*k/lP[i][0].z())+width/2;
        y=(-lP[i][0].y()*k/lP[i][0].z())+height/2;
        x1=(-lP[i][1].x()*k/lP[i][1].z())+width/2;
        y1=(-lP[i][1].y()*k/lP[i][1].z())+height/2;
        if((!(x<0&&x1<0||x1>width&&x>width))&&(!(y<0&&y1<0||y>height&&y1>height))){
          stroke(lC[i]);
          line(x,y,x1,y1);
        }
      }
    }
    for(int i = 0; i <= curPoint&&i<points.length; i++){
      if(points[i].z()<0){
        stroke(255);
        x =-points[i].x()*k/points[i].z()+width/2;
        y = -points[i].y()*k/points[i].z()+height/2;
        if(0<x&&x<width&&0<y&&y<height){
          if(0<PApplet.parseInt(y*width+x)&&PApplet.parseInt(y*width+x)<width*height){
            //point(x,y);
            y=floor(y);
            x=floor(x);
            pixels[PApplet.parseInt(y*width+x)]=pC[i];
          }
        }
      } 
    }
    updatePixels();
    curPoint=-1;
    dPoint=-1;
    maxPoint=-1;
    curLine=-1;
    dLine=-1;
    maxLine=-1;
  }
}


class guy{
  gun myGun=new gun();
  boolean bAi=true;
  boolean bShoot=false;
  vector p=new vector();
  vector lp = new vector();
  vector r=new vector();
  vector s=new vector();
  vector v=new vector();
  vector goalPos=new vector();
  vector mr = new vector();
  boolean bActive=true;
  vector pGoal=new vector();
  boolean trackTarget=false;
  int target;
  int moveMode=0;
  int team = -1;
  M4 rM = new M4();
  fig mod;
  int iAm;
  guy(int me,String name){
    pGoal=new vector(random(32*4*bw,96*4*bw),random(-24*4*bh,0),random(32*4*bw,96*4*bw)); 
    bActive=true;
    iAm=me;
    if(iAm!=0){
      int test =floor(random(1.25f));
      /*switch(test){
      case 0:
        mod = new fig(name,color(255,0,0));
        target=iAm;
        break;
      case 1:
        mod=new fig(name,color(0,255,0));
        target=iAm;
        break;
      }*/
      if(0<iAm&&iAm<33){
        team=0; 
      }else{
      if(33<=iAm&&iAm<65){
        team=1; 
      }else{team=-1;
      }
      }
          if(iAm==0){
      team = -1; 
    }
    else{
      myGun.shotType=5;
      ;
    }
      if(team==-1){

        mod=new fig(name,color(0,255,0)); 
      }
      if(team==0){
        mod=new fig(name,color(255,0,0)); 
      }
      if(team==1){
        mod=new fig(name,color(0,0,255)); 
      }
    }
    else{
      mod = new fig(name);
    }
  }
  public void upDate(){
    imp h=new imp();
    if(bActive){
      M4 M = new M4();
      M4 M1 = new M4();
      if(!bAi){
        if(keysPressed[ascii('u')]){
          bShoot=true; 
        }
        else{
          bShoot=false; 
        }
        if(keysPressed[ascii('w')]||keysPressed[ascii('W')]){
          moveMode=1;
          //mr.x(PI/12);
        }
        if(keysPressed[ascii('s')]||keysPressed[ascii('S')]){
          moveMode=2;
          //mr.x(-PI/12);
        }
        if(keysPressed[ascii('a')]||keysPressed[ascii('A')]){
          r.y(r.y()-PI/100);
          mr.z(-PI/8);
          mr.y(-PI/8);
        }
        if(keysPressed[ascii('d')]||keysPressed[ascii('D')]){
          r.y(r.y()+PI/100);
          mr.z(PI/8);
          mr.y(PI/8);
        }
        if(!(keysPressed[ascii('a')]||keysPressed[ascii('A')]||keysPressed[ascii('d')]||keysPressed[ascii('D')])){
          mr.z(0);
          mr.y(0);
        }
        if(keysPressed[32]){
          if(moveMode==1){
            moveMode=3; 
          }
          if(moveMode==2){
            moveMode=4; 
          }
        }
        if(!(keysPressed[ascii('w')]||keysPressed[ascii('W')])&&!(keysPressed[ascii('s')]||keysPressed[ascii('S')])){
          moveMode=0;
        }
        if(moveMode==0){
          r.x(0);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-128){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==1){
          r.x(PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          //s.z(s.z()-1);
          if(s.z()>-32){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==2){
          r.x(-PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-128){
            s.z(s.z()+1); 
          }
          if(s.z()>-32){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==3){
          r.x(PI/2);
          v.y(v.y()+abs(s.z()));
          v.y(v.y+1);
          s.z(0);
          v.y(min(v.y,128));
        }
        if(moveMode==4){
          r.x(-PI/2);
          v.y(v.y()-abs(s.z()));
          v.y(v.y+1);
          v.y(min(v.y,-32));
          s.z(0);
        }
      }
      //target=-1;
      if(bAi){
        /*float range=-1;
         for(int i = 0; i<peeps.length;i++){
         if((i==iAm)==false){
         if(p.vMinus(peeps[i].p).vMag()<range||target==iAm||target<0){
         target=i;
         range=p.vMinus(peeps[i].p).vMag();
         }
         }
         }*/
        //target=0;
        if(frameCount%32==iAm%32){
          while(target==iAm){
            target=floor(random(peeps.length)); 
          }
          int d = -1;
          if(team>=0){
            trackTarget=false;
            for(int i = 0; i < peeps.length; i++){
              if(i!=iAm&&peeps[i].team>=0&&peeps[i].team!=team){
                if((peeps[i].p.vMinus(p).vMag()<28*bw*4)&&(d<0||peeps[i].p.vMinus(p).vMag()<d)){
                  target=i;
                  d=floor(peeps[i].p.vMinus(p).vMag());
                  trackTarget=true;
                }
              }
            }
          }
          while(pGoal.vMinus(p).vMag()<2048){
            int k = floor(random(estments.length));
            pGoal.x(estments[k].x());
            pGoal.y(estments[k].y());
            pGoal.z(estments[k].z());
          }
          if(trackTarget){
            pGoal.x(peeps[target].p.x());
            pGoal.y(peeps[target].p.y());
            pGoal.z(peeps[target].p.z());
          }
          M.MRot(0,0,r.z());
          M1.MRot(r.x(),0,0);
          M1=MMulti(M1,M);
          M.MRot(0,r.y(),0);
          M=MMulti(M,M1);
          vector tS1 = s.vMRot(M).vPlus(v);
          rM=M;
          vector isop1 = new vector();
          vector isolp1=new vector();
          isop1.x(p.x()/bw+sign(tS1.x()));
          isop1.y(p.y()/bh+sign(tS1.y()));
          isop1.z(p.z()/bw+sign(tS1.z()));
          goalPos.x(pGoal.x());
          goalPos.y(pGoal.y());
          goalPos.z(pGoal.z());
          d=-1;
          isop1.x(floor(p.x()/bw));
          isop1.y(floor(p.y()/bh));
          isop1.z(floor(p.z()/bw));
          h=b.hit(new vector(p.x(),p.y(),p.z()),new vector(pGoal.x(),pGoal.y(),pGoal.z()));
          if(h.t()>=0){         
            for(int i = -3; i<4; i++){
              for(int j = -3; j <4; j++){
                if(i!=0||j!=0){
                  isolp1.x(isop1.x()+i);
                  isolp1.y(isop1.y());
                  isolp1.z(isop1.z()+j);
                  if(!b.bIn(isolp1)){
                    isolp1.x(isolp1.x()*bw+bw/2);
                    isolp1.y(isolp1.y()*bh);
                    isolp1.z(isolp1.z()*bw+bw/2);
                    if(d<0||isolp1.vMinus(pGoal).vMag()<d){
                      d=floor(isolp1.vMinus(pGoal).vMag());
                      goalPos.x(isolp1.x());
                      goalPos.y(isolp1.y());
                      goalPos.z(isolp1.z());
                    }
                  }
                }
              }
            }
          }
          if(trackTarget){
            rM.MTrans();
            vector tAt = peeps[target].p.vMinus(p).vMRot(rM);
            if(mag(tAt.x(),tAt.y())<512&&tAt.z()<0){
              bShoot=true;
            }else{
              bShoot=false; 
            }
          }
          if(peeps[target].p.y()<p.y()-bh/2){
            moveMode=2; 
          }
          else{
            if(peeps[target].p.y()>p.y()+bh/2){
              moveMode=1; 
            }
            else{
              moveMode=0; 
            }
          }
        }
        //
        r.z(0);
        float theta=limit(atan2((goalPos.vMinus(p)).z(),(goalPos.vMinus(p)).x())+PI/2-r.y());
        if(theta<-PI/10){
          r.y(r.y()-PI/500);
          mr.z(-PI/8);
          mr.y(-PI/8);
        }
        else{
          if(theta>PI/10){
            r.y(r.y()+PI/500);
            mr.z(PI/8);
            mr.y(PI/8);
          }
          else{
            mr.z(0);
            mr.y(0); 
          }
        }
        if(moveMode==0){
          r.x(0);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==1){
          r.x(PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==2){
          r.x(-PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==3){
          r.x(PI/2);
          v.y(v.y()+abs(s.z()));
          v.y(v.y+1);
          s.z(0);
          v.y(min(v.y,256));
        }
        if(moveMode==4){
          r.x(-PI/2);
          v.y(v.y()-abs(s.z()));
          v.y(v.y+1);
          v.y(min(v.y,-64));
          s.z(0);
        }
      }

      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      vector tS = s.vMRot(M).vPlus(v);
      rM=M;
      lp = p;
      p=p.vPlus(tS);
      if(p.y()>=-1){
        p.y(-1); 
      }
      vector isop = new vector();
      vector isolp=new vector();
      isop.x(p.x());
      isop.y(p.y());
      isop.z(p.z());
      isolp.x(lp.x());
      isolp.y(lp.y());
      isolp.z(lp.z());
      h = b.hit(isolp,isop);
      while(h.t()>=0){
        vector t = p.vMinus(h.p());
        t.x(t.x()*(1-abs(h.n().x())));
        t.y(t.y()*(1-abs(h.n().y())));
        t.z(t.z()*(1-abs(h.n().z())));
        p=h.p().vPlus(t);
        p=p.vPlus(h.n().vTimes(4));
        isolp=p;
        isop=h.p();
        h=b.hit(isop,isolp);
      }
      myGun.upDate(bShoot,p,r);
    }
  }
  public void draw(){
    if(bActive){
      M4 M = new M4();
      M4 M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      M1.MRot(mr.x(),mr.y(),mr.z());
      M=MMulti(M,M1);
      mod.draw(p,M); 
    }
  }
}
class imp{
  float t=-1;
  vector n=new vector();
  vector p=new vector();
  int iHit=-1;
  imp(){
    t=-1;
  }
  imp(vector p1, vector n1, float t1){
    p=p1;
    n=n1;
    t=t1;
  }
  imp(vector p1, vector n1){
    p=p1;
    n=n1;
  }
  public float t(){
    return t; 
  }
  public int iHit(){
    return iHit; 
  }
  public vector n(){
    return n; 
  }
  public vector p(){
    return p; 
  }
  public void t(float t1){
    t=t1; 
  }
  public void n(vector n1){
    n=n1; 
  }
  public void p(vector p1){
    p=p1; 
  }
  public void iHit(int hit){
    iHit=hit; 
  }
}
class gun{
  int clipSize=4;
  int clip=0;
  int reLoadCounter=0;
  int reLoadTime=60;
  int shotCounter=0;
  int shotTime=8;
  vector fireFrom=new vector();
  vector fireAngle=new vector();
  vector fireVel=new vector(0,0,-1024);
  int shotType=0;
  int shotRange=64;
  gun(){
  }
  public void upDate(boolean firing,vector p, vector r){
    shotCounter--;
    reLoadCounter--;
    if(firing&&reLoadCounter<0){
      if(shotCounter<0&&clip>0){
        clip--;
        shotCounter=shotTime-1;
        M4 M;
        M4 M1;
        M = new M4();
        M1 = new M4();
        M.MRot(0,0,r.z());
        M1.MRot(r.x(),0,0);
        M1=MMulti(M1,M);
        M.MRot(0,r.y(),0);
        M=MMulti(M,M1);
        addProj(p,r.vPlus(fireAngle),fireVel,shotRange,shotType,0);
      }
    }
    if(clip<=0){
      clip=clipSize;
      reLoadCounter=reLoadTime-1;
    }
  }
}

obj[] stuff=new obj[0];
class obj{
  fig mod;
  vector p;
  vector r;
  obj(vector p1, vector r1, fig mod1){
    p=p1;
    r=r1;
    mod=mod1;
  }
  public void draw(){
    if(p.vMinus(pCam).vMag()<1024*64){
      M4 M;
      M4 M1;
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      mod.draw(p,M);
    }
  }
}
public void addObj(vector p, vector r, fig mod){
  obj[] tStuff = new obj[stuff.length+1];
  for(int i = 0; i < stuff.length; i++){
    tStuff[i]=stuff[i]; 
  }
  tStuff[tStuff.length-1]=new obj(p,r,mod);
  stuff=tStuff;
}
public void drawObj(){
  for(int i = 0; i<stuff.length;i++){
    stuff[i].draw(); 
  }
}

proj[] deb = new proj[1024];
fig[] mods = new fig[5];
public void loadMods(){
  mods[0]=new fig("rocket1");
  mods[1]=new fig("dot");
  mods[2]=new fig("ballOfFire");
  mods[3]=new fig("dSphere"); 
  mods[4]=new fig("dot");
}
class proj{
  vector p=new vector();
  vector lp = new vector();
  vector r = new vector();
  vector v = new vector();
  vector s = new vector();
  M4 rM = new M4();
  boolean bActive=false;
  fig mod;
  int lifeLeft=0;
  int t=-1;
  imp h = new imp();
  int counter=0;
  proj(){
    bActive=false;
  }
  proj(vector p1, vector r1, vector s1,int time, int t1,int count){
    counter=count;
    M4 M;
    M4 M1;
    bActive=true;
    t=t1;
    lp=p1;
    p=p1;
    r=r1;
    s=s1;
    lifeLeft=time;
    v=new vector();
    switch(t){
    case 0:
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      mod=mods[0];
      break;
    case 1:
      mod=mods[1];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 2:
      mod=mods[1];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 3:
      mod=mods[3];
      break;

    case 4:
      mod=mods[4];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 5:
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      mod=mods[0];
      break;
    }
  }
  public void upDate(){
    M4 M;
    M4 M1;
    M = new M4();
    M1 = new M4();
    M.MRot(0,0,r.z());
    M1.MRot(r.x(),0,0);
    M1=MMulti(M1,M);
    M.MRot(0,r.y(),0);
    M=MMulti(M,M1);
    rM=M;
    if(bActive){
      lifeLeft--;
      if(lifeLeft<0){
        bActive=false;
      }
      switch(t){
      case -1:
        break;
      case 0:
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          bActive=false; 
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          for(int i= 0; i < 8; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-48),floor(64),1,0);
          }
          for(int i= 0; i < 16; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-48),floor(64),4,0);
          }
          for(int i= 0; i < 1; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(random(32,128)),2,0);
          }
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5f-abs(h.n().x())));
          temp.y(temp.y()*2*(.5f-abs(h.n().y())));
          temp.z(temp.z()*2*(.5f-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5f-abs(h.n().x())));
          v.y(v.y()*2*(.5f-abs(h.n().y())));
          v.z(v.z()*2*(.5f-abs(h.n().z())));
          counter++;
          //addProj(h.p(),r,s,16,3);
          //bActive=false;
          h=b.hit(h.p(),p);
        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512&&j!=0){
              bActive=false;
              for(int i= 0; i < 16; i++){
                addProj(p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-64),floor(64),1,0);
              }
              for(int i= 0; i < 1; i++){
                addProj(p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(128),2,0);
              }
              //peeps[j].bActive=false;
            } 
          }
        }
        if(counter>0){
          bActive=false; 
        }
        mod.draw(p,rM);
        break;
      case 1:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
          v.y(-abs(v.y())*.5f);
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5f-abs(h.n().x())));
          temp.y(temp.y()*2*(.5f-abs(h.n().y())));
          temp.z(temp.z()*2*(.5f-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5f-abs(h.n().x())));
          v.y(v.y()*2*(.5f-abs(h.n().y())));
          v.z(v.z()*2*(.5f-abs(h.n().z())));
          //b.builds[h.iHit()].health=b.builds[h.iHit()].health-.1;
          h=b.hit(h.p(),p);
          //if(counter<2){
          // for(int i= 0; i < 10; i++){
          //  addProj(h.p().vPlus(h.n().vTimes(5)),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-128),64,1,counter+1);
          //  }
          //  }
          //bActive=false;

        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512){
              bActive=false;
              for(int i= 0; i < 16; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
              }
              for(int i= 0; i < 32; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
              }
              for(int i= 0; i < 1; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(128),2,0);
              }
              peeps[j].bActive=false;
              kills++;
            } 
          }
        }
        mod.draw(p,rM);
        break;
      case 2:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5f-abs(h.n().x())));
          temp.y(temp.y()*2*(.5f-abs(h.n().y())));
          temp.z(temp.z()*2*(.5f-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5f-abs(h.n().x())));
          v.y(v.y()*2*(.5f-abs(h.n().y())));
          v.z(v.z()*2*(.5f-abs(h.n().z())));
          h=b.hit(h.p(),p);
          if(counter<25){
            for(int i= 0; i < 16; i++){
              addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
            }
            for(int i= 0; i < 16; i++){
              addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
            }
          }
          bActive=false;
        }
        mod.draw(p,rM);
        break;
      case 3:
        mod.draw(p,rM);
        break;
      case 4:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
          v.y(-abs(v.y())*.5f);
        }
        mod.draw(p,rM);
        break;
      case 5:
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          bActive=false; 
        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512){
              bActive=false;
              for(int i= 0; i < 4; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
              }
              for(int i= 0; i < 8; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
              }
              peeps[j].bActive=false;
              kills++;
            } 
          }
        }
        if(counter>0){
          bActive=false; 
        }
        mod.draw(p,rM);
        break;
      }
    }
  }
}
public void addProj(vector p,vector r, vector s, int t, int t1,int counter){
  boolean bAlready=false;
  for(int i = 0; i < deb.length&&!bAlready; i++){
    if(deb[i].bActive==false){
      deb[i]=new proj(new vector(p.x(),p.y(),p.z()),new vector(r.x(),r.y(),r.z()),new vector(s.x(),s.y(),s.z()),t,t1,counter);
      bAlready=true; 
    }
  }
  /*if(!bAlready){
   proj[] td = new proj[deb.length+1];
   for(int i = 0; i < deb.length; i++){
   td[i]=deb[i];
   }
   td[td.length-1]=new proj(new vector(p.x(),p.y(),p.z()),new vector(r.x(),r.y(),r.z()),new vector(s.x(),s.y(),s.z()),t,t1,counter);
   deb=td;
   }*/
}
public void projUpdate(){
  for(int i = 0; i < deb.length;i++){
    deb[i].upDate();
  } 
}

float bw= 1024;
float bh = 1024;
int d0 = PApplet.parseInt(48*bw);
int d1 = PApplet.parseInt(96*bw);
int d2 = PApplet.parseInt(128*bw);
int d3 = PApplet.parseInt(128*bw);
int d4 = PApplet.parseInt(128*bw);
int d5 = PApplet.parseInt(256*bw);

    }
