import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

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

void setup(){
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
  size(int(640),int(480),P3D);
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
  float fov = PI/3.0;
  cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*100.0);
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
void draw(){
  tap();
  render.back=color(max(128*1.5*-sin(float(frameCount)/(2048.1)*PI),0));
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
  M1.MRot(peeps[follow].r.x()*.75,0,0);
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
void renderBlock(int x, int y,int rWid,int bMin,int bMax,int hMin,int hMax){
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
      wCur=int(random(bMin,bMax));
      hCur=int(random(bMin,bMax));
      dCur=int(random(hMin,hMax));
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
      int choice = floor(random(0,1.999));
      int breakAt=0;
      switch(choice){
      case 0:
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),wCur*4,dCur*4,hCur*4);
        break; 
      case 1:
        breakAt=int(random(4,(wCur-1)*4));
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),breakAt-rWid,4*int(random(hMin,hMax)),hCur*4);
        b.addBuilding(new vector((xCur+rWid)*4+breakAt,0,(yCur+rWid)*4),wCur*4-breakAt,dCur*4,hCur*4);
        break;
      case 2:
        breakAt=int(random(4,(hCur-1)*4));
        b.addBuilding(new vector((xCur+rWid)*4,0,(yCur+rWid)*4),wCur*4,4*int(random(hMin,hMax)),breakAt-rWid);
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
void drawMap(float x, float y){
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
void stop()
{
  song.close();
  super.stop();
}
