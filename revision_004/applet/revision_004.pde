vector vPos = new vector(0,0,256);
vector vRot = new vector();
vector sun = new vector(-pow(2,16),0,0);
vector vOrigin = new vector();
M4 cam = new M4();
//import processing.opengl.*;
float cameraZ;
PFont font;
SKA[] sModels = new SKA[0];
int mig;
particle[] smoke = new particle[0];
float thrust=-993000;
plane pMig = new plane();
vector vNull = new vector(0,0,0);
void setup(){
  //size(640,480,OPENGL);
  size(640,480,P3D);
  //size(640,480,OPENGL);
  render = createGraphics(width,height,P3D);
  float fov = PI/3.0;
  cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(fov, float(width)/float(height), 
  cameraZ/10.0, cameraZ*100.0);
  font = loadFont("ArialNarrow-48.vlw");
  pMig = new plane(vNull,new QUAT(),vNull,2500,500,new vector(9,24,.5),500000, "mig-3_inv_tex_1.am","mig-3_tex.png");
  pMig.p.z(-512);
  vOrigin=new vector(width/2,height/2,cameraZ);
  //pMig.pVel.z(-10);
  // pMig.force.z(-10);
  pMig.force.y(9.8);
  smoke = new particle[0];
}
void draw(){
  //lights();
  tap();
  columnUpdate();
  if(keysPressed[ascii('w')])
    thrust-=100;
  if(keysPressed[ascii('s')])
    thrust+=100;
  if(keysPressed[UP]){
    pMig.addForcer(new vector(0,500*constrain(pMig.airFlow/30,-2,3),0),new vector(0,-2,43));
  }
  if(keysPressed[DOWN]){
    pMig.addForcer(new vector(0,-500*constrain(pMig.airFlow/30,-2,3),0),new vector(0,-2,43));
  }
  if(keysPressed[RIGHT]){
    pMig.addForcer(new vector(0,250*constrain(pMig.airFlow/30,-2,3),0),new vector(-50,0,0));
    pMig.addForcer(new vector(0,-250*constrain(pMig.airFlow/30,-2,3),0),new vector(50,0,0));
  }
  if(keysPressed[LEFT]){
    pMig.addForcer(new vector(0,250*constrain(pMig.airFlow/30,-2,3),0),new vector(50,0,0));
    pMig.addForcer(new vector(0,-250*constrain(pMig.airFlow/30,-2,3),0),new vector(-50,0,0));
  }
  if(keysPressed[ascii('d')]){
    pMig.addForcer(new vector(500*constrain(pMig.airFlow/30,-2,3),0,0),new vector(0,2,43));
  }
  if(keysPressed[ascii('a')]){
    pMig.addForcer(new vector(-500*constrain(pMig.airFlow/30,-2,3),0,0),new vector(0,2,43));
  }
  if(keysTapped[ENTER]){
    setup();
  }
  if(keysPressed[ascii('e')]){
   pMig.rVel=new QUAT(pMig.rVel.v,0); 
  }
  thrust=constrain(thrust,-20000,0);
  //pMig.force=new vector(0,9.8*pMig.fM,0);
  //pMig.force=pMig.force.vPlus(new vector(0,0,thrust).vMRot(pMig.r));
  pMig.addForcer(new vector(0,0,thrust),new vector(0,0,25));
  //pMig.pVel.vPrint();
  cam.MRot(vRot.x(),vRot.y(),vRot.z());
  background(128);
  fill(255);
  noStroke();
  pMig.upDate();
  //vPos=pMig.p.vPlus(new vector(0,0,128));
  //vRot.y(atan2(pMig.pVel.z(),pMig.pVel.x())+PI/2);
  float[] fTemp;
  M4 mRot=new M4(pMig.r.v,pMig.r.w);
  fTemp = mRot.MMulti(0,0,1);
  vRot.y(-atan2(fTemp[0],fTemp[2]));
  vector tVec = new vector(0,0,512);
  vPos=pMig.p.vPlus(tVec.vMRot(vRot));
  cam.MRot(-vRot.x(),-vRot.y(),-vRot.z());
  pMig.draw();
      drawColumn(width-100,100,100,100);
  fill(0);
  textFont(font,16);
  text(frameRate,16,16);
  text(pMig.pVel.vMag(),16,36);
  text(thrust,16,56);
  noStroke();
  smokeUpdate();
}

class body{
  public QUAT r = new QUAT();
  public vector p = new vector();
  public QUAT rVel = new QUAT();
  public vector pVel = new vector();
  public vector torque = new vector();
  public vector force = new vector();
  public float fMoment = 0;
  public float fM = 0;
  public vector areas;
  public float rAreas;
  public body(){
    M4 r = new M4();
    p = new vector();
    rVel = new QUAT();
    pVel = new vector();
    torque = new vector();
    force = new vector();
    fMoment = 0;
    fM = 0;
    areas = new vector();
    rAreas = 0;
  }
}

class plane extends body{
  int iModel;
  float airFlow=0;
  PImage tex;
  plane(){
  }
  plane(vector vp, QUAT vr, vector vv, float m, float moment,vector vAreas,float fRAreas,String modelName,String texName){
    r = vr;
    p = new vector(vp.x(),vp.y(),vp.z());
    pVel = new vector(vv.x(),vv.y(),vv.z());
    fM = m;
    fMoment = moment;
    iModel = addModel(modelName);
    tex = loadImage(texName);
    areas = vAreas;
    rAreas = fRAreas;
  }
  void upDate(){
    force=force.vPlus(g.vTimes(fM));
    torque=torque.vTimes(1/fMoment*(1/s));
    rVel.QPrint();
          QUAT qRot = new QUAT(torque,torque.vMag());
    if(torque.vMag()!=0){
      rVel=rVel.QMulti(qRot);
    }
    qRot.QPrint();
    rVel.QPrint();
    //rVel.normalize();
    torque=new vector();
    //mRot.MRot(rVel.x(),rVel.y(),rVel.z());
    //pVel=pVel.vPlus(force.vTimes(1/fM));
    vector x1= new vector(1,0,0);
    vector y1 = new vector(0,1,0);
    vector z1 = new vector(0,0,1);
    float tV,tF;
    vector vFinal=new vector();
    M4 mRot=new M4(r.v,r.w);
    x1=x1.vMRot(mRot);
    y1=y1.vMRot(mRot);
    z1=z1.vMRot(mRot);
    airFlow=-pVel.vMagAlong(z1);
    if(pVel.vMagAlong(z1)<-20){
      if(atan2(-pVel.vMagAlong(z1),abs(pVel.vMagAlong(x1)))>PI/3){
        float theta = atan2(pVel.vMagAlong(y1),-pVel.vMagAlong(z1));
        if(PI/3>theta&&-PI/3<theta){
          vector vF = new vector(0,-(theta)/(PI/4)*sq((pVel.vMinus(pVel.vAlong(x1))).vMag())/(400)*2500*9.8,0);
          vF=vF.vMRot(mRot);
          force=force.vPlus(vF);
          println("LIFT");
        }
      }
    }
    float k=0;
    float c;
    //linear drag
    k = areas.x()*pAir*2/fM;
    pVel=pVel.vPlus(force.vTimes(1/fM*(1/s)));
    tV=(pVel.vMagAlong(x1));
    //tF=-(force.vAlong(x1)).vMag();
    vFinal=vFinal.vPlus(x1.vTimes(1/((sign(tV)*k)*(1/s)+(1/tV))));
    k = areas.y()*pAir*2/fM;
    tV=(pVel.vMagAlong(y1));
    //tF=-(force.vAlong(y1)).vMag();
    vFinal=vFinal.vPlus(y1.vTimes(1/((sign(tV)*k)*(1/s)+(1/tV))));
    k = areas.z()*pAir*2/fM;
    tV=(pVel.vMagAlong(z1));
    //tF=-(force.vAlong(z1)).vMag();
    //println(tF);
    vFinal=vFinal.vPlus(z1.vTimes(1/((sign(tV)*k)*(1/s)+(1/tV))));
    //vFinal.z(0);
    //vFinal=vFinal.vMRot(r.x(),r.y(),r.z());
    pVel=vFinal;
    p=p.vPlus(pVel.vTimes(m/s));

    //-----------------||
    // rotational drag ||
    //-----------------||

    //vector vMRot = new vector();
    //M4 inv = new M4();
    //inv=r;
    //inv.MTrans();
    //inv = MMulti(inv,mRot);
    //tFRot = inv.MDerot();
    //vMRot=rVel.vMRot(r);
    //vMRot=new vector(tFRot[0],tFRot[1],tFRot[2]);
    k = rAreas*pAir*2/fMoment;
    println(k);
    tV = (acos(rVel.w)*2);
    println(tV);
    println(rVel.v.vMag());
    if(rVel.v.vMag()!=0)
    rVel=new QUAT(rVel.v.vNormalize(),((1/((sign(tV)*k)*(1/s)+(1/tV)))));
    //rVel=new QUAT(rVel.v,((1/((sign(tV)*k)*(1/s)+(1/tV)))));
    //rVel.w=(cos(1/((sign(tV)*k)*(1/s)+(1/tV))))*sin(tV)/cos((1/((sign(tV)*k)*(1/s)+(1/tV))));
    rVel.normalize();
    //mRot=MMulti(inv,mRot);
    //
    r=rVel.QMulti(r);
    mRot=new M4(r.v,r.w);
    vFinal = new vector(0,0,50);
    vFinal=vFinal.vMRot(mRot);
    vFinal=vFinal.vPlus(p);
    newSmoke(vFinal.x(),vFinal.y(),vFinal.z(),0,0,0,10,0,255,0,255,255,255,100);
    force=new vector();
    torque = new vector();
  }
  void draw(){
    M4 mRot=new M4(r.v,r.w);
    sModels[iModel].draw(p.x(),p.y(),p.z(),mRot,tex);
  }
  void draw(float x, float y, float z){
    M4 mRot=new M4(r.v,r.w);
    sModels[iModel].draw(p.x()+x,p.y()+y,p.z()+z,mRot,tex);
  }
  void addForce(vector nForce, vector pos){
    p=p.vTimes(1/m);
    force=force.vPlus(force);
    nForce=nForce.vMinus(nForce.vAlong(pos));
    torque=torque.vPlus(nForce.vCross(pos));
  }
  void addForcer(vector nForce, vector pos){
    M4 mRot=new M4(r.v,r.w);
    nForce=nForce.vMRot(mRot);
    pos=pos.vMRot(mRot);
    pos=pos.vTimes(1/m);
    force=force.vPlus(nForce);
    nForce=nForce.vMinus(nForce.vAlong(pos));
    torque=torque.vPlus(nForce.vCross(pos));
  }
}
