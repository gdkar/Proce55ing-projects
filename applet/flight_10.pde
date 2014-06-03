import processing.opengl.*;
float[] wins = new float[5];
float[] pr = new float[3];
float[] fCamera = new float[6];
float zoom;
float[][] colorGroups = new float[5][3];
float cameraZ;
float pSpeed=0;
int lockOn = 0;
land terrain;
M4 cam = new M4();
SKA[] sModels = new SKA[0];
particle[] smoke = new particle[1];
plane[] planes = new plane[0];
PFont font;
void setup(){
  zoom = 1.01/256;
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

  planes=new plane[0];
  size(640,480,P3D);
  smoke[0]=new particle(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  background(3,238,255); 
  cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  int groups = 3;
  int perGroup = 2;
  for(int i = 0; i <groups; i++){
    for(int j = 0; j < perGroup; j++){
      //if(0==0){
        if(0!=0){
      addPlane((cos(i*TWO_PI/groups)*1024+cos(PI/2+j*TWO_PI/perGroup)*256)*m,random(-512,512)*m,(sin(i*TWO_PI/groups)*1024+sin(PI/2+j*TWO_PI/perGroup)*256)*m,"mig-21.txt",true);
      }
      else{
      addPlane((cos(i*TWO_PI/groups)*1024+cos(PI/2+j*TWO_PI/perGroup)*256)*m,random(-512,512)*m,(sin(i*TWO_PI/groups)*1024+sin(PI/2+j*TWO_PI/perGroup)*256)*m,"mig-29.txt",true);
      }
      planes[i*perGroup+j].group = i;
      planes[i*perGroup+j].skills[0]=min((PI/100),PI/12.5);
      planes[i*perGroup+j].skills[1]=min((PI/100),PI/12.5);
      planes[i*perGroup+j].throttle = .5;
      planes[i*perGroup+j].target = int(random(0,perGroup*(groups-1)-1));
      //planes[i*perGroup+j].r[1]=PI/2+atan2(planes[i*perGroup+j].pos[2],planes[i*perGroup+j].pos[0]);
      planes[i*perGroup+j].r[1]=random(TWO_PI);
    }
  }

  //addPlane(0,0,-1000,"mig-29.txt",true);
  //addPlane(0,0,1000,"mig-29.txt",true);
  planes[0].bAi=false;
  // planes[0].group=0;
  //planes[1].group=2;
}
void draw(){
  println(frameRate);
  tap();
  if(keysTapped[ascii('e')]){
    lockOn=constrain(lockOn+1,0,planes.length-1); 
  }
  if(keysTapped[ascii('q')]){
    lockOn=constrain(lockOn-1,0,planes.length-1); 
  }
  if(keysTapped[ENTER]){
   setup(); 
  }
  background(3,238,255);
    lights();
  fCamera[4] = PI;
  cameraUpdate();
  stroke(0);
  M4 M = new M4();
  M4 M1 = new M4();
  M4 M2 = new M4();
  float[] vector;
  planesUpdate();
  cameraTrack(0,0,-25,200);
  columnUpdate();
  drawColumn(35,75,50,50);
  planesDraw();
  fill(9,77,0);
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
        stroke(0);
        noFill();
        if(vector[2]<0){
          //ellipse(screenX(vector[0]+width/2,vector[i]+height/2,vector[2]+cameraZ),screenY(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),20,20);
          rectMode(CENTER);
          rect(screenX(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),screenY(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),30,30);
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
    float[] scores = new float[5];
  for(int i = 0; i < scores.length;i++){
    for(int j = 0; j < planes.length; j++){
      if(planes[j].group==i&&planes[j].hp>=0){
        scores[i]++; 
      }
    }
  }
  noStroke();
  fill(0);
  for(int i = 0; i < scores.length; i++){
    text(scores[i], i*width/(scores.length+1),20); 
  }
    for(int i = 0; i < scores.length; i++){
    text(wins[i], i*width/(wins.length+1),height-20); 
  }
  text(planes[lockOn].hp,0*width/6,40);
  text(planes[lockOn].group,1*width/6,40);
  text(planes[lockOn].sName,2*width/6,40);
  textSize(12);
  text(frameRate,0,height-40);
  textSize(20);
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
  if(bOver){
    if(lastAlive>=0){
    wins[lastAlive]++;
    }
   setup(); 
  }
  
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
  //cam.MRot(-fCamera[3],-fCamera[4],-fCamera[5]);
}
void cameraTrack(int i, int x, int y, int z){
  M4 M = new M4();
  M4 M1 = new M4();
  M4 M2 = new M4();
  float[] vector;
  M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
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
  }
  M.MRot(fCamera[3],fCamera[4],fCamera[5]);
  vector = M.MMulti(x,y,z);
  fCamera[0] = planes[i].pos[0]+vector[0];
  fCamera[1] = planes[i].pos[1]+vector[1];
  fCamera[2] = planes[i].pos[2]+vector[2];
}
