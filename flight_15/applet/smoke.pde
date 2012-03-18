class particle{
  boolean bBullet = false;
  int firedBy = -1;
  float damage;
  float x=0;
  float y=0;
  float z=0;
  float s0=0;
  float qs=0;
  float ls=0;
  float a0=0;
  float la=0;
  float qa=0;
  float xv;
  float yv;
  float zv;
  color c = color(255,255,255);
  int dur=25;
  int frames;
  boolean active = true;  
  particle(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage,int from){
    firedBy=from;
    bBullet = true;
    damage = tdamage;
    x = tx;
    y = ty;
    z = tz;
    s0 = ts0;
    ls = 0;
    a0 = 255;
    la = 0;
    xv = txv;
    yv = tyv;
    zv = tzv;
    c = color(tr,tg,tb);
    dur = tdur; 
    active = true;
  }
  particle(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tls,float ta0,float tla,float tr,float tg,float tb,int tdur){
    bBullet = false;
    x = tx;
    y = ty;
    z = tz;
    s0 = ts0;
    ls = tls;
    a0 = ta0;
    la = tla;
    xv = txv;
    yv = tyv;
    zv = tzv;
    c = color(tr,tg,tb);
    dur = tdur; 
    active = true;
  }
  void upDate(){

    if(active){

      frames +=1;
      x+=xv*m/s;
      y+=yv*m/s;
      z+=zv*m/s;
      if(frames>dur){
        active = false; 
      }
      float tx = x;
      float ty = y;
      float tz = z;
      float[] vector=new float[4];
      tx-=fCamera[0];
      ty-=fCamera[1];
      tz-=fCamera[2];
      vector = cam.MMulti(tx,ty,tz);
      tx = vector[0]+width/2;
      ty = vector[1]+height/2;
      tz = vector[2]+cameraZ;
      if(tz<cameraZ){
        fill(red(c),green(c),blue(c),a0-(frames*la)-(sq(frames)*qa));
        float r = (s0+(frames*ls)+(sq(frames)*qs));
        float cos30 = cos(PI/6);
        /*
        beginShape(TRIANGLES);
        vertex(tx,ty-r,tz);
        vertex(tx+(cos30*r), ty+.5*r, tz);
        vertex(tx-(cos30*r), ty+.5*r, tz);
        */
        beginShape(POLYGON);
        vertex(tx,ty-r,tz);
        vertex(tx+(cos30*r),ty-.5*r,tz);
        vertex(tx+(cos30*r),ty+.5*r,tz);
                vertex(tx,ty+r,tz);
                vertex(tx-(cos30*r),ty+.5*r,tz);
                        vertex(tx-(cos30*r),ty-.5*r,tz);
        endShape();
      }
      if(bBullet){
        boolean cont = true;
        M4 M = new M4();
          if(y>terrain.heightAt(x,z)){
            cont = false;
    
            boomRand(x,y,z,6,max(64,floor(16*damage)),max(128,floor(32*damage)),32);
            active = false;
            terrain.write(x,z,color(0,0,0));
            terrain.crater(x,z,(max(512,64*damage)),max(32,32*damage));
          }
        if(frames>0){
          stroke(225);
          float[][] verts = new float[2][4];
          verts[0]=cam.MMulti(x-fCamera[0],y-fCamera[1],z-fCamera[2]);
          verts[1]=cam.MMulti(x-xv*m/s-fCamera[0],y-yv*m/s-fCamera[1],z-zv*m/s-fCamera[2]);
          line(verts[0][0]+width/2,verts[0][1]+height/2,verts[0][2]+cameraZ,verts[1][0]+width/2,verts[1][1]+height/2,verts[1][2]+cameraZ);
          noStroke(); 
        }
        for(int i = 0; i < planes.length&&cont; i++){
                      if(i!=firedBy){
          M.MRot(planes[i].r[0],planes[i].r[1],planes[i].r[2]);
          for(int j = 0; j < planes[i].impacts.length&&cont; j++){
            vector = M.MMulti(planes[i].impacts[j][0],planes[i].impacts[j][1],planes[i].impacts[j][2]);
            if(cubeSphere(x,y,z,s0,planes[i].pos[0]+vector[0],planes[i].pos[1]+vector[1],planes[i].pos[2]+vector[2],planes[i].impacts[j][3]/2,
            planes[i].impacts[j][4]/2,planes[i].impacts[j][5]/2,planes[i].r[0],planes[i].r[1],planes[i].r[2])||
              (frames>=0&&cubeSeg(x,y,z,x-xv*m/s,y-yv*m/s,z-zv*m/s,planes[i].pos[0]+vector[0],planes[i].pos[1]+vector[1],planes[i].pos[2]+vector[2]
              ,planes[i].impacts[j][3]/2, planes[i].impacts[j][4]/2,planes[i].impacts[j][5]/2,planes[i].r[0],planes[i].r[1],planes[i].r[2]))){
              planes[i].hp-=damage*planes[i].impacts[j][6];
              cont = false;
              boomRand(x,y,z,3,floor(8*damage*planes[i].impacts[j][6]),floor(16*damage*planes[i].impacts[j][6]),16);
              if(planes[i].hp+damage*planes[i].impacts[j][6]>=0&&planes[i].hp<0){
                boomRand(x,y,z,32,512,512,90);
                if(planes[i].group!=planes[firedBy].group){
                  wins[planes[firedBy].group]++;
                  planes[firedBy].kills++;
                }
              }
              active=false;
            }
          }
          }
        }

      }
    }
  }
}
void newSmoke(float tx,float ty,float tz,float txv,float tyv,float tzv,float ts0,float tls,float ta0,float tla,float tr,float tg,float tb,int tdur){
  boolean already = false;
  for(int i = 0; i < smoke.length; i++){
    if(smoke[i].active == false){
      smoke[i] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tls,ta0,tla,tr,tg,tb,tdur);
      already = true;
      i = smoke.length;
    } 
  }
  if(!already){
    particle[] tSmoke= new particle[smoke.length+1];
    for(int i = 0; i < smoke.length; i++){
      tSmoke[i] = smoke[i]; 
    }
    tSmoke[tSmoke.length-1] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tls,ta0,tla,tr,tg,tb,tdur);
    smoke = tSmoke;
  }
}
void newSmoke(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage, int from){
  boolean already = false;
  for(int i = 0; i < smoke.length; i++){
    if(smoke[i].active == false){
      smoke[i] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage,from);
      already = true;
      i = smoke.length;
    } 
  }
  if(!already){
    particle[] tSmoke= new particle[smoke.length+1];
    for(int i = 0; i < smoke.length; i++){
      tSmoke[i] = smoke[i]; 
    }
    tSmoke[tSmoke.length-1] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage,from);
    smoke = tSmoke;
  }
}
void smokeUpdate(){
  for(int i = 0; i < smoke.length; i++){
    smoke[i].upDate();
  } 
}
void boomRand(float x, float y, float z, int n, int r1, int r2, int t){
for(int Blah = 0; Blah < n; Blah++){
  newSmoke(x+random(-r1,r1),y+random(-r1,r1),z+random(-r1,r1),random(-16,16),random(-16,16),random(-16,16),1,r1/t-1,64,-64/t,255,125,0,t);
  newSmoke(x+random(-r2,r2),y+random(-r2,r2),z+random(-r2,r2),random(-16,16),random(-16,16),random(-16,16),1,r2/t-1,32,-32/t,125,125,125,t);
}
}
