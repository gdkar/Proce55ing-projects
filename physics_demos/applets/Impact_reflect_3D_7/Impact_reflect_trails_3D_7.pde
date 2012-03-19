dot[] dots = new dot[0];
pad[] pads = new pad[0];
PFont font;
void setup(){
  font = loadFont("ArialNarrow-20.vlw");
  dots=new dot[500];
  pads=new pad[4];
  size(400,400,P3D);
  sphereDetail(0);
  int x = int(sqrt(dots.length));
  while(x*x>=dots.length){
    x-=1;
  }
  M4 M = new M4();
  pads[0]=new pad(width*.125,height-width/8*sqrt(2),-width/2,width/3*sqrt(2),40,width,0,0,PI/4,.9);
  pads[1]=new pad(width-(width*.125),height-width/8*sqrt(2),-width/2,width/3*sqrt(2),40,width,0,0,-PI/4,.9);
  pads[2]= new pad(width/2,height,-width/2,width/2,40,width,0,0,0,.9);
  pads[3]=new pad(0,height*3/8,-width/2,40,height*6/8,width,0,0,0,.9);
  float[] vert;
  for(int i = 0; i < 10; i++){
    for(int j = 0; j <10; j++){
      for(int k = 0; k < 5; k++){
        dots[i*50+j*5+k] = new dot(width/2+(i-5)*20,j*20,-width/2-(k-2.5)*20+10*(j%2),0,0,0,10,1,1,color(255,(k)*255/5,0));
      }
    }

  }

  //for(int i = 0; i < dots.length; i++){
  //  dots[i]= new dot(width/dots.length*i,height/2,-width/2,0,0,0,5,5,1);
  // }
  //dots[0].x=0;
  //dots[0].y=height/2;
  //dots[0].z=-width/2;
  //dots[0].m=500;
  //dots[0].xv=20;
  //dots[0].c=color(0,255,0);
  //dots[0].yv=10;
  ellipseMode(CENTER);
  rectMode(CENTER);
  background(0);
}
void draw(){
  textFont(font,20);
  tap();
  if(keysPressed[32]){
    setup(); 
  }
  if(keysTapped[ENTER]){
    spawnDot(width/2,height/2,width/2,20*((mouseX-width/2+.1)/(width/2)),20*((mouseY-height/2+.1)/(width/2)),-20,10,500,1,color(0,255,0));
  }
  //float eK = 0;
  //for(int i = 0; i < dots.length; i++){
  //  eK+=(sq(dots[i].xv)+sq(dots[i].yv)+sq(dots[i].zv))*dots[i].m*.5;
  //}
  //println(eK);
  // background(204);
  background(0,8);
  fill(255);
  text(frameRate,(width/5)*4,20);
  //fill(0,0,0,8);
  //rect(width/2,height/2,width,height);
  fill(255,0,0);
  stroke(0);
  noStroke();
  float w = width/2;
  float h = height/2;
  float d = 0;
  dotsUpdate();
  fill(0,0,255);
  stroke(0);
  for(int i =0; i < pads.length; i++){
    pads[i].draw(); 
  }
  noStroke();
  for(int i = 0; i < dots.length; i++){
    dots[i].upDate();
    dots[i].draw();
    fill(255,255,255); 
  }
}
float[] impact (float m1, float m2, float x1, float x2, float k1, float k2){
  float k = k1*k2;
  float A = m1*x1+m2*x2;
  float B = (m1*x1*x1+m2*x2*x2)*k;
  float a = m2*((m2/m1)+1);
  float b = (-2*A*m2)/m1;
  float c = (A*A/m1)-(B);
  float r1,r2;
  float v1,v2;
  float[] result = new float[2];
  if(((b*b)-4*a*c)>=0){
    r1 = (-b+sqrt((b*b)-4*a*c))/(2*a);
    r2 = (-b-sqrt((b*b)-4*a*c))/(2*a);
  }
  else{
    r1=r2=(-b/(2*a));
  }
  v1=(A-m2*r1)/m1;
  v2=(A-m2*r2)/m1;
  if(x2>x1){
    result[0] = v2;
    result[1] = r2; 
  }
  else{
    result[0] = v1;
    result[1] = r1; 
  }
  return result;
}
class pad{
  float x,y,z,xExt,yExt,zExt,xr,yr,zr,k;
  pad(float x1,float y1,float z1,float xExt1,float yExt1,float zExt1,float xr1,float yr1,float zr1,float k1){
    x=x1;
    y=y1;
    z=z1;
    xExt=xExt1;
    yExt=yExt1;
    zExt=zExt1;
    xr=xr1;
    yr=yr1;
    zr=zr1; 
    k=k1;
  }
  void draw(){
    translate(x,y,z);
    rotateX(xr);
    rotateY(yr);
    rotateZ(zr);
    box(xExt,yExt,zExt);
    rotateZ(-zr);
    rotateY(-yr);
    rotateX(-xr);
    translate(-x,-y,-z); 
  }
}
class dot{
  float x,y,z,xv,yv,zv,r,m,k,fxv,fyv,fzv,fx,fy,fz;
  float sin15 = sin(radians(15));
  float cos15 = cos(radians(15));
  float cameraZ = (height/2.0) / tan(PI * 60 / 360.0);
  boolean active = true;
  color c=color(255);
  dot(float x1, float y1,float z1, float xv1, float yv1,float zv1, float r1, float m1, float k1){
    active = true;
    x=x1;
    y=y1;
    z=z1;
    xv=xv1;
    yv=yv1;
    zv=zv1;
    r=r1;
    m = m1;
    k = k1;
  }
  dot(float x1, float y1,float z1, float xv1, float yv1,float zv1, float r1, float m1, float k1,color c1){
    active = true;
    x=x1;
    y=y1;
    z=z1;
    xv=xv1;
    yv=yv1;
    zv=zv1;
    r=r1;
    m = m1;
    k = k1;
    c=c1;
  } 
  void upDate(){
    xv+=fxv;
    yv+=fyv;
    zv+=fzv;
    fxv=0;
    fyv=0;
    fzv=0;
    x+=xv;
    y+=yv;
    z+=zv;
    /*
    if((x>width*.75-r&&xv>=0)||(x<width*.25+r&&xv<=0)){
     xv*=-1;
     }
     if((y>height-r&&yv>=0)||(y<r&&yv<=0)){
     yv*=-1;
     }
     
     if(y<height-r){
     yv+=.5; 
     }
     if((z>r&&zv>=0)||(z<-width*.5-r&&zv<=0)){
     zv*=-1;
     }
     if(y>height){
     y=height; 
     }
     */
    yv+=.125;
  }
  void draw(){
    //if(-10*cameraZ<z&&z<cameraZ){
    fill(c);
    //  float tx = screenX(x,y,z);
    //  float ty= screenY(x,y,z);
    //  float tr = (screenX(x+r,y,z)-screenX(x,y,z));
    //  rect(tx,ty,2*sin15*tr,2*cos15*tr);
    //  rect(tx,ty,2*cos15*tr,2*sin15*tr);
    //  rect(tx,ty,sqrt(2)*tr,sqrt(2)*tr);
    //}
    //
    translate(x,y,z);
    rect(0,0,2*sin15*r,2*cos15*r);
    rect(0,0,2*cos15*r,2*sin15*r);
    rect(0,0,sqrt(2)*r,sqrt(2)*r);
    translate(-x,-y,-z);
  }
}
void dotsUpdate(){
  float[] change;
  float[][] tv=new float[3][4];
  M4 M=new M4();
  M4 unM = new M4();
  M4 tM=new M4();
  float sinr;
  float cosr;
  for(int i = 0; i < dots.length; i++){
    for(int j = 0; j < pads.length; j++){
      if(cubeSphere(dots[i].x,dots[i].y,dots[i].z,dots[i].r,pads[j].x,pads[j].y,pads[j].z,pads[j].xExt,pads[j].yExt,pads[j].zExt,pads[j].xr,pads[j].yr,pads[j].zr)){
        float[] vector = nCubeSphere(dots[i].x,dots[i].y,dots[i].z,dots[i].r,pads[j].x,pads[j].y,pads[j].z,pads[j].xExt,pads[j].yExt,pads[j].zExt,pads[j].xr,pads[j].yr,pads[j].zr);
        M.MRot(0,-atan2(vector[2],vector[0]),0);
        tM.MRot(0,0,-atan2(vector[1],mag(vector[0],vector[2])));
        M=MMulti(tM,M);
        unM.MRot(0,atan2(vector[2],vector[0]),0);
        tM.MRot(0,0,atan2(vector[1],mag(vector[0],vector[2])));
        unM=MMulti(unM,tM);
        tv[0]=M.MMulti(dots[i].xv,dots[i].yv,dots[i].zv);
        tv[1]=M.MMulti(vector[0],vector[1],vector[2]);
        if(tv[0][0]*tv[1][0]<0){
          vector = unM.MMulti(-tv[0][0]*dots[i].k*pads[j].k,tv[0][1],tv[0][2]);
          dots[i].xv=vector[0];
          dots[i].yv=vector[1];
          dots[i].zv=vector[2]; 
        }
      }
    }
    for(int j = i+1; j < dots.length; j++){
      if(dist(dots[i].x,dots[i].y,dots[i].z, dots[j].x,dots[j].y,dots[j].z)<dots[i].r+dots[j].r&&dots[i].xv-dots[j].xv+dots[i].yv-dots[j].yv+dots[i].zv-dots[j].zv!=0){
        M.MRot(0,-atan2((dots[i].z-dots[j].z),(dots[i].x-dots[j].x)),0);
        tM.MRot(0,0,-atan2(dots[i].y-dots[j].y,dist(dots[i].x,dots[i].z,dots[j].x,dots[j].z)));
        M=MMulti(tM,M);
        unM.MRot(0,atan2((dots[i].z-dots[j].z),(dots[i].x-dots[j].x)),0);
        tM.MRot(0,0,atan2(dots[i].y-dots[j].y,dist(dots[i].x,dots[i].z,dots[j].x,dots[j].z)));
        unM=MMulti(unM,tM);
        tv[0]=M.MMulti(dots[i].xv,dots[i].yv,dots[i].zv);
        tv[1]=M.MMulti(dots[j].xv,dots[j].yv,dots[j].zv);
        tv[2]=M.MMulti(dots[i].x-dots[j].x,dots[i].y-dots[j].y,dots[i].z-dots[j].z);
        if((tv[0][0]-tv[1][0])*tv[2][0]<0){
          change = impact(dots[i].m,dots[j].m,tv[0][0],tv[1][0],dots[i].k,dots[j].k);
          tv[0]=unM.MMulti(change[0],tv[0][1],tv[0][2]);
          tv[1]=unM.MMulti(change[1],tv[1][1],tv[1][2]);
          dots[i].xv=tv[0][0];
          dots[i].yv=tv[0][1];
          dots[i].zv=tv[0][2];
          dots[j].xv=tv[1][0];
          dots[j].yv=tv[1][1];
          dots[j].zv=tv[1][2];
        }
      }
    }
  }
}
void spawnDot(float x1, float y1, float z1, float xv1, float yv1, float zv1, float r1, float m1, float k1){
  boolean done = false;
  for(int i = 0; i < dots.length; i++){
    if(dots[i].active==false){
      dots[i]=new dot(x1,y1,z1,xv1,yv1,zv1,r1,m1,k1);
      i=dots.length;
      done = true;
    } 
  }
  if(!done){
    dot[] tDots = dots;
    dots = new dot[tDots.length+1];
    for(int i = 0; i < tDots.length; i++){
      dots[i]=tDots[i];  
    }
    dots[dots.length-1]=new dot(x1,y1,z1,xv1,yv1,zv1,r1,m1,k1);
  }
}
void spawnDot(float x1, float y1, float z1, float xv1, float yv1, float zv1, float r1, float m1, float k1,color c1){
  boolean done = false;
  for(int i = 0; i < dots.length; i++){
    if(dots[i].active==false){
      dots[i]=new dot(x1,y1,z1,xv1,yv1,zv1,r1,m1,k1,c1);
      i=dots.length;
      done = true;
    } 
  }
  if(!done){
    dot[] tDots = dots;
    dots = new dot[tDots.length+1];
    for(int i = 0; i < tDots.length; i++){
      dots[i]=tDots[i];  
    }
    dots[dots.length-1]=new dot(x1,y1,z1,xv1,yv1,zv1,r1,m1,k1,c1);
  }
}
