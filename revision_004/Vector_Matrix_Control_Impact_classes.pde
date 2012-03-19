class vector{
  float x=0;
  float y=0;
  float z=0;
  M4 M = new M4();
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
  vector vTimes(float k){
    return new vector(x*k,y*k,z*k); 
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
    M=new M4();
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
  vector vMRot(float xr, float yr,float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M = new M4();
    M.MRot(xr,yr,zr);
    fTemp = M.MMulti(x,y,z);
    vTemp.x(fTemp[0]);
    vTemp.y(fTemp[1]);
    vTemp.z(fTemp[2]);
    return vTemp;
  }
  vector vMRot(vector v2){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M.MRot(v2.x(),v2.y(),v2.z());
    fTemp = M.MMulti(x,y,z);
    return new vector(fTemp[0],fTemp[1],fTemp[2]);
  }
  vector vMRot(M4 M1){
    float[] fTemp = M1.MMulti(x,y,z);
    return new vector(fTemp[0],fTemp[1],fTemp[2]);
  }
  vector vRot(float xc, float yc, float zc, float xr, float yr, float zr){
    vector vTemp = new vector(x,y,z);
    vector vTrans = new vector(xc,yc,zc);
    vTemp=(vTemp.vMinus(vTrans));
    vTemp=vTemp.vMRot(xr,yr,zr);
    vTemp=vTemp.vPlus(vTrans);
    return vTemp;
  }
  vector vRotAbout(vector v1, float theta){
    vector v2 = new vector(x,y,z);
    v2=v2.vAlign(v1);
    v2=v2.vMRot(theta,0,0);
    return v2.vUnalign(v1); 
  }
  vector vRotAbout(vector v1){
    vector v2 = new vector(x,y,z);
    v2=v2.vAlign(v1);
    v2=v2.vMRot(v1.vMag(),0,0);
    return v2.vUnalign(v1); 
  }
  vector vUnrot(float xr,float yr, float zr){
    vector vTemp = new vector(x,y,z);
    float[] fTemp = new float[4];
    M=new M4();
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
  vector vAlong(vector v2){
    vector v1 = new vector(x,y,z);
    if(v2.vMag()!=0&&v1.vMag()!=0){
      return v2.vTimes(v1.vDot(v2)/(sq(v2.vMag())*v1.vMag()));
    }
    return new vector();
  }
  float vMagAlong(vector v2){
    vector v1 = new vector(x,y,z);
    return v2.vDot(v1)/(v2.vMag());
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
  M4(float angle_x,float angle_y,float angle_z){
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
  M4(vector v){
    float A       = cos(v.x());
    float B       = sin(v.x());
    float C       = cos(v.y());
    float D       = sin(v.y());
    float E       = cos(v.z());
    float F       = sin(v.z());

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
  M4(vector v, float W){
    float X,Y,Z;
    X=v.x();
    Y=v.y();
    Z=v.z();
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z; 
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
  }
  void QUAT(vector v, float W){
    float X,Y,Z;
    X=v.x();
    Y=v.y();
    Z=v.z();
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z;
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
  }
  void QUAT(QUAT Q){
    float X,Y,Z,W;
    X=Q.v.x();
    Y=Q.v.y();
    Z=Q.v.z();
    W=Q.w;
    mat[0]=1-2*Y*Y  - 2*Z*Z;
    mat[1]=2*X*Y-2*Z*W;
    mat[2]=2*X*Z+2*Y*W;
    mat[3]=0;
    mat[4]=2*X*Y+2*Z*W;
    mat[5]=1-2*X*X-2*Z*Z;
    mat[6]=2*Y*Z-2*X*W;
    mat[7]=0;
    mat[8]=2*X*Z-2*Y*W;
    mat[9]=2*Y*Z+2*X*W;
    mat[10]=1-2*X*X-2*Y*Y;
    mat[11]=0;
    mat[12]=0;
    mat[13]=0;
    mat[14]=0;
    mat[15]=1;
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

boolean[] keysPressed = new boolean[256];
boolean[] keysTapped = new boolean [256];
boolean[] pKeysPressed = new boolean[256];
float[] column = new float[2];
char[] type = new char[50];

void drawColumn(float x, float y, float xm, float ym){
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
void columnUpdate(){
  column[0] = (mouseX-width/2)*(PI/(2*width));
  column[1] = (mouseY-height/2)*(PI/(2*width)); 
  if(abs(column[0])<PI/32){
    column[0]=0;
  }
  if(abs(column[1])<PI/32){
    column[1]=0;
  }
}
void keyPressed() {
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

void keyReleased() { 
  if(!(ascii(key) == -1)){
    keysPressed[ascii(key)] = false;
  }
  else{
    keysPressed[keyCode] = false; 
  }
} 

int ascii(char Char){
  for(int i = 0; i < 128; i++){
    if(Char == char(i)){
      return i;
    }
  }
  return -1;
}


int find(String[] file,String code,int pos){
  String[] spRedData = new String[0];
  for(int i = 0; i < file.length; i++){
    spRedData = spRed(file[i],' ');
    if(spRedData.length>pos){
      if (spRedData[pos].equals(code)){
        return(i);
      }
    }
  }
  return(-1);  
}

int find(String[] file,String code,int pos,int after){
  String[] spRedData;
  if(after<file.length){
    for(int i = after; i < file.length; i++){
      spRedData = spRed(file[i],' ');
      if(spRedData.length>pos){
        if (spRedData[pos].equals(code)){
          return(i);
        }
      }
    }
  }
  return(-1);  
}
int pressedX,pressedY = 0;
void mousePressed(){
  pressedX = mouseX;
  pressedY = mouseY;
}
float limit(float theta){
  while(theta>PI){
    theta-=TWO_PI;
  } 
  while(theta<=-PI){
    theta+=TWO_PI; 
  }
  return theta;
}
void tap(){
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
  void upDate(){
    for(int i = 0; i < bKeys.length; i++){
      bKeys[i] = keysPressed[ascii(sKeys.charAt(i))];
    } 
  }
  boolean test(String sInput){
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
class iDet{
  M4 M = new M4();
  float[] axes;
  float[][] verts;
  float[] vector1;
  float[][] vector2;
  float[][] result2;
  float[] tVector;
  vector vc,v0,vf,vMove,vWalls;
  float m,m1,m2,m3,b,b1,b2,b3,tx,ty,tz,a1,c1;
  iDet(){
  }
  boolean circleLine(float x, float y, float r, float x1, float y1, float x2, float y2){
    m = (y2-y1)/(x2-x1);
    b = -(m*x2)+y2;
    a1 = (sq(m)+1);
    b1 = (2*((m*(x1-m*y1-y))-x));
    c1 = (sq(x1-m*y1-y)+sq(x)-sq(r));
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
    verts= new float[3][2];
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
    m1 = (verts[left][1]-verts[top][1])/(verts[left][0]-verts[top][0]);
    b1 = -(m1*verts[top][0])+verts[top][1];
    m2 = (verts[left][1]-verts[bottom][1])/(verts[left][0]-verts[bottom][0]);
    b2 = -(m2*verts[bottom][0])+verts[bottom][1];
    m3 = (verts[top][1]-verts[bottom][1])/(verts[top][0]-verts[bottom][0]);
    b3 = -(m3*verts[bottom][0])+verts[bottom][1];
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
    m = (y1-y2)/(x1-x2);
    b = -(m*x1)+y1;
    m1 = (x1-x2)/(y1-y2);
    b1 = -(m1*y1)+x1;
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
    m = (y1-y2)/(x1-x2);
    b = -(m*x1)+y1;
    m1 = (x1-x2)/(y1-y2);
    b1 = -(m1*y1)+x1;
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
    boolean intersect=false;
    M.MRot(xr,yr,zr);
    vector1 = M.MMulti(x1-xc,y1-yc,z1-zc);
    x1 = vector1[0];
    y1 = vector1[1];
    z1 = vector1[2];
    vector1 = M.MMulti(x2-xc,y2-yc,z2-zc);
    x2 = vector1[0];
    y2 = vector1[1];
    z2 = vector1[2];
    if(rectSeg(x1,y1,x2,y2,0,0,xExt,yExt)&&rectSeg(x1,z1,x2,z2,0,0,xExt,zExt)&&rectSeg(z1,y1,z2,y2,0,0,zExt,yExt)){
      intersect = true;
    }
    return intersect;
  }
  boolean cubeCube(float x1,float y1,float z1,float xr1,float yr1,float zr1,float xExt1,float yExt1,float zExt1,
  float x2,float y2,float z2,float xr2,float yr2,float zr2,float xExt2,float yExt2,float zExt2){
    M.MRot(-xr1,-yr1,-zr1);
    //y/z, +x plane, cube 1.
    vector1 = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //y/z, -x plane, cube 1.
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //connectors, cube 1
    vector1 = M.MMulti(-xExt1/2,yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,-yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,-yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    vector1 = M.MMulti(-xExt1/2,yExt1/2,-zExt1/2);
    tVector = M.MMulti(xExt1/2,yExt1/2,-zExt1/2);
    stroke(255,122.5,0);
    if(cubeSeg(x1+vector1[0],y1+vector1[1],z1+vector1[2],x1+tVector[0],y1+tVector[1],z1+tVector[2],x2,y2,z2,xExt2,yExt2,zExt2,xr2,yr2,zr2)){
      return true; 
    }
    //cube 2
    M.MRot(-xr2,-yr2,-zr2);
    //y/z, +x plane, cube 1.
    vector1 = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    //y/z, -x plane, cube 1.
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    //connectors, cube 1
    vector1 = M.MMulti(-xExt2/2,yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt2,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,-yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,-yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    vector1 = M.MMulti(-xExt2/2,yExt2/2,-zExt2/2);
    tVector = M.MMulti(xExt2/2,yExt2/2,-zExt2/2);
    stroke(255,122.5,0);
    if(cubeSeg(x2+vector1[0],y2+vector1[1],z2+vector1[2],x2+tVector[0],y2+tVector[1],z2+tVector[2],x1,y1,z1,xExt1,yExt1,zExt1,xr1,yr1,zr1)){
      return true; 
    }
    return false;
  }
  boolean rectPoint(float x, float y, float x1,float y1, float xExt,float yExt,float r){
    M.MRot(0,0,-r);
    float[] vector;
    vector = M.MMulti(x-x1,y-y1,0);
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
    M.MRot(-xr,-yr,-zr);
    float[] vector;
    vector = M.MMulti(x-x1,y-y1,z-z1);
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
    vector1 = new float[3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
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
        vector1=axes;
      }
    }

    return vector1;
  }

  float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
    vector1 = new float[3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
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
        vector1=axes;
      }
    }
    float vMag = mag(vector1[0],vector1[1],vector1[2]);
    vector1[0]/=vMag;
    vector1[1]/=vMag;
    vector1[2]/=vMag;
    return vector1;
  }

  float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt){
    vector1 = new float[3];
    result2 = new float[2][3];
    if(cubeSphere(x,y,z,r,x1,y1,z1,xExt,yExt,zExt)){
      tVector = vRectCircle(x,y,r,x1,y1,xExt,yExt);
      vector1[0]+=tVector[0];
      vector1[1]+=tVector[1];
      tVector = vRectCircle(y,z,r,y1,z1,yExt,zExt);
      vector1[1]+=tVector[0];
      vector1[2]+=tVector[1];
      tVector = vRectCircle(x,z,r,x1,z1,xExt,zExt);
      vector1[0]+=tVector[0];
      vector1[2]+=tVector[1];
      if(vector1[0]==0&&vector1[1]==0&&vector1[2]==0){
        tx = x-x1;
        ty=y-y1;
        tz=z-z1;
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
        result2[1][0]= x1+(axes[0]*(xExt+r));
        result2[1][1]= y1+(axes[1]*(yExt+r));
        result2[1][2]= z1+(axes[2]*(zExt+r));
        vector1=axes;
      }
    }
    float vMag = mag(vector1[0],vector1[1],vector1[2]);
    vector1[0]/=vMag;
    vector1[1]/=vMag;
    vector1[2]/=vMag;
    result2[0]=vector1;
    return result2;
  }
  float[] nCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
    M4 M = new M4();
    M4 unM=new M4();
    M.MRot(-xr,-yr,-zr);
    unM.MRot(xr,yr,zr);
    float[] tv=M.MMulti(x-x1,y-y1,z-z1);
    vector1 = nCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
    vector1 = unM.MMulti(vector1[0],vector1[1],vector1[2]);
    return vector1;
  }
  float[][] dCubeSphere(float x,float y,float z,float r,float x1, float y1, float z1, float xExt, float yExt, float zExt,float xr,float yr, float zr){
    M4 M = new M4();
    M4 unM=new M4();
    M.MRot(-xr,-yr,-zr);
    unM.MRot(xr,yr,zr);
    float[] tv=M.MMulti(x-x1,y-y1,z-z1);
    vector2 = dCubeSphere(tv[0],tv[1],tv[2],r,0,0,0,xExt,yExt,zExt);
    vector2[0] = unM.MMulti(vector2[0][0],vector2[0][1],vector2[0][2]);
    vector2[1]= unM.MMulti(vector2[1][0],vector2[1][1],vector2[1][2]);
    return vector2;
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
      vector1 = M.MMulti(x-x1,y-y1,z-z1);
      if(rectCircle(vector1[0],vector1[1],r,0,0,xExt,yExt)&&rectCircle(vector1[0],vector1[2],r,0,0,xExt,zExt)&&rectCircle(vector1[1],vector1[2],r,0,0,yExt,zExt)){
        return true;
      }
    }
    return false;
  }
  float[] linearSolver(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4){
    float[] answer=new float[2];
    m1 = (y1-y2)/(x1-x2);
    m2 = (y3-y4)/(x3-x4);
    b1 = -(m1*x1)+y1;
    b2 = -(m2*x3)+y3;
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
  vector cubeSeg(float x0,float y0,float z0,float xf,float yf,float zf,float xc,float yc,float zc,float xExt,float yExt,float zExt){
    vector vPoint = new vector();
    vector vc = new vector(xc,yc,zc);
    vector v0 = new vector(x0-xc,y0-yc,z0-zc);
    vector vf = new vector(xf-xc,yf-yc,zf-zc);
    vector vMove = vf.vMinus(v0);
    vector vWalls = new vector();
    if(v0.x()>xExt/2){
      vWalls.x(xExt/2); 
    }
    if(v0.x()<-xExt/2){
      vWalls.x(-xExt/2); 
    }
    if(v0.y()>yExt/2){
      vWalls.y(yExt/2); 
    }
    if(v0.y()<-yExt/2){
      vWalls.y(-yExt/2); 
    }
    if(v0.z()>zExt/2){
      vWalls.z(zExt/2); 
    }
    if(v0.z()<-zExt/2){
      vWalls.z(-zExt/2); 
    }
    if(vWalls.x()!=0){
      if(v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))<yExt/2&&v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))>-yExt/2&&
        v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))<zExt/2&&v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))>-zExt/2){
        vPoint.x(vWalls.x());
        vPoint.y( v0.y()-((vMove.y()/vMove.x())*(v0.x()-vWalls.x())));
        vPoint.z(v0.z()-((vMove.z()/vMove.x())*(v0.x()-vWalls.x())));
      }
    }
    if(vWalls.y()!=0){
      if(v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))<xExt/2&&v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))>-xExt/2&&
        v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))<zExt/2&&v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))>-zExt/2){
        vPoint.y(vWalls.y());
        vPoint.x( v0.x()-((vMove.x()/vMove.y())*(v0.y()-vWalls.y())));
        vPoint.z(v0.z()-((vMove.z()/vMove.y())*(v0.y()-vWalls.y())));
      }
    }
    if(vWalls.z()!=0){
      if(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))<yExt/2&&v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))>-yExt/2&&
        v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))<xExt/2&&v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))>-xExt/2){
        vPoint.z(vWalls.z());
        vPoint.y(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z())));
        vPoint.x( v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z())));
      }
    }
    vPoint = vPoint.vPlus(vc);
    return vPoint;
  }

  vector[] nCubeSeg(float x0,float y0,float z0,float xf,float yf,float zf,float xc,float yc,float zc,float xExt,float yExt,float zExt){
    vector vPoint = new vector();
    vector[] result = new vector[2];
    result[1] = new vector();
    vc = new vector(xc,yc,zc);
    v0 = new vector(x0-xc,y0-yc,z0-zc);
    vf = new vector(xf-xc,yf-yc,zf-zc);
    vMove = vf.vMinus(v0);
    vWalls = new vector();
    if(v0.x()>xExt/2&&vf.x()<xExt/2){
      vWalls.x(xExt/2); 
    }
    if(v0.x()<-xExt/2&&vf.x()>-xExt/2){
      vWalls.x(-xExt/2); 
    }
    if(v0.y()>yExt/2&&vf.y()<yExt/2){
      vWalls.y(yExt/2); 
    }
    if(v0.y()<-yExt/2&&vf.y()>-yExt/2){
      vWalls.y(-yExt/2); 
    }
    if(v0.z()>zExt/2&&vf.z()<zExt/2){
      vWalls.z(zExt/2); 
    }
    if(v0.z()<-zExt/2&&vf.z()>-zExt/2){
      vWalls.z(-zExt/2); 
    }
    if(vWalls.x()!=0){
      if(v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))<yExt/2&&v0.y()-(vMove.y()/vMove.x()*(v0.x()-vWalls.x()))>-yExt/2&&
        v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))<zExt/2&&v0.z()-(vMove.z()/vMove.x()*(v0.x()-vWalls.x()))>-zExt/2){
        vPoint.x(vWalls.x());
        vPoint.y( v0.y()-((vMove.y()/vMove.x())*(v0.x()-vWalls.x())));
        vPoint.z(v0.z()-((vMove.z()/vMove.x())*(v0.x()-vWalls.x())));
        result[1].x(sign(vWalls.x()));
      }
    }
    if(vWalls.y()!=0){
      if(v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))<xExt/2&&v0.x()-(vMove.x()/vMove.y()*(v0.y()-vWalls.y()))>-xExt/2&&
        v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))<zExt/2&&v0.z()-(vMove.z()/vMove.y()*(v0.y()-vWalls.y()))>-zExt/2){
        vPoint.y(vWalls.y());
        vPoint.x( v0.x()-((vMove.x()/vMove.y())*(v0.y()-vWalls.y())));
        vPoint.z(v0.z()-((vMove.z()/vMove.y())*(v0.y()-vWalls.y())));
        result[1].y(sign(vWalls.y()));
      }
    }
    if(vWalls.z()!=0){
      if(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))<yExt/2&&v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z()))>-yExt/2&&
        v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))<xExt/2&&v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z()))>-xExt/2){
        vPoint.z(vWalls.z());
        vPoint.y(v0.y()-(vMove.y()/vMove.z()*(v0.z()-vWalls.z())));
        vPoint.x( v0.x()-(vMove.x()/vMove.z()*(v0.z()-vWalls.z())));
        result[1].z(sign(vWalls.z()));
      }
    }
    vPoint = vPoint.vPlus(vc);
    result[0]=vPoint;
    return result;
  }
}
int sign(float input){
  return int(input/abs(input));  
}
class QUAT{
  vector v=new vector(1,1,1);
  float w = 0;
  QUAT(){
    v=new vector(1,1,1);
    v=v.vTimes(sin(0/2));
    w=cos(0/2);
  } 
  QUAT(float x1,float y1,float z1,float theta){
    v=new vector(x1,y1,z1);
    v=v.vTimes(sin(theta/2));
    w=cos(theta/2);
  }
  QUAT(vector v1,float theta){
    v=v1.vTimes(sin(theta/2));
    w=cos(theta/2); 
  }
  QUAT(M4 M){
    float T=M.mat[0]+M.mat[5]+M.mat[10]+1;
    float S,W,X,Y,Z;
    S=W=X=Y=Z=0;
    if(T>0){
      S = 0.5 / sqrt(T);
      W = 0.25 / S;
      X = ( M.mat[9] - M.mat[6] ) * S;
      Y = ( M.mat[2] - M.mat[8] ) * S;
      Z = ( M.mat[4] - M.mat[1] ) * S;
    }
    else{
      int Greatest=0;
      if(M.mat[0]>M.mat[5]&&M.mat[0]>M.mat[10]){
        Greatest=0; 
      }
      if(M.mat[5]>M.mat[0]&&M.mat[5]>M.mat[10]){
        Greatest=1; 
      }
      if(M.mat[10]>M.mat[0]&&M.mat[10]>M.mat[5]){
        Greatest=2; 
      }
      switch(Greatest){
      case 0:
        S  = sqrt( 1.0 + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;

        X = 0.5 / S;
        Y=  (M.mat[1] + M.mat[4] ) / S;
        Z =  (M.mat[2] + M.mat[8] ) / S;
        W =  (M.mat[6] + M.mat[9] ) / S;
        break;
      case 1:
        S  = sqrt( 1.0 + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;


        X=  (M.mat[1] + M.mat[4] ) / S;
        Y = 0.5 / S;
        Z =  (M.mat[6] + M.mat[9] ) / S;
        W =  (M.mat[2] + M.mat[8] ) / S;
        break;
      case 2:
        S  = sqrt( 1.0 + M.mat[0] - M.mat[5] - M.mat[10] ) * 2;

        X=  (M.mat[2] + M.mat[8] ) / S;
        Y =  (M.mat[6] + M.mat[9] ) / S;
        Z = 0.5 / S;
        W =  (M.mat[1] + M.mat[4] ) / S;
        break;
      }
    }
    println(S);
    float Mag = sqrt(sq(X)+sq(Y)+sq(Z)+sq(W));
    if(Mag!=0){
      X/=Mag;
      Y/=Mag;
      Z/=Mag;
      W/=Mag;
    }
    v=new vector(X,Y,Z);
    w=W;
  }
  QUAT QMulti(QUAT Q){
    //Qr = Q1.Q2 = ( w1.w2 - v1.v2, w1.v2 + w2.v1 + v1 x v2 )
    QUAT result = new QUAT();
    result.v=(v.vTimes(Q.w).vPlus(Q.v.vTimes(w)).vPlus(v.vCross(Q.v)));
    result.w=(w*Q.w-v.vDot(Q.v));
    result.normalize();
    return result;
  }
  void normalize(){
    float Mag=sqrt(sq(v.x())+sq(v.y())+sq(v.z())+sq(w));
    if(Mag!=0){
      v=v.vTimes(1/Mag);
      w/=Mag;
    }
  }
  void QPrint(){
    print(w);
    print(' ');
    v.vPrint(); 
  }
}
M4 MQMulti(M4 M1, M4 M2){
  QUAT Q1 = new QUAT(M1);
  QUAT Q2 = new QUAT(M2);
  Q1=Q1.QMulti(Q2);
  return new M4(Q1.v,Q1.w);
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
