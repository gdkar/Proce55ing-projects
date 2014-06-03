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
    areas[0] = float(sRow[1]);
    areas[1] = float(sRow[2]);
    areas[2] = float(sRow[3]);
    areas[3] = float(sRow[4]);
    areas[4] = float(sRow[5]);
    areas[5] = float(sRow[6]);
    areas[6] = float(sRow[7]);
    curRow = find(sFile,"thrust",0);
    sRow = split(sFile[curRow]);
    thrust = float(sRow[1]);
    curRow = find(sFile,"mass",0);
    sRow = split(sFile[curRow]);
    mass = float(sRow[1]);
    curRow = find(sFile,"Cd",0);
    sRow = split(sFile[curRow]);
    curRow = find(sFile,"Cd",0);
    sRow = split(sFile[curRow]);
    Cd[0] = float(sRow[1]);
    Cd[1] = float(sRow[2]);
    Cd[2] = float(sRow[3]);
    throttle = 0;
    curRow = find(sFile, "box",0);
    sRow=split(sFile[curRow+1]);
    sImpact = float(sRow);
    curRow = find(sFile, "skills",0);
    sRow=split(sFile[curRow+1]);
    skills = float(sRow);
    curRow = find(sFile, "limits",0);
    sRow=split(sFile[curRow+1]);
    limits = float(sRow);
    curRow = find(sFile, "smokes", 0);
    sRow = split(sFile[curRow]);
    emiters = new float[int(sRow[1])][11];
    for(int i = 0; i < emiters.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 11; j++){
        emiters[i][j] = float(sRow[j]);
      } 
    }
    curRow = find(sFile, "impacts", 0);
    sRow = split(sFile[curRow]);
    impacts = new float[int(sRow[1])][7];
    for(int i = 0; i < impacts.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 7; j++){
        impacts[i][j] = float(sRow[j]);
      } 
    }
    curRow = find(sFile, "guns", 0);
    sRow = split(sFile[curRow]);
    weapons = new float[int(sRow[1])][9];
    for(int i = 0; i < weapons.length; i++){
      sRow = split(sFile[curRow+1+i]);
      for(int j = 0; j < 8; j++){
        print(sRow);
        println();
        weapons[i][j] = float(sRow[j]);
      } 
    }
  }
  void upDate(){
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
          zoom*=1.5; 
        }
        if(keysTapped[ascii('f')]){
          zoom/=1.5; 
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
          throttle=constrain(throttle+.05,limits[0],limits[1]); 
        }
        if(keysPressed[ascii('s')]){
          throttle=constrain(throttle-.05,limits[0],limits[1]); 
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
          if(planes[i].hp<0||planes[i].group==group){
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
            value/=2;  
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
            controls[0]=.5*limits[2]/s;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=.5*limits[3]/s;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=.5*limits[5]/s;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=.5*limits[4]/s;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
          if(throttle>.25){
            throttle-=.05; 
          }
          break;
        case 2:
          if(limit(PI*1.2*sign(tPos[0])+tPos[0])>skills[0]){
            controls[0]=limits[2]/s;
          }
          if(limit(PI*1.2*sign(tPos[0])+tPos[0])<-skills[0]){
            controls[0]=limits[3]/s;
          }
          if(!(limit(PI*1.2*sign(tPos[0])+tPos[0])>skills[0]||limit(PI*1.2*sign(tPos[0])+tPos[0])<-skills[0])){
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
            if(throttle<.5){
              throttle+=.05; 
            }
          }
          else{
            if(throttle>.15){
              throttle-=.05; 
            }
          }
          break;
        case 3:
          if(tPos[0]>skills[0]){
            controls[0]=limits[2]/s/3;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=limits[3]/s/3;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=limits[5]/s/3;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=limits[4]/s/3;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
          if(throttle<.75){
            throttle+=.05; 
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
          newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],vel[0]+tvel[0],vel[1]+tvel[1],vel[2]+tvel[2],weapons[i][4],.0,0.0,0.0,int(weapons[i][5]),(weapons[i][7]),iAm);
          weapons[i][8]=0;
        }
      }
    }
    // smoke
    for(int i = 0; i < emiters.length; i++){
      vector = M.MMulti(emiters[i][0],emiters[i][1],emiters[i][2]);
      newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],0,0,0,emiters[i][3],emiters[i][4],emiters[i][5],emiters[i][6],emiters[i][7],emiters[i][8],emiters[i][9],int(emiters[i][10])); 
    }
  }
  void draw(){
    fill(colorGroups[group][0]*hp/100,colorGroups[group][1]*hp/100,colorGroups[group][2]*hp/100);
    sModels[model].draw(pos[0],pos[1],pos[2],r[0],r[1],r[2]); 
  }
}
void planesUpdate(){
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
void planesDraw(){
  for(int i = 0; i < planes.length; i++){
    fill(255,255,255);
    noStroke();
    planes[i].draw();
  } 
}
void addPlane(float x, float y, float z, String fileName, boolean ai){
  plane[] tPlanes = new plane[planes.length+1];
  for(int i = 0; i < planes.length; i++){
    tPlanes[i] = planes[i]; 
  }
  tPlanes[tPlanes.length-1]=new plane(x,y,z,tPlanes.length-1,fileName, ai);
  planes = tPlanes;
}
