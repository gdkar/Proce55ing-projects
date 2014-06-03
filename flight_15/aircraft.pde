class plane{
  int evadeClock=0;
  boolean bAi=true;
  boolean det = false;
  boolean firing=false;
  boolean tCollided = false;
  int iMode = 1;
  int group = 0;
  float hp=100;
  int target = 0;
  int model;
  int modelLow;
  String sName;
  int iAm;
  int kills=0;
  int deaths=0;
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
  int rxn=8;
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
    sRow = spRed(sFile[curRow],' ');
    model = addModel(sRow[1]);
    curRow = find(sFile,"modelLow",0);
    sRow = spRed(sFile[curRow],' ');
    modelLow = addModel(sRow[1]);
    curRow = find(sFile,"areas",0);
    sRow = spRed(sFile[curRow],' ');
    areas[0] = float(sRow[1]);
    areas[1] = float(sRow[2]);
    areas[2] = float(sRow[3]);
    areas[3] = float(sRow[4]);
    areas[4] = float(sRow[5]);
    areas[5] = float(sRow[6]);
    areas[6] = float(sRow[7]);
    curRow = find(sFile,"thrust",0);
    sRow = spRed(sFile[curRow],' ');
    thrust = float(sRow[1]);
    curRow = find(sFile,"mass",0);
    sRow = spRed(sFile[curRow],' ');
    mass = float(sRow[1]);
    curRow = find(sFile,"Cd",0);
    sRow = spRed(sFile[curRow],' ');
    curRow = find(sFile,"Cd",0);
    sRow = spRed(sFile[curRow],' ');
    Cd[0] = float(sRow[1]);
    Cd[1] = float(sRow[2]);
    Cd[2] = float(sRow[3]);
    throttle = 0;
    curRow = find(sFile, "box",0);
    sRow=spRed(sFile[curRow+1],' ');
    sImpact = float(sRow);
    for(int i = 0; i < sImpact.length; i++){
      sImpact[i]/=4; 
    }
    curRow = find(sFile, "skills",0);
    sRow=spRed(sFile[curRow+1],' ');
    skills = float(sRow);
    curRow = find(sFile, "limits",0);
    sRow=spRed(sFile[curRow+1],' ');
    limits = float(sRow);
    curRow = find(sFile, "smokes", 0);
    sRow = spRed(sFile[curRow],' ');
    emiters = new float[int(sRow[1])][11];
    for(int i = 0; i < emiters.length; i++){
      sRow = spRed(sFile[curRow+1+i],' ');
      for(int j = 0; j < 11; j++){
        emiters[i][j] = float(sRow[j]);
      }
      emiters[i][0]/=4;
      emiters[i][1]/=4;
      emiters[i][2]/=4;
    }
    curRow = find(sFile, "impacts", 0);
    sRow = spRed(sFile[curRow],' ');
    impacts = new float[int(sRow[1])][7];
    for(int i = 0; i < impacts.length; i++){
      sRow = spRed(sFile[curRow+1+i],' ');
      for(int j = 0; j < 7; j++){
        impacts[i][j] = float(sRow[j]);
        if(j<6)
          impacts[i][j]/=4;
      } 
    }
    curRow = find(sFile, "guns", 0);
    sRow = spRed(sFile[curRow],' ');
    weapons = new float[int(sRow[1])][9];
    for(int i = 0; i < weapons.length; i++){
      sRow = spRed(sFile[curRow+1+i],' ');
      for(int j = 0; j < 8; j++){
        print(sRow);
        println();
        weapons[i][j] = float(sRow[j]);
      }
      weapons[i][0]/=4;
      weapons[i][1]/=4;
      weapons[i][2]/=4;
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
      if(pos[1]>terrain.heightAt(pos[0],pos[2])){
        if(!tCollided){
          if(terrain.mType!=1){
            terrain.crater(pos[0],pos[2],740,740); 
          }
          tCollided = true;
          println("SUICIDE");
          terrain.write(pos[0],pos[2],512,512,color(5,5,5));
          for(int tV=0; tV< 3; tV++){
                boomRand(pos[0],pos[1],pos[2],32,512,512,90);
          }
          for(int k = 0; k < 10; k++){
            for(int l = 0; l < 10; l++){
              newSmoke(pos[0],pos[1],pos[2],75*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),75*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),75*m/s*sin(k*TWO_PI/10),5,.5,125,2,125,125,125,150);
            }
          } 
        }
        hp=-1;
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
        if(keysPressed[ascii('k')]){
          det = true;
        }
        if(keysPressed[32]){
          firing=true; 
        }
        else{
          firing=false;
        }
      }
      if(bAi&&frameCount%rxn==0){
        vector=new float[3];
        float range;
        float radialSector=0;
        float rangeSector=0;
        //if(planes[target].hp<0||planes[target].group==group){
        float d = 100000;
        float a = PI+1;
        float value;
        int vClass,tClass;
        vClass=6;
        boolean firedUpon=false;
        for(int i = 0; i < smoke.length; i++){
          if(smoke[i].bBullet){
            if(dist(smoke[i].x,smoke[i].y,smoke[i].z,pos[0],pos[1],pos[2])<512&&planes[smoke[i].firedBy].group!=group){
              firedUpon=true;
            }
          } 
        }
        if(firedUpon||planes[target].hp<0||dist(planes[target].pos[0],planes[target].pos[1],planes[target].pos[2],pos[0],pos[1],pos[2])>2048||planes[target].group==group){
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
               
               float alpha = ang(new vector(vel[0],vel[1],vel[2]),new vector(planes[i].pos[0]-pos[0],planes[i].pos[1]-pos[1],planes[i].pos[2]-pos[2]));
               if((alpha<PI/4&&range<320)||(range<320&&planes[i].target==iAm)){
                 tClass=1;
                 value=alpha;
               }else if(alpha<PI/2&&range<640){
                tClass=0;
                value=alpha;
               }else if(range<640){
                 tClass=2;
                value =alpha; 
               }else if(range<2048&&alpha<PI/2){
                tClass=3;
                value=alpha; 
               }else if(range<2048){
                 tClass=4;
                value=range; 
               }else{
                 tClass=5;
                 value=range;
               }
               if(planes[i].group==group)value*=2;
               if(planes[planes[i].target].group==group)value/=2;
              if(tClass<vClass||(tClass==vClass&&value<d)){
                d=value;
                vClass=tClass;
                target = i; 
              }
            }
          }
        }
        //}
        /* for(int i = 0; i < iAm; i++){
         if(planes[i].group==group&&planes[i].hp>=0&&planes[planes[i].target].group!=group&&planes[i].bAi==true){
         target = planes[i].target;
         i=iAm;
         } 
         }*/
        for(int i = 0; i < planes.length; i++){
          if(dist(pos[0],pos[1],pos[2],planes[i].pos[0],planes[i].pos[1],planes[i].pos[2])<256&&i!=iAm){
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
        M.MRot(r[0],r[1],r[2]);
        M.MTrans();
        float[] rPos=M.MMulti(planes[target].pos[0]-pos[0],planes[target].pos[1]-pos[1],planes[target].pos[2]-pos[2]);
        if(range<256&&(hp>25||planes[target].group==group)){
          iMode=2;
          vector = track(planes[target].pos[0],planes[target].pos[1],planes[target].pos[2],planes[target].speed,planes[target].r[0],planes[target].r[1],planes[target].r[2],pos[0],pos[1],pos[2],1*m/s);
        }
        if(range>128&&iMode==2&&firedUpon){
          if(random(2)<1){
            evadeClock = 0;
            iMode = 5;
          }
          else{
            evadeClock = 0;
            iMode = 6; 
          }
        }
        if(evadeClock>90){
          iMode=2; 
        }
        if(range>640){
          iMode = 1;
        }
        if(range>2048){
          iMode=3; 
        }
          if(terrain.heightAt(pos[0],pos[2])-pos[1]<370||terrain.heightAt(pos[0]+rxn*12*vel[0],pos[2]+rxn*12*vel[2])-(pos[1]+rxn*12*vel[1])<0){
            iMode=4;
        }
        float[] tPos = new float[3];
        float[] tVec = new float[3];
        float[] temp = new float[3];
        M.MRot(r[0],r[1],r[2]);
        M.MTrans();
        M1.MRot(vector[0],vector[1],vector[2]);
        M1=MMulti(M,M1);
        temp = M1.MMulti(0,0,1);
        if(iMode==4){
          if(terrain.heightAt(pos[0],pos[2])-pos[1]<370){
           temp=M.MMulti(0,-1,0); 
          }else{
          temp = M.MMulti(rxn*12*vel[0],terrain.heightAt(pos[0]+rxn*12*vel[0],pos[2]+rxn*12*vel[2])-512-pos[1],rxn*12*vel[2]);
          }
        }
        tVec = M.MMulti(planes[target].pos[0]-pos[0],planes[target].pos[1]-pos[1],planes[target].pos[2]-pos[2]);
        //tPos[0]=limit(atan2(tVec[1],tVec[2]));
        //tPos[1]=limit(atan2(tVec[2],tVec[0])-PI/2);
        tPos[0]=limit(atan2(temp[1],temp[2]));
        tPos[1]=limit(atan2(temp[2],temp[0])-PI/2);
        tPos[2]=-limit(atan2(temp[1],temp[0])-PI/2);
        //tPos[2]=0;
        firing = false;
        if(abs(tPos[0])<2*skills[0]&&abs(tPos[1])<2*skills[1]&&range<2048&&planes[target].group!=group){
          firing = true; 
        }
        if(planes[target].group==group){
          firing = false; 
        }
        int friends = 0;
        int fBlast = 0;
        int eBlast = 0;
        for(int i = 0; i < planes.length; i++){
          if(i!=iAm){
            if(planes[i].group==group&&planes[i].hp>=0){
              friends++;
              if(dist(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],pos[0],pos[1],pos[2])<1536){
                fBlast++; 
              }
            } 
            else{
              if(dist(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],pos[0],pos[1],pos[2])<1536&&planes[i].hp>=0){
                eBlast++; 
              } 
            }
          }
        }
        if(friends-fBlast>0&&fBlast<eBlast&&hp<12.5){
          //det=true; 
        }
        float fAlpha=ang(new vector(vel[0],vel[1],vel[2]),new vector(planes[target].pos[0]-pos[0],planes[target].pos[1]-pos[1],planes[target].pos[2]-pos[2]));
        switch (iMode){
        case 0:
          break;
        case 1:
          if(tPos[0]>skills[0]){
            controls[0]=.75*limits[2]/s;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=.75*limits[3]/s;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=.75*limits[5]/s;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=.75*limits[4]/s;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
                    controls[2]=0;
          //
         //           if(tPos[2]>skills[2]){
         //   controls[2]=.75*limits[7]/s;
         // }
        //  if(tPos[2]<-skills[2]){
        //    controls[2]=.75*limits[6]/s;
        //  }
        //  if(!(tPos[2]>skills[2]||tPos[2]<-skills[2])){
        //    controls[2]=0; 
         // }
        //  //
        
        //
                  if(fAlpha>PI/8){
                    if(tPos[2]>skills[2]){
            controls[2]=limits[7]/s;
          }
          if(tPos[2]<-skills[2]){
            controls[2]=limits[6]/s;
          }
          if(!(tPos[2]>skills[2]||tPos[2]<-skills[2])){
            controls[2]=0; 
          }
          }
        //
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
          controls[2]=0;
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
          if(fAlpha<PI/2&&throttle<.75){
            throttle+=.05; 
          }
          if(fAlpha>=PI/2&&throttle>.25){
           throttle-=.05; 
          }
          controls[2]=0;
          if(fAlpha>PI/8){
                    if(tPos[2]>skills[2]){
            controls[2]=limits[7]/s;
          }
          if(tPos[2]<-skills[2]){
            controls[2]=limits[6]/s;
          }
          if(!(tPos[2]>skills[2]||tPos[2]<-skills[2])){
            controls[2]=0; 
          }
          }
          break;
        case 4:
          if(tPos[0]>skills[0]){
            controls[0]=limits[2]/s;
          }
          if(tPos[0]<-skills[0]){
            controls[0]=limits[3]/s;
          }
          if(!(tPos[0]>skills[0]||tPos[0]<-skills[0])){
            controls[0]=0; 
          }
          if(tPos[1]>skills[1]){
            controls[1]=limits[5]/s;
          }
          if(tPos[1]<-skills[1]){
            controls[1]=limits[4]/s;
          }
          if(!(tPos[1]>skills[1]||tPos[1]<-skills[1])){
            controls[1]=0; 
          }
          if(throttle>.25){
            throttle-=.05; 
          }
          if(throttle>.25){
            throttle-=.05; 
          }

          controls[2]=0;
          break;
        case 5:
          controls[0]=limits[3]/s;
          controls[1]=0;
          controls[2]=0;
          evadeClock++;
          break;
        case 6:
          controls[0]=limits[3]/s;
          controls[1]=0;
          controls[2]=limits[7]/s;
          evadeClock++;
          break;
        }
      }
      if(hp>=0&&det){
        hp=-1;
        for(int k = 0; k < 10; k++){
          for(int l = 0; l < 10; l++){
            newSmoke(pos[0],pos[1],pos[2],150*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),150*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),150*m/s*sin(k*TWO_PI/10),5,.05,255,2,255,125,0,75);
          }
        }
        for(int k = 0; k < 10; k++){
          for(int l = 0; l < 10; l++){
            newSmoke(pos[0],pos[1],pos[2],75*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),75*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),75*m/s*sin(k*TWO_PI/10),5,.5,125,2,125,125,125,75);
          }
        }

        for(int i = 0; i < planes.length; i++){
          if(i!=iAm){
            if(dist(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],pos[0],pos[1],pos[2])<1536){
              planes[i].hp-=101;
              for(int k = 0; k < 10; k++){
                for(int l = 0; l < 10; l++){
                  newSmoke(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],150*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),150*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),150*m/s*sin(k*TWO_PI/10),5,.05,255,2,255,125,0,75);
                }
              }
              for(int k = 0; k < 10; k++){
                for(int l = 0; l < 10; l++){
                  newSmoke(planes[i].pos[0],planes[i].pos[1],planes[i].pos[2],75*m/s*cos(k*TWO_PI/10)*cos(l*TWO_PI/10),75*m/s*cos(k*TWO_PI/10)*sin(l*TWO_PI/10),75*m/s*sin(k*TWO_PI/10),5,.5,125,2,125,125,125,150);
                }
              }
            }
          } 
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
          rvel[i]+=PI/100;
        }
        if(controls[i]<rvel[i]){
          rvel[i]-=PI/100; 
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
    if(((bAi==true)||freeLook!=0)&&frameCount%2==0){
    for(int i = 0; i < emiters.length; i++){
      vector = M.MMulti(emiters[i][0],emiters[i][1],emiters[i][2]);
      newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],0,0,0,emiters[i][3],emiters[i][4],emiters[i][5],emiters[i][6],emiters[i][7],emiters[i][8],emiters[i][9],int(emiters[i][10])); 
    }
    }else{
          for(int i = 0; i < emiters.length; i++){
      vector = M.MMulti(emiters[i][0],emiters[i][1],emiters[i][2]);
      newSmoke(pos[0]+vector[0],pos[1]+vector[1],pos[2]+vector[2],0,0,0,emiters[i][3],emiters[i][4],emiters[i][5],emiters[i][6],emiters[i][7],emiters[i][8],emiters[i][9],4); 
    }
    }
  }
  void draw(){
    float[] vector = new float[3];
    vector[0]=pos[0]-fCamera[0];
    vector[1]=pos[1]-fCamera[1];
    vector[2]=pos[2]-fCamera[2];
    vector = cam.MMulti(vector[0],vector[1],vector[2]);
    if(vector[2]<=0){
    //fill(colorGroups[group][0]*hp/100,colorGroups[group][1]*hp/100,colorGroups[group][2]*hp/100);
    stroke(colorGroups[group][0]*hp/100,colorGroups[group][1]*hp/100,colorGroups[group][2]*hp/100);
    noFill();
    sModels[model].draw(pos[0],pos[1],pos[2],r[0],r[1],r[2]);
     //        int iSideLength=floor(max(16,2*(screenX(width/2+5,height/2,vector[2]+cameraZ)-width/2)));
   // ellipse(screenX(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),screenY(vector[0]+width/2,vector[1]+height/2,vector[2]+cameraZ),iSideLength,iSideLength);
    }
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
