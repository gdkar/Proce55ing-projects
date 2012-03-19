boolean circleLine(float x, float y, float r, float x1, float y1, float x2, float y2){
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
boolean sphereLine(float x, float y, float z, float r, float x1, float y1, float z1, float x2, float y2, float z2){
  if(circleLine(x,y,r,x1,y1,x2,y2)&&circleLine(x,z,r,x1,z1,x2,z2)&&circleLine(y,z,r,y1,z1,y2,z2)){
    return true;
  } 
  return false;
}

boolean triPoint(float x,float y, float x1,float y1,float x2,float y2,float x3,float y3){
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
boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt){
  if(x<x1+xExt/2&&x>x1-xExt/2&&y<y1+yExt/2&&y>y1-yExt/2){
    return true; 
  }
  return false;
}
boolean rectLine(float x1, float y1, float x2, float y2, float xc, float yc, float xExt, float yExt){
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
boolean rectSeg(float x1, float y1, float x2, float y2, float xc, float yc, float xExt, float yExt){
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
boolean cubeSeg(float x1,float y1,float z1,float x2,float y2,float z2,float xc,float yc,float zc,float xExt,float yExt,float zExt,float xr,float yr,float zr){
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

boolean cubeCube(float x1,float y1,float z1,float xr1,float yr1,float zr1,float xExt1,float yExt1,float zExt1,
float x2,float y2,float z2,float xr2,float yr2,float zr2,float xExt2,float yExt2,float zExt2){
  M4 m = new M4();
  m.MRot(-xr1,-yr1,-zr1);
  float[] vector;
  float[] vector1;
  //y/z, +x plane, cube 1.
  vector = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //y/z, -x plane, cube 1.
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //connectors, cube 1
  vector = m.MMulti(-xExt1/2,yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  vector = m.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
  vector1 = m.MMulti(xExt1/2,yExt1/2,-zExt1/2);
  stroke(255,122.5,0);
  if(cubeSeg(x1+vector[0],y1+vector[1],z1+vector[2],x1+vector1[0],y1+vector1[1],z1+vector1[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
    return true; 
  }
  //cube 2
  m.MRot(-xr2,-yr2,-zr2);
  //y/z, +x plane, cube 1.
  vector = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  //y/z, -x plane, cube 1.
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  //connectors, cube 1
  vector = m.MMulti(-xExt2/2,yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt2,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  vector = m.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
  vector1 = m.MMulti(xExt2/2,yExt2/2,-zExt2/2);
  stroke(255,122.5,0);
  if(cubeSeg(x2+vector[0],y2+vector[1],z2+vector[2],x2+vector1[0],y2+vector1[1],z2+vector1[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
    return true; 
  }
  return false;
}
boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt,float r){
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
boolean cubePoint(float x, float y, float z, float x1,float y1, float z1, float xExt,float yExt,float zExt){
  if(x<x1+xExt/2&&x>x1-xExt/2&&y<y1+yExt/2&&y>y1-yExt/2&&z<z1+zExt/2&&z>y1-zExt/2){
    return true; 
  }
  return false;
}
boolean cubePoint(float x, float y, float z, float x1,float y1, float z1, float xExt,float yExt,float zExt,float xr,float yr, float zr){
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
boolean rectCircle(float x,float y,float r,float x1,float y1,float xExt, float yExt){
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
float[] vRectCircle(float x, float y, float r, float x1, float y1, float xExt, float yExt){
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
float[] nRectCircle(float x, float y, float r, float x1, float y1, float xExt, float yExt){
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
float[] vCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
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

float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
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

float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
  M4 M = new M4();
  M4 unM=new M4();
  M.MRot(-xr,-yr,-zr);
  unM.MRot(xr,yr,zr);
  float[] tv=M.MMulti(x-x1,y-y1,z-z1);
  float[] vector = nCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
  vector = unM.MMulti(vector[0],vector[1],vector[2]);
  return vector;
}

boolean cubeSphere(float x,float y,float z,float r,float x1,float y1,float z1,float xExt,float yExt,float zExt){
  if(dist(x,y,z,x1,y1,z1)<=mag(xExt/2+r,yExt/2+r,zExt/2+r)){
    if(rectCircle(x,y,r,x1,y1,xExt,yExt)&&rectCircle(x,z,r,x1,z1,xExt,zExt)&&rectCircle(y,z,r,y1,z1,yExt,zExt)){
      return true;
    }
  }
  return false;
}
boolean cubeSphere(float x,float y,float z,float r,float x1,float y1,float z1,float xExt,float yExt,float zExt,float xr,float yr,float zr){
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
float[] linearSolver(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4){
  float[] answer=new float[2];
  float m1 = (y1-y2)/(x1-x2);
  float m2 = (y3-y4)/(x3-x4);
  float b1 = -(m1*x1)+y1;
  float b2 = -(m2*x3)+y3;
  answer[0] = (b2-b1)/(m1-m2);
  answer[1] = m1*answer[0]+b1;
  return answer;
}
float[] linearSolver(float m1, float b1,float m2,float b2){
  float[] answer=new float[2];
  answer[0] = (b2-b1)/(m1-m2);
  answer[1] = m1*answer[0]+b1;
  return answer;
}
float sign(float input){
  return input/abs(input);  
}

