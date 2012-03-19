class particle{
  boolean bBullet = false;
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
  particle(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage){
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
      tx-=vPos.x();
      ty-=vPos.y();
      tz-=vPos.z();
      vector = cam.MMulti(tx,ty,tz);
      tx = vector[0]+width/2;
      ty = vector[1]+height/2;
      tz = vector[2]+cameraZ;
      float r = (s0+(frames*ls)+(sq(frames)*qs));
      if(tz<cameraZ){
        fill(red(c),green(c),blue(c),a0-(frames*la)-(sq(frames)*qa));
        float cos30 = cos(PI/6);
        beginShape(TRIANGLES);
        vertex(tx,ty-r,tz);
        vertex(tx+(cos30*r), ty+.5*r, tz);
        vertex(tx-(cos30*r), ty+.5*r, tz);
        endShape();
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
void newSmoke(float tx,float ty,float tz,float txv, float tyv, float tzv, float ts0,float tr,float tg,float tb, int tdur,float tdamage){
  boolean already = false;
  for(int i = 0; i < smoke.length; i++){
    if(smoke[i].active == false){
      smoke[i] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage);
      already = true;
      i = smoke.length;
    } 
  }
  if(!already){
    particle[] tSmoke= new particle[smoke.length+1];
    for(int i = 0; i < smoke.length; i++){
      tSmoke[i] = smoke[i]; 
    }
    tSmoke[tSmoke.length-1] = new particle(tx,ty,tz,txv,tyv,tzv,ts0,tr,tg,tb,tdur,tdamage);
    smoke = tSmoke;
  }
}
void smokeUpdate(){
  for(int i = 0; i < smoke.length; i++){
    smoke[i].upDate();
  } 
}
