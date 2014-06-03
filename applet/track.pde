float track(float x1,float y1,float v1,float r1,float x2,float y2,float v2){
  float theta;
  theta = limit((PI)+atan2((y1-y2),(x1-x2)));
  if(v1<v2){
    float theta1 = asin((v1/v2)*(sin(r1-theta)));
    return((PI-theta1)+theta);
  }

  return(limit(PI+theta));
}

float[] track(float x1, float y1, float z1, float v1, float xr1, float yr1, float zr1, float x2, float y2, float z2, float v2){
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

