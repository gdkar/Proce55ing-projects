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
  void normalize(){
    float fMag = mag(x,y,z);
    x/=fMag;
    y/=fMag;
    z/=fMag; 
  }
  vector vNormalize(){
    vector tVector = new vector(x,y,z);
    tVector.normalize();
    return tVector;
  }
  float vMag(){
    return mag(x,y,z); 
  }
  float x(){
    return x;
  }
  float y(){
    return y;
  }
  float z(){
    return z;
  }
  void x(float x1){
    x=x1;
  }
  void y(float y1){
    y=y1;
  }
  void z(float z1){
    z=z1;
  }
  vector vPlus(vector v2){
    vector v3 = new vector();
    v3.x(x+v2.x());
    v3.y(y+v2.y());
    v3.z(z+v2.z());
    return v3;
  }
  vector vMinus(vector v2){
    vector v3 = new vector();
    v3.x(x-v2.x());
    v3.y(y-v2.y());
    v3.z(z-v2.z());
    return v3;
  }
  float vDot(vector v2){
    return x*v2.x()+y*v2.y()+z*v2.z(); 
  }
  vector vCross(vector v2){
    vector v3=new vector(y*v2.z()-z*v2.y(), z*v2.x()-x*v2.z(),x*v2.y()-y*v2.x());
    return v3;
  }
  vector vRot(float xr, float yr, float zr){
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
  vector vRot(float xc, float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vRot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  vector vUnrot(float xr,float yr, float zr){
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
  vector vUnrot(float xc,float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vUnrot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  vector vAlign(vector v2){
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
  vector vUnalign(vector v2){
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
  void vPrint(){
    println(str(x)+' '+str(y)+' '+str(z)); 
  }
  vector vReflect(vector v2){
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
float ang(vector v1,vector v2){
  return acos(v1.vDot(v2)/(v1.vMag()*v2.vMag())); 
}
