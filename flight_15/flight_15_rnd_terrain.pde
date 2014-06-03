//import processing.opengl.*;
int freeLook = 0;
boolean bGround=false;
float[] wins = new float[5];
float[] pr = new float[3];
float[] fCamera = new float[6];
  float[] center=new float[3];
float zoom;
float[][] colorGroups = new float[5][3];
int inCycle=0;
float cameraZ;
float pSpeed=0;
int lockOn = 0;
boolean reSpawn=true;
  int[] inGroup = new int[5];
  float initScale;
map terrain;
M4 cam = new M4();
SKA[] sModels = new SKA[0];
particle[] smoke = new particle[1];
plane[] planes = new plane[0];
PFont font;
int mStart=0;
boolean bFirst=true;
PImage sky = createImage(256,256,RGB);
float[][] pilots = new float[10][2];
float[][] aces=new float[3][2];
void setup(){
  if(bFirst){
    for(int i = 0; i < inGroup.length; i++){
      inGroup[i]=2; 
    }
    for(int i = 0; i < pilots.length; i++){
      pilots[i][0]=random(PI/200,PI/50);
     pilots[i][1]=random(2,8); 
    }
    for(int i = 0; i < wins.length; i++){
      wins[i]=0; 
    }
bFirst=false;
  }/*else{
    boolean isIt=false;
    int k=0;
    for(int i = 0; i < inGroup.length; i++){
      if(inGroup[i]>0)k++; 
    }if(k<=1){isIt=true;}
    for(int i = 0; i < inGroup.length; i++){
      if(wins[i]>0){
        isIt=true;
      } 
    }if(isIt){
    for(int i = 0; i < inGroup.length; i++){
      if(wins[i]>=inGroup[i]){
        inGroup[i]=constrain(inGroup[i]+1,2,5);
      }
      else{
        inGroup[i]=constrain(inGroup[i]-1,2,5); 
      }
      wins[i]=0;
    }
    }
  }*/
  initScale=random(.1);
    //size(960,760,OPENGL);
    size(960,760,P3D);
    float fov = PI/3.0;
  cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
perspective(fov, float(width)/float(height), 
            cameraZ/10.0, cameraZ*100.0);
    zoom = 1.01/256;
      PImage sky1 = createImage(256,256,RGB);
  sky1.loadPixels();
  int initMillis=millis();
  for(int i = 0; i < 256; i++){
    for(int j = 0; j < 256; j++){
        sky1.set(i,j,color(noise(i*initScale,j*initScale,initMillis)*255));
        //sky1.set(i,j,color(255));
        }
      
  }
  sky1.updatePixels();
  sky.loadPixels();
  for(int i = 0; i < 256*256; i++){
    sky.pixels[i]=color(255);
  }
  sky.updatePixels();
  sky.mask(sky1);
  font = loadFont("Arial-BoldMT-20.vlw");
  textFont(font, 20); 
  colorGroups[0][0]=0;
  colorGroups[0][1]=0;
  colorGroups[0][2]=255;

  colorGroups[1][0]=255;
  colorGroups[1][1]=0;
  colorGroups[1][2]=0;

  colorGroups[2][0]=0;
  colorGroups[2][1]=255;
  colorGroups[2][2]=0;

  colorGroups[3][0]=255;
  colorGroups[3][1]=255;
  colorGroups[3][2]=0;

  colorGroups[4][0]=255;
  colorGroups[4][1]=255;
  colorGroups[4][2]=255;
  int whichTex = int(millis()+int(100*random(100)));
  whichTex = whichTex%4;
  switch (whichTex){
    case 0:
  terrain = new map(32,32,512,random(.025,.0525),48,"grass_surface_texture_partsize.jpg",0);
  break;
  case 1:
  terrain = new map(32,32,512,random(.025,.0525),64,"neige.jpg",0);
  break;
  case 2:
  terrain = new map(32,32,512,random(0,.05),32,"sand_texture_1.jpg",0);
  break;
  case 3:
  terrain = new map(32,32,512,random(0,.125),32, "RockTextureA.jpg",2);
  break;
  }
  planes=new plane[0];
  smoke[0]=new particle(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  //background(3,238,255);
 background(0); 
  cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  int n = 0;
  for(int i = 0; i < inGroup.length; i++){
    if(inGroup[i]>0){
      n++;
    }
  }
  boolean mig = false;
  int k = -1;
  int k1=-1;
  for(int i = 0; i <5; i++){
    if(inGroup[i]>0){
      k1++;
    }
    mig=int(random(1000))%2==0;
    for(int j = 0; j < inGroup[i]; j++){
      k++;
      if(0!=0){
      //if(millis()%2!=0){
      addPlane(32*256+(cos(k1*TWO_PI/n)*512+cos(PI/2+j*TWO_PI/inGroup[i])*256),0,32*256+(sin(k1*TWO_PI/n)*512+sin(PI/2+j*TWO_PI/inGroup[i])*256),"mig-29.txt",true);
      }
      else{
      addPlane(32*256+(cos(k1*TWO_PI/n)*512+cos(PI/2+j*TWO_PI/inGroup[i])*256),0,32*256+(sin(k1*TWO_PI/n)*512+sin(PI/2+j*TWO_PI/inGroup[i])*256),"mig-29.txt",true);
      }
      planes[k].group = i;
      //planes[k].skills[0]=min((PI/100),PI/12.5);
      planes[k].skills[0]=pilots[k%pilots.length][0];
      //planes[k].skills[1]=min((PI/100),PI/12.5);
            planes[k].skills[1]=pilots[k%pilots.length][0];
      planes[k].skills[2]=PI/8;
      planes[k].throttle = .5;
      planes[k].target = k;
      planes[k].r[1]=PI/2+atan2(planes[k].pos[2],planes[k].pos[0]);
      //planes[k].rxn=constrain(i*4-4,1,100);
      planes[k].rxn=floor(pilots[k][1]);
    }
  }
  for(int i = 0; i < planes.length; i++){
    planes[i].pos[1]=terrain.heightAt(planes[i].pos[0],planes[i].pos[2])-random(512,2*1024); 
  }
  //addPlane(0,0,0,"mig-29.txt",true);
  //addPlane(0,0,-1000,"mig-29.txt",true);
  //addPlane(0,0,1000,"mig-29.txt",true);
  
  planes[0].bAi=false;
 
  // planes[0].group=0;
  //planes[1].group=2;
  frameRate(45);
  println(inCycle);
  mStart=millis();
  println(mStart);
}
void draw(){
  //
  //lights();
  tap();
  if(keysTapped[ascii('m')]){
  freeLook++;
  if(freeLook>3){
    freeLook=0; 
  }
  }
  if(keysTapped[ascii('n')]){
   bGround = !bGround; 
  }
  if(keysTapped[ascii('e')]){
    lockOn=constrain(lockOn+1,0,planes.length-1); 
  }
  if(keysTapped[ascii('q')]){
    lockOn=constrain(lockOn-1,0,planes.length-1); 
  }
    if(keysTapped[ascii('E')]){
      if(planes[constrain(lockOn+1,0,planes.length-1)].hp>=0)
            lockOn=constrain(lockOn+1,0,planes.length-1);
        while(lockOn<planes.length-1&&planes[lockOn].hp<0)
    lockOn=constrain(lockOn+1,0,planes.length-1); 
  }
  if(keysTapped[ascii('Q')]){
          if(planes[constrain(lockOn-1,0,planes.length-1)].hp>=0)
    lockOn=constrain(lockOn-1,0,planes.length-1);
        while(lockOn>1&&planes[lockOn].hp<0)
    lockOn=constrain(lockOn-1,0,planes.length-1); 
  }
  if(keysTapped[ENTER]){
   setup(); 
  }else if(keysTapped[ascii('l')]){
   bFirst=true;
  setup(); 
  }
      //background(3,238,255);
      background(0);
    //lights();
  fCamera[4] = PI;
  cameraUpdate();
  stroke(0);
  M4 M = new M4();
  M4 M1 = new M4();
  M4 M2 = new M4();
  float[] vector;
  planesUpdate();
  center=new float[3];
  float num=0;
    for(int i = 0; i < planes.length; i ++){
      if(planes[i].hp>=0){
        num++;
        center[0]+=planes[i].pos[0];
        center[1]+=planes[i].pos[1];
        center[2]+=planes[i].pos[2];
      }
    }
    center[0]/=num;
    center[1]/=num;
    center[2]/=num;
  if(freeLook!=2&&freeLook!=3){
  cameraTrack(0,0,-8,150);
  }else{
    cameraTrack(0,0,0,500); 
  }
  columnUpdate();
  drawColumn(35,75,50,50);
    terrain.draw();
    if(terrain.fHeight[0].length>0){
    //drawSky();
    }
  planesDraw();
    fill(255);
  noStroke();
  smokeUpdate();
  fill(0);
  noFill();
  stroke(0);
  ellipse(width-100,100,200,200);
  for(int i = 0; i< planes.length; i++){
    stroke(0);
    fill(colorGroups[planes[i].group][0],colorGroups[planes[i].group][1],colorGroups[planes[i].group][2]);
    vector =cam.MMulti(planes[i].pos[0]-fCamera[0],planes[i].pos[1]-fCamera[1],planes[i].pos[2]-fCamera[2]);
    if(mag(vector[0]*zoom,vector[2]*zoom)<100){
      if(planes[i].hp<0){
       noFill(); 
      }
      ellipse(width-100+vector[0]*zoom,100+vector[2]*zoom,4,4);
      if(i==lockOn){
        stroke(0);
        noFill();
        ellipse(width-100+vector[0]*zoom,100+vector[2]*zoom,8,8);
      }
      if(i==lockOn){
        stroke(255);
        noFill();
        if(vector[2]<0){
          if(lockOn!=0){
        // ellipse(screenX(vector[0]+width/2,vector[i]+height/2,vector[2]+cameraZ),screenY(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),20,20);
          rectMode(CENTER);
          int iSideLength=floor(max(16,2*(screenX(width/2+50,height/2,vector[2]+cameraZ)-width/2)));
          rect(screenX(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),screenY(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),iSideLength,iSideLength);
          }
        }
        noStroke();
        fill(255,0,0,125);
        float theta, theta1;
        theta = atan2(vector[1],-vector[2]);
        theta1=atan2(vector[0],-vector[2]);
        if(limit(theta)<-PI/3){
          rect(width/2,50,width/2,10);
        }
        if(limit(theta)>PI/3){
          rect(width/2,height-50,width/2,10); 
        }
                if(limit(theta1)<-PI/3){
          rect(50,height/2,10,height/2);
        }
        if(limit(theta1)>PI/3){
          rect(width-50,height/2,10,height/2); 
        }
      }
    }
  }
  noFill();
  stroke(0);
  if(reSpawn){
   for(int i = 0; i < planes.length; i++){
     if(planes[i].hp<0){
       planes[i].deaths++;
     planes[i].pos[0]=random(-terrain.tile*4,terrain.tile*4)+center[0];
     planes[i].pos[2]=random(-terrain.tile*4,terrain.tile*4)+center[2];
     planes[i].pos[1]=terrain.heightAt(planes[i].pos[0],planes[i].pos[2])-random(256,1024);
     planes[i].hp=100;
     planes[i].r[0]=planes[i].r[1]=planes[i].r[2]=0;
     }
   } 
  }
    float[] scores = new float[5];
  for(int i = 0; i < scores.length;i++){
    for(int j = 0; j < planes.length; j++){
      if(planes[j].group==i&&planes[j].hp>=0){
        scores[i]++; 
      }
    }
  }
  noStroke();
  fill(255);
  textFont(font,20);
  for(int i = 0; i < scores.length; i++){
    text(scores[i], i*width/(scores.length+1),20); 
  }
    for(int i = 0; i < scores.length; i++){
    text(wins[i], i*width/(wins.length+1),height-20); 
  }
  lockOn=constrain(lockOn,0,planes.length-1);
  text(planes[lockOn].hp,0*width/6,40);
  text(planes[lockOn].group,1*width/6,40);
  text(planes[lockOn].sName,2*width/6,40);
  text(frameRate,0, 60);
  boolean bOver = true;
  int lastAlive = -1;
  for(int i = 0; i < planes.length&&bOver;i++){
    if(planes[i].hp>=0){
      if(lastAlive ==-1){
        lastAlive =  planes[i].group;
      }else{
        if(lastAlive!=planes[i].group){
          bOver = false;
        }
      }
    } 
  }
  textFont(font,12);
  for(int i = 0; i < planes.length; i++){
     text(planes[i].skills[0],0,120+13*i);
     text(planes[i].rxn,45,120+13*i);
     text(planes[i].kills,65,120+13*i);
     text(planes[i].deaths,85,120+13*i);
     text(planes[i].kills*1./max(1,planes[i].deaths),105,120+13*i);
  }
  if(bOver){
    if(lastAlive>=0){
    //wins[lastAlive]++;
    }
  setup(); 
  }
  /*int totalKills=0;
  for(int i = 0; i < wins.length; i++){
    totalKills+=wins[i]; 
  }
  if(totalKills>25||millis()-mStart>pow(10,5)){
    int[] topThree=new int[3];
    for(int i = 0; i < topThree.length; i++){
     topThree[i]=0; 
    }
    int v=0;
    for(int i = 0; i < planes.length; i++){
      if((planes[i].kills/max(planes[i].deaths,1)>planes[topThree[0]].kills/max(planes[topThree[0]].deaths,1))&&planes[i].bAi){
        topThree[0]=i; 
      }
    }
        for(int i = 0; i < planes.length; i++){
      if((planes[i].kills/max(planes[i].deaths,1)>planes[topThree[1]].kills/max(planes[topThree[1]].deaths,1)||topThree[1]==topThree[0])&&planes[i].bAi&&i!=topThree[0]){
        topThree[1]=i; 
      }
    }
        for(int i = 0; i < planes.length; i++){
      if((planes[i].kills/max(planes[i].deaths,1)>planes[topThree[2]].kills/max(planes[topThree[2]].deaths,1)||topThree[2]==topThree[1]||topThree[2]==topThree[0])&&planes[i].bAi&&i!=topThree[0]&&i!=topThree[1]){
        topThree[2]=i; 
      }
    }
    aces[inCycle]=pilots[topThree[0]];
    for(int i = 0; i < pilots.length; i++){
      pilots[i][0]=random(3/4.,4/3.)*planes[topThree[floor(random(3))]].skills[0];
      pilots[i][1]=max(random(3/4.,4/3.)*planes[topThree[floor(random(3))]].rxn,1);
    }
    inCycle++;
    if(inCycle>=aces.length){
    inCycle=0;
    for(int i = 0; i < aces.length ;i++){
      pilots[i]=aces[i]; 
    }
    }
          for(int i = 0; i < wins.length; i++){
        wins[i]=0; 
      }
      setup();

  }*/

}
void cameraUpdate(){
  M4 M1 = new M4();
  cam.MRot(0,0,0);
  M1.MRot(-fCamera[3],0,0);
  cam = MMulti(M1,cam);
  M1.MRot(0,-fCamera[4],0);
  cam = MMulti(M1,cam);
  M1.MRot(0,0,-fCamera[5]);
  cam = MMulti(M1,cam);
  float[] vector = cam.MDerot();
  //cam.MRot(-fCamera[3],-fCamera[4],-fCamera[5]);
}
void cameraTrack(int i, int x, int y, int z){
  M4 M = new M4();
  M4 M1 = new M4();
  M4 M2 = new M4();
  float[] vector;
  float[] vector1;
  //new code starts here
  M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
  M1.MRot(0,PI,0);
  M=MMulti(M,M1);
    M1.MRot(planes[i].rvel[0],-planes[i].rvel[1],planes[i].rvel[2]);
  if(freeLook==1)
  {
    M1.MRot(-column[1]*2,column[0]*2,0);
  }
  M=MMulti(M,M1);
  vector1=M.MDerot();
  if(freeLook==2){
    vector1=new float[3]; 
  }
 
  fCamera[3]=vector1[0];
  fCamera[4]=vector1[1];
  fCamera[5]=vector1[2];
  cameraUpdate();
  //new code ends here
  /*M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
  vector = M.MMulti(0,0,1);
  cam.MRot(0,0,0);
  fCamera[3] = -atan(vector[1]/vector[2]);
  fCamera[4] = 0;
  fCamera[5] = 0;
  cameraUpdate();
  M=MMulti(cam,M);
  vector = M.MMulti(0,0,1);
  fCamera[4] = atan(vector[2]/vector[0])-PI/2;
  cameraUpdate();
  M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
  M=MMulti(cam,M);
  vector = M.MDerot();
  fCamera[5] = limit(-vector[2]);
  cameraUpdate();
  M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
  M=MMulti(cam,M);
  vector = M.MMulti(0,0,1);
  if(vector[2]>0){
    fCamera[4] -=PI;
    cameraUpdate();
    M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
    M=MMulti(cam,M);
  }
  vector = M.MDerot();
  if(abs(vector[2])<3){
    fCamera[5] -=PI;
    cameraUpdate();
    M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
    M=MMulti(cam,M);
  }*/

  M.MRot(fCamera[3],fCamera[4],fCamera[5]);
  vector = M.MMulti(x,y,z);
  fCamera[0] = planes[i].pos[0]+vector[0];
  fCamera[1] = planes[i].pos[1]+vector[1];
  fCamera[2] = planes[i].pos[2]+vector[2];
    if(freeLook==3){
    fCamera[0]=center[0];
    fCamera[1]=center[1];
    fCamera[2]=center[2]+4*1024;
    fCamera[3]=fCamera[4]=fCamera[5]=0;
    M=new M4();
    cameraUpdate();
  }
}
void drawSky(){
     vector[] vCamera=new vector[2];
    vCamera[0]=new vector(fCamera[0],fCamera[1],fCamera[2]);
    vCamera[1]=new vector(fCamera[3],fCamera[4],fCamera[5]);
    float[] fTri=new float[4];
    noStroke();
    textureMode(NORMALIZED);

    vector vNorm;
    vector v1;
    vector v2;
    vector[][] verts = new vector[ terrain.fHeight.length][ terrain.fHeight[0].length];
    for(int i = 0; i < verts.length; i++){
      for(int j = 0; j < verts[i].length; j++){
        verts[i][j]=new vector();
      } 
    }
    for(int i = 0; i < terrain.fHeight.length; i++){
      for(int j = 0; j <  terrain.fHeight.length; j++){
        fTri=cam.MMulti(i* terrain.tile-vCamera[0].x(), -2048-vCamera[0].y(),j* terrain.tile-vCamera[0].z());
        verts[i][j]=new vector(fTri[0]+width/2,fTri[1]+height/2,fTri[2]+cameraZ);
      } 
    }
          if(terrain.fHeight.length>0){
    for(int i = 0; i <  terrain.fHeight.length-1; i++){
      beginShape(TRIANGLE_STRIP);       
      texture(sky); 
      for(int j = 0; j <  terrain.fHeight[0].length;j++){
        vertex(verts[i][j].x(),verts[i][j].y(),verts[i][j].z(),float(i)/ terrain.fHeight.length,float(j)/ terrain.fHeight[0].length);
        vertex(verts[i+1][j].x(),verts[i+1][j].y(),verts[i+1][j].z(),float(i+1)/ terrain.fHeight.length,float(j)/ terrain.fHeight[0].length);
      }
      endShape();
    }
          }
         
}
String[] spRed(String input, char car){
  String[] tOut=split(input,car);
  for(int i = 0; i < tOut.length; i++){
    for(int j = i+1; j <tOut.length&&tOut[i].length()==0;j++){
      tOut[i]=tOut[j];
      tOut[j]="";
    }
  }
  return tOut;
}
String[] spRed(String input){
  String[] tOut=split(input,' ');
  for(int i = 0; i < tOut.length; i++){
    for(int j = i+1; j <tOut.length&&tOut[i].length()==0;j++){
      tOut[i]=tOut[j];
      tOut[j]="";
    }
  }
  return tOut;
}
