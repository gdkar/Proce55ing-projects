import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class Impact_reflect_trails_3D_6 extends PApplet {dot[] dots = new dot[0];
public void setup(){
  dots=new dot[480];
  size(400,400,P3D);
  sphereDetail(0);
  int x = PApplet.parseInt(sqrt(dots.length));
  while(x*x>=dots.length){
    x-=1;
  }
  M4 M = new M4();
  float[] vert;
  for(int i = 0; i < 12; i++){
    for(int j = 0; j <10; j++){
      for(int k = 0; k < 4; k++){
        M.MRot(PI/6*(i),PI/5.5f*(j+1),0);
        vert = M.MMulti(0,0,(k+1)*20);
        dots[i*40+j*4+k] = new dot(width/2+vert[2],height/2+vert[1],-width/2+vert[0],0,0,0,10,1,1,color(255,255/4*(3-k),0));
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
public void draw(){
  println(frameRate);
  tap();
  if(keysPressed[32]){
    setup(); 
  }
  if(keysTapped[ENTER]){
    spawnDot(width/2,height/2,width/2,20*((mouseX-width/2+.1f)/(width/2)),20*((mouseY-height/2+.1f)/(width/2)),-20,10,10000,1,color(0,255,0));
  }
  if(keysTapped[SHIFT]){
    spawnDot(width/2,height/2,width/2,0,0,-20,10,1,1,color(0,0,255)); 
  }
  //float eK = 0;
  //for(int i = 0; i < dots.length; i++){
  //  eK+=(sq(dots[i].xv)+sq(dots[i].yv)+sq(dots[i].zv))*dots[i].m*.5;
  //}
  //println(eK);
  // background(204);
  background(0,8);
  //fill(0,0,0,8);
  //rect(width/2,height/2,width,height);
  fill(255,0,0);
  stroke(0);
  noStroke();
  float w = width/2;
  float h = height/2;
  float d = 0;
  dotsUpdate();
  fill(255,0,0);
  noStroke();
  for(int i = 0; i < dots.length; i++){
    dots[i].upDate();
    dots[i].draw();
    fill(255,255,255); 
  }
}
public float[] impact (float m1, float m2, float x1, float x2, float k1, float k2){
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
class dot{
  float x,y,z,xv,yv,zv,r,m,k,fxv,fyv,fzv,fx,fy,fz;
  float sin15 = sin(radians(15));
  float cos15 = cos(radians(15));
  float cameraZ = (height/2.0f) / tan(PI * 60 / 360.0f);
  boolean active = true;
  int c=color(255);
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
  dot(float x1, float y1,float z1, float xv1, float yv1,float zv1, float r1, float m1, float k1,int c1){
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
  public void upDate(){
    xv+=fxv;
    yv+=fyv;
    zv+=fzv;
    fxv=0;
    fyv=0;
    fzv=0;
    x+=xv;
    y+=yv;
    z+=zv;
    
    /*if((x>width-r&&xv>=0)||(x<+r&&xv<=0)){
     xv*=-1;
     }
     if((y>height-r&&yv>=0)||(y<r&&yv<=0)){
     yv*=-1;
     }
     
     //if(y<height-r){
    // yv+=.5; 
     //}
     if((z>r&&zv>=0)||(z<-width-r&&zv<=0)){
     zv*=-1;
     }
     if(y>height){
     y=height; 
     }*/
     
    //yv+=.125;
  }
  public void draw(){
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
public void dotsUpdate(){
  float[] change;
  float[][] tv=new float[3][4];
  M4 M=new M4();
  M4 unM = new M4();
  M4 tM=new M4();
  float sinr;
  float cosr;
  for(int i = 0; i < dots.length; i++){
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
public void spawnDot(float x1, float y1, float z1, float xv1, float yv1, float zv1, float r1, float m1, float k1){
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
public void spawnDot(float x1, float y1, float z1, float xv1, float yv1, float zv1, float r1, float m1, float k1,int c1){
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
    m2.mat = mat;
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
      print(axes);
      println();
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
      print(axes);
      println();
      vector=axes;
    }
  }
  float vMag = mag(vector[0],vector[1],vector[2]);
  vector[0]/=vMag;
  vector[1]/=vMag;
  vector[2]/=vMag;
  return vector;
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
  return input/abs(input);  
}


boolean[] keysPressed = new boolean[128]; 
boolean[] keysTapped = new boolean [128];
boolean[] pKeysPressed = new boolean[128];
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
    type = subset(type,0,type.length-1); 
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
  while(theta<-PI){
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
static public void main(String args[]) {   PApplet.main(new String[] { "Impact_reflect_trails_3D_6" });}}