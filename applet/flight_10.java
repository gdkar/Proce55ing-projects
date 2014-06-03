import processing.core.*; import processing.opengl.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class flight_10 extends PApplet {
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
public void setup(){
  zoom = 1.01f/256;
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
  cameraZ = ((height/2.0f) / tan(PI*60.0f/360.0f));
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
      planes[i*perGroup+j].skills[0]=min((PI/100),PI/12.5f);
      planes[i*perGroup+j].skills[1]=min((PI/100),PI/12.5f);
      planes[i*perGroup+j].throttle = .5f;
      planes[i*perGroup+j].target = PApplet.parseInt(random(0,perGroup*(groups-1)-1));
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
public void draw(){
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
public void cameraUpdate(){
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
public void cameraTrack(int i, int x, int y, int z){
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


float s = 20;
float m = 10;
float kg = 1;
float N = kg*m/sq(s);
//float g = 9.8*m/sq(s);
float g = 0;
float p = 1.226f*kg/(m*m*m);

class SKA{
  float[][] fVerts;
  int[][] fPolys;
  float[][] fNormals;
  String sName;
  SKA(String sFileName){
    sName = sFileName;
    int fCurRow = 0;
    String[] sFile = loadStrings(sFileName);
    String[] sDataRow = new String[1];
    float[] fDataRow = new float[1];
    fCurRow = find(sFile, "VERTICES",0);
    sDataRow = split(sFile[fCurRow]);
    fVerts = new float[PApplet.parseInt(sDataRow[1])][4];
    fCurRow+=1;
    for(int i = 0; i < fVerts.length; i++){
      fCurRow++;
      sDataRow = split(sFile[fCurRow]);
      fVerts[i][0] = PApplet.parseFloat(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fVerts[i][1] = PApplet.parseFloat(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fVerts[i][2] = PApplet.parseFloat(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "NORMALS",0);
    sDataRow = split(sFile[fCurRow]);
    fNormals = new float[PApplet.parseInt(sDataRow[1])][4];
    fCurRow+=1;
    for(int i = 0; i < fVerts.length; i++){
      fCurRow++;
      sDataRow = split(sFile[fCurRow]);
      fNormals[i][0] = PApplet.parseFloat(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fNormals[i][1] = PApplet.parseFloat(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fNormals[i][2] = PApplet.parseFloat(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "TRIANGLE_SET",0);
    sDataRow = split(sFile[fCurRow]);
    fPolys = new int[PApplet.parseInt(sDataRow[1])][3];
    fCurRow+=1;
    for(int i = 0; i < fPolys.length; i++){
      fCurRow++;
      sDataRow = split(sFile[fCurRow]);
      fPolys[i][0] = PApplet.parseInt(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fPolys[i][1] = PApplet.parseInt(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fPolys[i][2] = PApplet.parseInt(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "WEIGHTS",0);
    sDataRow = split(sFile[fCurRow]);
    int iWeights = PApplet.parseInt(sDataRow[1]);
    for(int i = 0; i < iWeights; i++){
      fCurRow = find(sFile, "WEIGHT_SET",0,fCurRow+1);
      int fSetStart = fCurRow;
      sDataRow = split(sFile[fCurRow]);
      int iSet = PApplet.parseInt(sDataRow[1]);
      for(int j = fSetStart+2; j < fSetStart+iSet+2; j++){
        fCurRow = j;
        sDataRow = split(sFile[fCurRow]);
        fVerts[PApplet.parseInt(sDataRow[1].substring(0,sDataRow[1].length()-1))][3] = i;
      }
    }
    println((sFileName + " Loaded. " + str(millis()) + " Millis"));
    println((str(fPolys.length) + " Polys. " + str(fVerts.length) + " Verts."));
  }
  public void draw(float x, float y, float z, float xr, float yr, float zr){
    M4 M = new M4();
    M4 M1= new M4();
    M4 M2= new M4();

    float[] vector;
    M2.MRot(xr,yr,zr);
    x-=fCamera[0];
    y-=fCamera[1];
    z-=fCamera[2];
    M2=MMulti(cam,M2);
    vector = M2.MDerot();
    xr = vector[0];
    yr = vector[1];
    zr = vector[2];
    vector = cam.MMulti(x,y,z);
    x = vector[0]+width/2;
    y = vector[1]+height/2;
    z = vector[2]+cameraZ;
    M.MRot(xr,yr,zr);
    float[] pos = new float[4];
    beginShape(TRIANGLES);
    for(int i = 0; i < fPolys.length; i++){
      for(int j = 0; j < 3; j++){
        pos = M.MMulti(fVerts[PApplet.parseInt(fPolys[i][j])][0],-fVerts[PApplet.parseInt(fPolys[i][j])][1],fVerts[PApplet.parseInt(fPolys[i][j])][2]);
        pos[0]+=x;
        pos[1]+=y;
        pos[2]+=z;
        vertex(pos[0], pos[1],pos[2]);
      }
    }
    endShape();
  }
}
public int addModel(String fileName){
   for(int i = 0; i < sModels.length; i++){
     if(sModels[i].sName == fileName){
       return i;
     } 
   }
   SKA[] tModels = new SKA[sModels.length+1];
   for(int i = 0; i < sModels.length; i++){
     tModels[i] = sModels[i]; 
   }
   tModels[tModels.length-1] = new SKA(fileName);
   sModels = tModels;
   return(sModels.length-1);
}

class plane{
  boolean bAi=true;
  boolean firing=false;
  int iMode = 1;
  int group = 0;
  float hp=100;
  int target = 0;
  int model;
  String sName;
  int iAm;
  float[] skills = new float[2];
  float[] pos = new float[3];
  float[] vel = new float[3];
  float[] r = new float[3];
  float[] vr = new float[3];
  float[] limits = new float[8];
  float[] controls = new float[3];
  float[] rvel = new float[3];
  float throttle;
  float[][]emiters;
  float[][]impacts;
  float[][]weapons;
  float[] sImpact = new float[6];
  float thrust;
  float mass;
  float[] Cd=new float[3];
  float[]areas=new float[7];
  float speed=0;
  plane(float x, float y, float z,int iam,String fileName,boolean ai){
    bAi=ai;
    iAm = iam;
    pos[0] = x;
    pos[1] = y;
    pos[2] = z;
    String[] sFile = loadStrings(fileName);
    int curRow;
    String[] sRow;
    curRow = find(sFile,"name",0);
    sName = sFile[curRow].substring(5,sFile[curRow].length());
    curRow = find(sFile,"model",0);
    sRow = split(sFile[curRow]);
    model = addModel(sRow[1]);
    curRow = find(sFile,"areas",0);
    sRow = split(sFile[curRow]);
    areas[0] = PApplet.parseFloat(sRow[1]);
    areas[1] = PApplet.parseFloat(sRow[2]);
    areas[2] = PApplet.parseFloat(sRow[3]);
    areas[3] = PApplet.parseFloat(sRow[4]);
    areas[4] = PApplet.parseFloat(sRow[5]);
    areas[5] = PApplet.parseFloat(sRow[6]);
    areas[6] = PApplet.parseFloat(sRow[7]);
    curRow = find(sFile,"thrust",0);
    sRow = split(sFile[curRow]);
    thrust = PApplet.parseFloat(sRow[1]);
    curRow = find(sFile,"mass",0);
    sRow = split(sFile[curRow]);
    mass = PApplet.parseFloat(sRow[1]);
    curRow = find(sFile,"Cd",0);
    sRow = split(sFile[curRow]);
    curRow = find(sFile,"Cd",0);
    sRow = split(sFile[curRow]);
    Cd[0] = PApplet.parseFloat(sRow[1]);
    Cd[1] = PApplet.parseFloat(sRow[2]);
    Cd[2] = PApplet.parseFloat(sRow[3]);
    throttle = 0;
    curRow = find(sFile, "box",0);
    sRow=split(sFile[curRow+1]);
    sImpact = PApplet.parseFloat(sRow);
    curRow = find(sFile, "skills",0);
    sRow=split(sFile[curRow+1]);
    skills = PApplet.parseFloat(sRow);
    curRow = find(sFile, "limits",0);
    sRow=split(sFile[curRow+1]);
    limits = PApplet.parseFloat(sRow);
    curRow = find(sFile, "smokes", 0);
    sRow = split(sFile[curRow]);
    emiters = new float[PApplet.parseInt(sRow[1])][11];
    for(int i = 0; i < emiters.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 11; j++){
        emiters[i][j] = PApplet.parseFloat(sRow[j]);
      } 
    }
    curRow = find(sFile, "impacts", 0);
    sRow = split(sFile[curRow]);
    impacts = new float[PApplet.parseInt(sRow[1])][7];
    for(int i = 0; i < impacts.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 7; j++){
        impacts[i][j] = PApplet.parseFloat(sRow[j]);
      } 
    }
    curRow = find(sFile, "guns", 0);
    sRow = split(sFile[curRow]);
    weapons = new float[PApplet.parseInt(sRow[1])][9];
    for(int i = 0; i < weapons.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 8; j++){
        print(sRow);
        println();
        weapons[i][j] = PApplet.parseFloat(sRow[j]);
      } 
    }
  }
  public void upDate(){
    M4 M = new M4();
    M4 M1 = new M4();
    M4 M2 = new M4();
    for(int i = 0; i < r.length; i++){
      r[i]=limit(r[i]); 
    }

    float[] vector=new float[3];
    for(int i = 0; i < weapons.length; i++){
      weapons[i][8]++; 
    }
    if(hp>=0){
      if(!bAi){   
        M.MRot(-r[0],-r[1],-r[2]);
        vector = M.MMulti(vel[0],vel[1],vel[2]);
        if(keysTapped[ascii('r')]){
          zoom*=1.5f; 
        }
        if(keysTapped[ascii('f')]){
          zoom/=1.5f; 
        }
        if(keysPressed[ascii('a')]||keysPressed[ascii('A')]){
          controls[1] = limits[4]/s ;
        }
        if(keysPressed[ascii('d')]||keysPressed[ascii('D')]){
          controls[1] = limits[5]/s;
        }
        if(keysPressed[UP]){
          controls[0] = limits[2]/s;
        }
        if(keysPressed[DOWN]){
          controls[0] = limits[3]/s;
        }
        if(keysPressed[LEFT]){
          controls[2] = limits[7]/s;
        }
        if(keysPressed[RIGHT]){
          controls[2] = limits[6]/s;
        }
        if(!(keysPressed[ascii('a')]||keysPressed[ascii('A')]||keysPressed[ascii('d')]||keysPressed[ascii('D')])){
          controls[1]=0; 
        }
        if(!(keysPressed[UP]||keysPressed[DOWN])){
          controls[0]=0; 
        }
        if(!(keysPressed[LEFT]||keysPressed[RIGHT])){
          controls[2]=0; 
        }
        if(keysPressed[ascii('w')]){
          throttle=constrain(throttle+.05f,limits[0],limits[1]); 
        }
        if(keysPressed[ascii('s')]){
          throttle=constrain(throttle-.05f,limits[0],limits[1]); 
        }
        if(keysPressed[32]){
          firing=true; 
        }
        else{
          firing=false;
        }
      }
      if(bAi){
        vector=new float[3];
        float range;
        float radialSector=0;
        float rangeSector=0;
        //if(planes[target].hp<0||planes[target].group==group){
        float d = 100000;
        float value;
        for(int i = 0; i < planes.length; i++){
          if(planes[i].hp<0||planes[i].group==group||i==iAm){
            value = d+1; 
          }
          else{
            range = dist(pos[0],pos[1],pos[2],planes[i].pos[0],planes[i].pos[1],planes[i].pos[2])/100;
            value=range;
            boolean teamTarget = false;
            /*for(int j = 0; j < planes.length; j++){
              if(planes[j].group==group&&j!=iAm&&planes[j].target==i){
                value/=2;
              } 
            }*/
            if(planes[planes[i].target].group==group&&planes[i].target!=iAm){
            value/=100;  
            }
            if(value<d){
              d=value;
              target = i; 
            }
          }
        } 
        //}
        for(int i = 0; i < planes.length; i++){
          if(dist(pos[0],pos[1],pos[2],planes[i].pos[0],planes[i].pos[1],planes[i].pos[2])<512&&i!=iAm){
            if(d>dist(pos[0],pos[1],pos[2],planes[i].pos[0],planes[i].pos[1],planes[i].pos[2])){
              target=i;
              d=dist(pos[0],pos[1],pos[2],planes[i].pos[0],planes[i].pos[1],planes[i].pos[2]);
            }
          }
        }
        range = dist(pos[0],pos[1],pos[2],planes[target].pos[0],planes[target].pos[1],planes[target].pos[2]);

        vector = track(planes[target].pos[0],planes[target].pos[1],planes[target].pos[2],planes[target].speed,planes[target].r[0],planes[target].r[1],planes[target].r[2],pos[0],pos[1],pos[2],weapons[0][3]*m/s);

        if(abs(limit(vector[0]-r[0]))<PI/4&&abs(limit(vector[2]-r[0]))<PI/4){
          radialSector = 3;
        }
        if((abs(limit(vector[0]-r[0]))>PI/4||abs(limit(vector[2]-r[0]))>PI/4)&&abs(limit(vector[2]-r[0]))<3*PI/4&&abs(limit(vector[2]-r[0]))<3*PI/4){
          radialSector = 2; 
        }
        if(abs(limit(vector[2]-r[0]))>3*PI/4&&abs(limit(vector[2]-r[0]))>3*PI/4){
          radialSector = 1; 
        }
        M.MRot(vector[0],vector[1],vector[2]);
        //vector = M.MDerot();
        if(range>1536){
          iMode = 1;
        }
        if(range<740){
          iMode=2;
          vector = track(planes[target].pos[0],planes[target].pos[1],planes[target].pos[2],planes[target].speed,planes[target].r[0],planes[target].r[1],planes[target].r[2],pos[0],pos[1],pos[2],1*m/s);
        }
        if(range>2048){
          iMode=3; 
        }
        float[] tPos = new float[3];
        float[] tVec = new float[3];
        float[] temp = new float[3];
        M.MRot(r[0],r[1],r[2]);
        M.MTrans();
        M1.MRot(vector[0],vector[1],vector[2]);
        M1=MMulti(M,M1);
        temp = M1.MMulti(0,0,1);
        tVec = M.MMulti(planes[target].pos[0]-pos[0],planes[target].pos[1]-pos[1],planes[target].pos[2]-pos[2]);
        //tPos[0]=limit(atan2(tVec[1],tVec[2]));
        //tPos[1]=limit(atan2(tVec[2],tVec[0])-PI/2);
        tPos[0]=limit(atan2(temp[1],temp[2]));
        tPos[1]=limit(atan2(temp[2],temp[0])-PI/2);
        firing = false;
        if(abs(tPos[0])<2*skills[0]&&abs(tPos[1])<2*skills[1]&&range<2048&&planes[target].group!=group){
          firing = true; 
        }
        if(planes[target].group==group){
          firing = false; 
        }
        switch (iMode){
        case 0:
          break;
        case 1:
          if(tPos[0]>skills[0]){
            controls[0]=limits[2]/s/2;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=limits[3]/s/2;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=limits[5]/s/2;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=limits[4]/s/2;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
          if(throttle>.25f){
            throttle-=.05f; 
          }
          break;
        case 2:
          if(limit(PI*1.2f*sign(tPos[0])+tPos[0])>skills[0]){
            controls[0]=limits[2]/s;
          }
          if(limit(PI*1.2f*sign(tPos[0])+tPos[0])<-skills[0]){
            controls[0]=limits[3]/s;
          }
          if(!(limit(PI*1.2f*sign(tPos[0])+tPos[0])>skills[0]||limit(PI*1.2f*sign(tPos[0])+tPos[0])<-skills[0])){
            controls[0]=0; 
          }
          if(limit(PI+tPos[1])>skills[1]){
            controls[1]=limits[5]/s;
          }
          if(limit(PI+tPos[1])<-skills[1]){
            controls[1]=limits[4]/s;
          }
          if(!(limit(PI+tPos[1])>skills[1]||limit(PI+tPos[1])<-skills[1])){
            controls[1]=0; 
          }
          if(abs(limit(vector[0]-r[0]))>PI/2&&abs(limit(vector[1]-r[1]))>PI/2){
            if(throttle<.5f){
              throttle+=.05f; 
            }
          }
          else{
            if(throttle>.15f){
              throttle-=.05f; 
            }
          }
          break;
        case 3:
          if(tPos[0]>skills[0]){
            controls[0]=limits[2]/s/4;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=limits[3]/s/4;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=limits[5]/s/4;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=limits[4]/s/4;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
          if(throttle<.75f){
            throttle+=.05f; 
          }
          break;
        }
      }
      throttle = constrain(throttle,limits[0],limits[1]);
      for(int i = 0; i < 3; i++){
        controls[i]=limit(controls[i]);
        controls[i]=constrain(controls[i],limits[2*i+2],limits[2*i+3]);
        if(abs(controls[i]-rvel[i])<=PI/50){
          rvel[i]=controls[i]; 
        }
        if(controls[i]>rvel[i]){
          rvel[i]+=PI/50;
        }
        if(controls[i]<rvel[i]){
          rvel[i]-=PI/50; 
        }
      }
    }
    else{
      firing = false;
      rvel[0]=rvel[1]=rvel[2]=0;
    }

    //M.MRot(rvel[0],rvel[1],rvel[2]);
    M4 tM = new M4();
    M=new M4();
    tM.MRot(rvel[0],0,0);
    M=MMulti(tM,M);
    tM.MRot(0,rvel[1],0);
    M=MMulti(tM,M);
    tM.MRot(0,0,rvel[2]);
    M=MMulti(tM,M);
    M1.MRot(r[0],r[1],r[2]);
    M1 = MMulti(M1,M);
    vector = M1.MDerot();
    r = vector;
    r[0] = limit(r[0]);
    r[1] = limit(r[1]);
    r[2]=limit(r[2]);
    float[] force=new float[3];
    M = new M4();
    M4 deM = new M4();
    M.MRot(r[0],r[1],r[2]);
    deM.MRot(-r[0],-r[1],-r[2]);
    // thrust
    vector = M.MMulti(0,0,throttle*thrust*m/s);
    speed = throttle*thrust*m/s;
    vel[0] = vector[0];
    vel[1] = vector[1];
    vel[2] = vector[2];
    pos[0]+=vel[0];
    pos[1]+=vel[1];
    pos[2]+=vel[2];
    if(firing){
      float[] tvel = new float[3];
      for(int i = 0; i < weapons.length; i++){
        if(weapons[i][8]>weapons[i][6]){
          vector = M.MMulti(weapons[i][0],weapons[i][1],weapons[i][2]);
          tvel = M.MMulti(0,0,weapons[i][3]*m/s);
          newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],vel[0]+tvel[0],vel[1]+tvel[1],vel[2]+tvel[2],weapons[i][4],.0f,0.0f,0.0f,PApplet.parseInt(weapons[i][5]),(weapons[i][7]),iAm);
          weapons[i][8]=0;
        }
      }
    }
    // smoke
    for(int i = 0; i < emiters.length; i++){
      vector = M.MMulti(emiters[i][0],emiters[i][1],emiters[i][2]);
      newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],0,0,0,emiters[i][3],emiters[i][4],emiters[i][5],emiters[i][6],emiters[i][7],emiters[i][8],emiters[i][9],PApplet.parseInt(emiters[i][10])); 
    }
  }
  public void draw(){
    fill(colorGroups[group][0]*hp/100,colorGroups[group][1]*hp/100,colorGroups[group][2]*hp/100);
    sModels[model].draw(pos[0],pos[1],pos[2],r[0],r[1],r[2]); 
  }
}
public void planesUpdate(){
  for(int i = 0; i < planes.length; i++){
    fill(255,255,255);
    planes[i].upDate();
  }
  for(int i = 0; i < planes.length; i++){
    for(int j = i+1; j < planes.length; j++){
      if(cubeCube(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],planes[i].r[0],planes[i].r[1],planes[i].r[2],planes[i].sImpact[3]/2,planes[i].sImpact[4]/2,planes[i].sImpact[5]/2,
      planes[j].pos[0],planes[j].pos[1],planes[j].pos[2],planes[j].r[0],planes[j].r[1],planes[j].r[2],planes[j].sImpact[3]/2,planes[j].sImpact[4]/2,planes[j].sImpact[5]/2)){
        planes[i].hp-=100;
        planes[j].hp-=100; 
      }
    } 
  }
}
public void planesDraw(){
  for(int i = 0; i < planes.length; i++){
    fill(255,255,255);
    noStroke();
    planes[i].draw();
  } 
}
public void addPlane(float x, float y, float z, String fileName, boolean ai){
  plane[] tPlanes = new plane[planes.length+1];
  for(int i = 0; i < planes.length; i++){
    tPlanes[i] = planes[i]; 
  }
  tPlanes[tPlanes.length-1]=new plane(x,y,z,tPlanes.length-1,fileName, ai);
  planes = tPlanes;
}

public boolean circleLine(float x, float y, float r, float x1, float y1, float x2, float y2){
  float m = (y2-y1)/(x2-x1);
  float b = -(m*x2)+y2;
  float a1 = (sq(m)+1);
  float b1 = (2*((m*(x1-m*y1-y))-x));
  float c1 = (sq(x1-m*y1-y)+sq(x)-sq(r));
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
  float[][] verts= new float[3][2];
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
  float m1 = (verts[left][1]-verts[top][1])/(verts[left][0]-verts[top][0]);
  float b1 = -(m1*verts[top][0])+verts[top][1];
  float m2 = (verts[left][1]-verts[bottom][1])/(verts[left][0]-verts[bottom][0]);
  float b2 = -(m2*verts[bottom][0])+verts[bottom][1];
  float m3 = (verts[top][1]-verts[bottom][1])/(verts[top][0]-verts[bottom][0]);
  float b3 = -(m3*verts[bottom][0])+verts[bottom][1];
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
  float m = (y1-y2)/(x1-x2);
  float b = -(m*x1)+y1;
  float m1 = (x1-x2)/(y1-y2);
  float b1 = -(m1*y1)+x1;
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
  float m = (y1-y2)/(x1-x2);
  float b = -(m*x1)+y1;
  float m1 = (x1-x2)/(y1-y2);
  float b1 = -(m1*y1)+x1;
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
  float[] vector;
  M4 m = new M4();
  boolean intersect=false;
  m.MRot(xr,yr,zr);
  vector = m.MMulti(x1-xc,y1-yc,z1-zc);
  x1 = vector[0];
  y1 = vector[1];
  z1 = vector[2];
  vector = m.MMulti(x2-xc,y2-yc,z2-zc);
  x2 = vector[0];
  y2 = vector[1];
  z2 = vector[2];
  if(rectSeg(x1,y1,x2,y2,0,0,xExt,yExt)&&rectSeg(x1,z1,x2,z2,0,0,xExt,zExt)&&rectSeg(z1,y1,z2,y2,0,0,zExt,yExt)){
    intersect = true;
  }
  return intersect;
}

public boolean cubeCube(float x1,float y1,float z1,float xr1,float yr1,float zr1,float xExt1,float yExt1,float zExt1,
float x2,float y2,float z2,float xr2,float yr2,float zr2,float xExt2,float yExt2,float zExt2){
  M4 m = new M4();
  m.MRot(-xr1,-yr1,-zr1);
  float[] vector;
  float[] vector1;
  //y/z, +x plane, cube 1.
  vector = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true;
  }
  vector = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //y/z, -x plane, cube 1.
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //connectors, cube 1
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //cube 2
  m.MRot(-xr2,-yr2,-zr2);
  //y/z, +x plane, cube 1.
  vector = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  //y/z, -x plane, cube 1.
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  //connectors, cube 1
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt2,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5f,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  return false;
}
public boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt,float r){
  M4 m = new M4();
  m.MRot(0,0,-r);
  float[] vector;
  vector = m.MMulti(x-x1,y-y1,0);
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
  M4 m = new M4();
  m.MRot(-xr,-yr,-zr);
  float[] vector;
  vector = m.MMulti(x-x1,y-y1,z-z1);
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
  float[] vector = new float[3];
  float[] tVector;
  if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
    tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
    vector[0]+=tVector[0];
    vector[1]+=tVector[1];
    tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
    vector[1]+=tVector[0];
    vector[2]+=tVector[1];
    tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
    vector[0]+=tVector[0];
    vector[2]+=tVector[1];
    if(vector[0]==0&&vector[1]==0&&vector[2]==0){
      float[] axes = new float[3];
      float tx = x-x1;
      float ty=y-y1;
      float tz=z-z1;
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
      vector=axes;
    }
  }

  return vector;
}

public float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
  float[] vector = new float[3];
  float[] tVector;
  if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
    tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
    vector[0]+=tVector[0];
    vector[1]+=tVector[1];
    tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
    vector[1]+=tVector[0];
    vector[2]+=tVector[1];
    tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
    vector[0]+=tVector[0];
    vector[2]+=tVector[1];
    if(vector[0]==0&&vector[1]==0&&vector[2]==0){
      float[] axes = new float[3];
      float tx = x-x1;
      float ty=y-y1;
      float tz=z-z1;
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
      vector=axes;
    }
  }
  float vMag = mag(vector[0],vector[1],vector[2]);
  vector[0]/=vMag;
  vector[1]/=vMag;
  vector[2]/=vMag;
  return vector;
}

public float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
  float[] vector = new float[3];
  float[][] result = new float[2][3];
  float[] tVector;
  if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
    tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
    vector[0]+=tVector[0];
    vector[1]+=tVector[1];
    tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
    vector[1]+=tVector[0];
    vector[2]+=tVector[1];
    tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
    vector[0]+=tVector[0];
    vector[2]+=tVector[1];
    if(vector[0]==0&&vector[1]==0&&vector[2]==0){
      float[] axes = new float[3];
      float tx = x-x1;
      float ty=y-y1;
      float tz=z-z1;
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
      result[1][0]= x1+(axes[0]*(xExt+r));
      result[1][1]= y1+(axes[1]*(yExt+r));
      result[1][2]= z1+(axes[2]*(zExt+r));
      vector=axes;
    }
  }
  float vMag = mag(vector[0],vector[1],vector[2]);
  vector[0]/=vMag;
  vector[1]/=vMag;
  vector[2]/=vMag;
  result[0]=vector;
  return result;
}

public float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
  M4 M = new M4();
  M4 unM=new M4();
  M.MRot(-xr,-yr,-zr);
  unM.MRot(xr,yr,zr);
  float[] tv=M.MMulti(x-x1,y-y1,z-z1);
  float[] vector = nCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
  vector = unM.MMulti(vector[0],vector[1],vector[2]);
  return vector;
}
public float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
  M4 M = new M4();
  M4 unM=new M4();
  M.MRot(-xr,-yr,-zr);
  unM.MRot(xr,yr,zr);
  float[] tv=M.MMulti(x-x1,y-y1,z-z1);
  float[][] vector = dCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
  vector[0] = unM.MMulti(vector[0][0],vector[0][1],vector[0][2]);
  vector[1]= unM.MMulti(vector[1][0],vector[1][1],vector[1][2]);
  return vector;
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
    float[] vector = M.MMulti(x-x1,y-y1,z-z1);
    if(rectCircle(vector[0],vector[1],r,0,0,xExt,yExt)&&rectCircle(vector[0],vector[2],r,0,0,xExt,zExt)&&rectCircle(vector[1],vector[2],r,0,0,yExt,zExt)){
      return true;
    }
  }
  return false;
}
public float[] linearSolver(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4){
  float[] answer=new float[2];
  float m1 = (y1-y2)/(x1-x2);
  float m2 = (y3-y4)/(x3-x4);
  float b1 = -(m1*x1)+y1;
  float b2 = -(m2*x3)+y3;
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
  if(input!=0){
    return input/abs(input);
  }
  else{
    return 1; 
  }
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
    splitData = split(file[i]);
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
      splitData = split(file[i]);
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

class particle{
  boolean bBullet = false;
  int firedBy = -1;
  float damage;
  float x=0;
  float y=0;
  float z=0;
  float s0=0;
  float qs=0;
  float ls=0;
  float a0=0;
  float la=0;
  float qa=0;
  float xv;
  float yv;
  float zv;
  int c = color(255,255,255);
  int dur=25;
  int frames;
  boolean active = true;  
  particle(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage,int from){
    firedBy=from;
    bBullet = true;
    damage = tdamage;
    x = tx;
    y = ty;
    z = tz;
    s0 = ts0;
    ls = 0;
    a0 = 255;
    la = 0;
    xv = txv;
    yv = tyv;
    zv = tzv;
    c = color(tr,tg,tb);
    dur = tdur; 
    active = true;
  }
  particle(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tls,float ta0,float tla,float tr,float tg,float tb,int tdur){
    bBullet = false;
    x = tx;
    y = ty;
    z = tz;
    s0 = ts0;
    ls = tls;
    a0 = ta0;
    la = tla;
    xv = txv;
    yv = tyv;
    zv = tzv;
    c = color(tr,tg,tb);
    dur = tdur; 
    active = true;
  }
  public void upDate(){

    if(active){

      frames +=1;
      x+=xv*m/s;
      y+=yv*m/s;
      z+=zv*m/s;
      if(frames>dur){
        active = false; 
      }
      float tx = x;
      float ty = y;
      float tz = z;
      float[] vector=new float[4];
      tx-=fCamera[0];
      ty-=fCamera[1];
      tz-=fCamera[2];
      vector = cam.MMulti(tx,ty,tz);
      tx = vector[0]+width/2;
      ty = vector[1]+height/2;
      tz = vector[2]+cameraZ;
      if(tz<cameraZ){
        fill(red(c),green(c),blue(c),a0-(frames*la)-(sq(frames)*qa));
        float r = (s0+(frames*ls)+(sq(frames)*qs));
        float cos30 = cos(PI/6);
        beginShape(TRIANGLES);
        vertex(tx,ty-r,tz);
        vertex(tx+(cos30*r), ty+.5f*r, tz);
        vertex(tx-(cos30*r), ty+.5f*r, tz);
        endShape();
      }
      if(bBullet){
        boolean cont = true;
        M4 M = new M4();
        for(int i = 0; i < planes.length&&cont; i++){
          M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
          for(int j = 0; j < planes[i].impacts.length&&cont; j++){
            vector = M.MMulti(planes[i].impacts[j][0],planes[i].impacts[j][1],planes[i].impacts[j][2]);
            if(cubeSphere(x,y,z,s0,planes[i].pos[0]+vector[0],planes[i].pos[1]+vector[1],planes[i].pos[2]+vector[2],planes[i].impacts[j][3]/2,
            planes[i].impacts[j][4]/2,planes[i].impacts[j][5]/2,planes[i].r[0],planes[i].r[1],planes[i].r[2])||
              (frames>0&&cubeSeg(x,y,z,x-xv*m/s,y-yv*m/s,z-zv*m/s,planes[i].pos[0]+vector[0],planes[i].pos[1]+vector[1],planes[i].pos[2]+vector[2]
              ,planes[i].impacts[j][3]/2, planes[i].impacts[j][4]/2,planes[i].impacts[j][5]/2,planes[i].r[0],planes[i].r[1],planes[i].r[2]))){
              planes[i].hp-=damage*planes[i].impacts[j][6];
              cont = false;
              for(int k = 0; k < 4; k++){
                for(int l = 0; l < 4; l++){
                  newSmoke(x,y,z,100*m/s*cos(k*TWO_PI/4)*cos(l*TWO_PI/4),100*m/s*cos(k*TWO_PI/4)*sin(l*TWO_PI/4),100*m/s*sin(k*TWO_PI/4),5,.05f,255,2,255,125,0,20);
                }
              }
              for(int k = 0; k < 4; k++){
                for(int l = 0; l < 4; l++){
                  newSmoke(x,y,z,75*m/s*cos(k*TWO_PI/4)*cos(l*TWO_PI/4),75*m/s*cos(k*TWO_PI/4)*sin(l*TWO_PI/4),75*m/s*sin(k*TWO_PI/4),5,.5f,125,2,125,125,125,20);
                }
              }
              if(planes[i].hp+damage*planes[i].impacts[j][6]>=0&&planes[i].hp<0){
                for(int k = 0; k < 10; k++){
                  for(int l = 0; l < 10; l++){
                    newSmoke(x,y,z,150*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),150*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),150*m/s*sin(k*TWO_PI/10),5,.05f,255,2,255,125,0,75);
                  }
                }
                for(int k = 0; k < 10; k++){
                  for(int l = 0; l < 10; l++){
                    newSmoke(x,y,z,75*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),75*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),75*m/s*sin(k*TWO_PI/10),5,.5f,125,2,125,125,125,75);
                  }
                }
              }
              active=false;
            }
          }
        }
      }
    }
  }
}
public void newSmoke(float tx,float ty,float tz,float txv,float tyv,float tzv,float ts0,float tls,float ta0,float tla,float tr,float tg,float tb,int tdur){
  boolean already = false;
  for(int i = 0; i < smoke.length; i++){
    if(smoke[i].active == false){
      smoke[i] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tls,ta0,tla,tr,tg,tb,tdur);
      already = true;
      i = smoke.length;
    } 
  }
  if(!already){
    particle[] tSmoke= new particle[smoke.length+1];
    for(int i = 0; i < smoke.length; i++){
      tSmoke[i] = smoke[i]; 
    }
    tSmoke[tSmoke.length-1] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tls,ta0,tla,tr,tg,tb,tdur);
    smoke = tSmoke;
  }
}
public void newSmoke(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage, int from){
  boolean already = false;
  for(int i = 0; i < smoke.length; i++){
    if(smoke[i].active == false){
      smoke[i] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage,from);
      already = true;
      i = smoke.length;
    } 
  }
  if(!already){
    particle[] tSmoke= new particle[smoke.length+1];
    for(int i = 0; i < smoke.length; i++){
      tSmoke[i] = smoke[i]; 
    }
    tSmoke[tSmoke.length-1] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage,from);
    smoke = tSmoke;
  }
}
public void smokeUpdate(){
  for(int i = 0; i < smoke.length; i++){
    smoke[i].upDate();
  } 
}

class land{
  float[][] fTiles;
  float r;
  land(int x, int y, int tr){
    float translation = millis();
    fTiles = new float[x][y];
    r = tr;
    float lowest = 1000000;
    for(int i = 0; i <fTiles.length; i++){
      for(int j = 0; j < fTiles[0].length; j++){
        fTiles[i][j] = noise(i*.05f+translation,j*.05f)*(r*32);
        if(fTiles[i][j]<lowest){
          lowest = fTiles[i][j];
        }
      }
    }
    for(int i = 0; i < fTiles.length;i++){
      for(int j = 0; j < fTiles[0].length; j++){
        fTiles[i][j]-=lowest;
      } 
    }
  }
  public void draw(){
    noStroke();
    fill(59);
    beginShape(TRIANGLES);
    float[][] verts = new float[4][4];
    for(int i = 0; i < fTiles.length-1; i++){
      for(int j = 0; j < fTiles[0].length-1; j++){
        verts[0] = cam.MMulti(i*r-fCamera[0],fTiles[i][j]-fCamera[1],j*r-fCamera[2]);
        verts[1] = cam.MMulti((i+1)*r-fCamera[0],fTiles[i+1][j]-fCamera[1],j*r-fCamera[2]);
        verts[2] = cam.MMulti((i+1)*r-fCamera[0],fTiles[i+1][j+1]-fCamera[1],(j+1)*r-fCamera[2]);
        verts[3] = cam.MMulti(i*r-fCamera[0],fTiles[i][j+1]-fCamera[1],(j+1)*r-fCamera[2]);
        vertex(verts[0][0],verts[0][1],verts[0][2]);
        vertex(verts[1][0],verts[1][1],verts[1][2]);
        vertex(verts[2][0],verts[2][1],verts[2][2]);
        vertex(verts[0][0],verts[0][1],verts[0][2]);
        vertex(verts[3][0],verts[3][1],verts[3][2]);
        vertex(verts[2][0],verts[2][1],verts[2][2]);
      } 
    }
    endShape();
  }
  public boolean impact(float x, float y, float z){
    int[] which = new int[2];
    which[0]=round(x/r);
    which[1]=round(z/r);
    if(which[0]*r>x){
      which[0]--; 
    }
    if(which[1]*r>z){
      which[1]--; 
    }
    if(which[0]<0)
      which[0]=0;
    if(which[1]<0)
      which[1]=0;
    float depth = lerp(fTiles[which[0]][which[1]],fTiles[which[0]+1][which[1]],(x-which[0]*r)/r)+lerp(fTiles[which[0]][which[1]],fTiles[which[0]][which[1]+1],(z-which[1]*r)/r)-fTiles[which[0]][which[1]];
    return(y>depth);
  }
  public float gLevel(float x, float z){
    int[] which = new int[2];
    which[0]=round(x/r);
    which[1]=round(z/r);
    if(which[0]*r>x){
      which[0]--; 
    }
    if(which[1]*r>z){
      which[1]--; 
    }
    if(which[0]<0)
      which[0]=0;
    if(which[1]<0)
      which[1]=0;
    float depth = lerp(fTiles[which[0]][which[1]],fTiles[which[0]+1][which[1]],(x-which[0]*r)/r)+lerp(fTiles[which[0]][which[1]],fTiles[which[0]][which[1]+1],(z-which[1]*r)/r)-fTiles[which[0]][which[1]];
    return(depth);
  }
}

public float track(float x1,float y1,float v1,float r1,float x2,float y2,float v2){
  float theta;
  theta = limit((PI)+atan2((y1-y2),(x1-x2)));
  if(v1<v2){
    float theta1 = asin((v1/v2)*(sin(r1-theta)));
    return((PI-theta1)+theta);
  }

  return(limit(PI+theta));
}

public float[] track(float x1, float y1, float z1, float v1, float xr1, float yr1, float zr1, float x2, float y2, float z2, float v2){
  float[] thetaFinal = new float[3];
  float[] fT = new float[4];
  float[] vector;
  float[] de = new float[3];
  float theta;
  fT[0] = x1-x2;
  fT[1] = y1-y2;
  fT[2] = z1-z2;
  M4 M= new M4();
  M4 dem = new M4();
  M4 r = new M4();
  r.MRot(xr1,yr1,zr1);
  theta = limit(atan2(fT[2],fT[0]));
  de[1] = theta;
  M.MRot(0,-theta,0);
  r = MMulti(M,r);
  fT = M.MMulti(fT[0],fT[1],fT[2]);
  theta = limit(atan2(fT[1],fT[0]));
  de[2] = theta;
  M.MRot(0,0,-theta);
  r = MMulti(M,r);
  fT = M.MMulti(fT[0],fT[1],fT[2]);
  vector = r.MMulti(0,0,1);
  theta = limit(PI-atan2(vector[1],vector[2]));
  de[0] = theta;
  M.MRot(-theta,0,0);
  r = MMulti(M,r);
  vector = r.MMulti(0,0,1);
  theta = limit(atan2(vector[2],vector[0]));
  float fZ = vector[2]*v1;
  float fX = vector[0]*v1;
  float theta1 = 0;
  if(v1<v2){
    theta1 = PI-asin(fZ/v2);
    if(fT[0]>0){
      theta1 = PI-theta1;
    }

    r.MRot(0,limit(theta1-PI/2),0);
    dem.MRot(de[0],0,0);
    r = MMulti(dem,r);
    dem.MRot(0,0,de[2]);
    r = MMulti(dem,r);
    dem.MRot(0,de[1],0);
    r = MMulti(dem,r);
    thetaFinal = r.MDerot();
  }
  else{
    r.MRot(0,limit(-PI/2*sign(fT[0])),0);
    dem.MRot(de[0],0,0);
    r = MMulti(dem,r);
    dem.MRot(0,0,de[2]);
    r = MMulti(dem,r);
    dem.MRot(0,de[1],0);
    r = MMulti(dem,r);
    thetaFinal = r.MDerot();
  }
  for(int i = 0; i < thetaFinal.length; i++){
    thetaFinal[i]=limit(thetaFinal[i]); 
  }
  return thetaFinal;
}
/*float[] track(float x1, float y1, float z1, float v1, float xr1, float yr1, float zr1, float x2, float y2, float z2, float v2,boolean teal){
  float[] thetaFinal=new float[3];
  float[] tPos = new float[3];
  float[] theta = new float[3];
  M4 M = new M4();
  M4 deM=new M4();
  M4 M2 =new M4();
    M4 M = new M4();
  M4 M1 = new M4();
  float[] pos = new float[3];
  M.MRot(atan((y1-y2)/(x1-x2)),0,0);
  M2.MRot(xr1,yr1,zr1);
  M2=MMulti(M,M2);
  theta = M2.MDerot();
  tPos=M.MMulti(x1-x2,y1-y2,z1-z2);
  
  deM=M.MTrans();
  
}*/


class vector{
  float x=0;
  float y=0;
  float z=0;
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
    M4 M=new M4();
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
  public vector vRot(float xc, float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vRot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  public vector vUnrot(float xr,float yr, float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M4 M=new M4();
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
static public void main(String args[]) {   PApplet.main(new String[] { "flight_10" });}}