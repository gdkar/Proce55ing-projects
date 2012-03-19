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

  float[] MDerot(){
    float tx,ty,angle_x,angle_y,angle_z=0;
    float D;
    angle_y = D = -asin( mat[2]);        /* Calculate Y-axis angle */
    float C           =  cos( angle_y );

    if ( abs( C ) > 0.005 )             /* Gimball lock? */
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
  void MTrans(){
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
  void MRot(float angle_x,float angle_y,float angle_z){
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
  float[] MMulti(float x,float y,float z){
    float[] mat2 = new float[4];
    mat2[0] = mat[0]*x+mat[1]*y+mat[2]*z;
    mat2[1] = mat[4]*x+mat[5]*y+mat[6]*z;
    mat2[2] = mat[8]*x+mat[9]*y+mat[10]*z;
    return mat2;
  }
}

float[] trans(float x,float y,float z,float xt,float yt,float zt,float xr,float yr,float zr){
  M4 m = new M4();
  m.MRot(xr,yr,zr);
  float[] pos = new float[4];
  pos = m.MMulti(x,y,z);
  pos[0]+=xt;
  pos[1]+=yt;
  pos[2]+=zt;
  return pos;
}
float[] trans(float x,float y,float z,float xr,float yr,float zr){
  M4 m = new M4();
  m.MRot(xr,yr,zr);
  float[] pos = new float[4];
  pos = m.MMulti(x,y,z);

  return pos;
}

M4 MMulti(M4 m1, M4 m2){
  M4 m = new M4();
  for(int j = 0; j < 3; j++){
    for(int i = 0; i < 3; i++){
      m.mat[(i*4)+j]=(m1.mat[(i*4)+0]*m2.mat[(0*4)+j])+(m1.mat[(i*4)+1]*m2.mat[(1*4)+j])+(m1.mat[(i*4)+2]*m2.mat[(2*4)+j]);
    }
  }
  return m;
}

