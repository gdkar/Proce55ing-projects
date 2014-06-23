class block{
  bding[] builds = new bding[0];
  vector p=new vector(0,0,0);
  block(){
  }
  void addBuilding(vector pAt, int x, int y, int z){
    bding[] tb = new bding[builds.length+1];
    for(int i = 0; i < builds.length;i++){
      tb[i]=builds[i]; 
    }
    tb[tb.length-1]=new bding(pAt,x,y,z);
    builds=tb;
  }
  void draw(){
    for(int i = 0; i < builds.length; i++){
      if(builds[i].health<0&&frameCount%5==0){
        builds[i].y=max(0,builds[i].y-1); 
      }
      builds[i].draw(p); 
    }
  }
  boolean bIn(vector pAt){
    vector nP=pAt.vMinus(p);
    for(int i = 0; i < builds.length; i++){
      if(builds[i].p.x()<=nP.x()&&builds[i].x+builds[i].p.x()>nP.x()&&builds[i].p.y()>=nP.y()&&builds[i].p.y()-builds[i].y<nP.y()&&builds[i].p.z()<=nP.z()&&builds[i].z+builds[i].p.z()>nP.z()){
        return true; 
      }
    }
    return false;
  }
  vector center(int i){
    if(0<=i&&i<builds.length){
      return(builds[i].center(p)); 
    }
    return new vector();
  }
  float rad(int i){
    if(0<=i&&i<builds.length){
      return(builds[i].rad());
    }
    return(0);
  }
  imp hit(vector s, vector e){
    imp h1,h2;
    h1=new imp();
    h2=new imp();
    vector c=new vector();
    float r=0;
    float v=(e.vMinus(s).vMag());
    vector newE=new vector();
    newE.x(s.x()/bw-p.x());
    newE.y(s.y()/bh-p.y());
    newE.z(s.z()/bw-p.z());
    vector ext = new vector();
    ext=e.vMinus(s);
    ext.x(abs(ext.x/bw));
    ext.y(abs(ext.y/bw));
    ext.z(abs(ext.z/bw));

    for(int i = 0; i < builds.length; i++){
      if(builds[i].p.x()-ext.x()<newE.x()&&newE.x()<builds[i].p.x()+builds[i].x+ext.x()&&builds[i].p.y()+ext.y()>newE.y()&&newE.y()>builds[i].p.y()-builds[i].y-ext.y()&&builds[i].p.z()-ext.z()<newE.z()&&newE.z()<builds[i].p.z()+builds[i].z+ext.z()){
        h2=builds[i].hit(p,s,e); 
        if((h2.t()>0&&h2.t()<h1.t())||h1.t()<0){
          h1=h2;
          h1.iHit(i);
        }
      }
    }
    return h1;  
  }
}
class bding{
  vector init=new vector();
  vector fin = new vector();
  imp[] imps = new imp[3];
  vector to;
  vector tAt;
  vector nP;
  float health=100;
  vector p;
  int x,y,z;
  vector ext;
  color c;
  bding(vector p1,int x1,int y1, int z1){
    p=p1;
    x=x1;
    y=y1;
    z=z1;
    ext=new vector(x,y,z);
    c=color(255);
  }
  bding(vector p1,int x1,int y1, int z1,color c1){
    p=p1;
    x=x1;
    y=y1;
    z=z1;
    ext=new vector(x,y,z);
    c=c1;
  }
  vector center(vector orig){
    return  new vector((p.x()+float(x)/2+orig.x())*bw,(p.y()-float(y)/2+orig.y())*bh,(p.z()+float(z)/2+orig.z())*bw);
  }
  float rad(){
    return(mag(x*bw,y*bh,z*bw)/2); 
  }
  imp hit(vector orig,vector e,vector s){
    for(int i = 0; i < imps.length; i++){
      imps[i]=new imp(new vector(),new vector(),-1); 
    }
    init.x(e.x()/bw);
    init.y(e.y()/bh);
    init.z(e.z()/bw);
    fin.x(s.x()/bw);
    fin.y(s.y()/bh);
    fin.z(s.z()/bw);
    to = fin.vMinus(init);
    tAt = new vector();
    nP=p.vPlus(orig);
    if(init.x()<nP.x()&&fin.x()>nP.x()){
      tAt=init.vPlus(to.vTimes((nP.x()-init.x())/to.x()));
      if(nP.y()>tAt.y()&&tAt.y()>nP.y()-y&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[0]=new imp(tAt,new vector(-1,0,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.x()>nP.x()+x&&fin.x()<nP.x()+x){
      tAt=init.vPlus(to.vTimes((nP.x()+x-init.x())/to.x()));
      if(nP.y()>tAt.y()&&tAt.y()>nP.y()-y&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[0]=new imp(tAt,new vector(1,0,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.y()>nP.y()&&fin.y()<nP.y()){
      tAt=init.vPlus(to.vTimes((nP.y()-init.y())/to.y()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[1]=new imp(tAt,new vector(0,1,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.y()<nP.y()-y&&fin.y()>nP.y()-y){
      tAt=init.vPlus(to.vTimes((nP.y()-y-init.y())/to.y()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.z()<tAt.z()&&tAt.z()<nP.z()+z){
        imps[1]=new imp(tAt,new vector(0,-1,0),tAt.vMinus(init).vMag());
      }
    }
    if(init.z()<nP.z()&&fin.z()>nP.z()){
      tAt=init.vPlus(to.vTimes((nP.z()-init.z())/to.z()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.y()>tAt.y()&&tAt.y()>nP.y()-y){
        imps[2]=new imp(tAt,new vector(0,0,-1),tAt.vMinus(init).vMag());
      }
    }
    if(init.z()>nP.z()+z&&fin.z()<nP.z()+z){
      tAt=init.vPlus(to.vTimes((nP.z()+z-init.z())/to.z()));
      if(nP.x()<tAt.x()&&tAt.x()<nP.x()+x&&nP.y()>tAt.y()&&tAt.y()>nP.y()-y){
        imps[2]=new imp(tAt,new vector(0,0,1),tAt.vMinus(init).vMag());
      }
    }
    for(int i = 0; i < imps.length; i++){
      imps[i].p.x(imps[i].p.x()*bw);
      imps[i].p.y(imps[i].p.y()*bh);
      imps[i].p.z(imps[i].p.z()*bw); 
    }
    float goodness=imps[0].t();
    int best=0;
    for(int i = 0; i < imps.length; i++){
      if((imps[i].t()<goodness&&imps[i].t()>=0)||(goodness<0&&imps[i].t()>=0)){
        goodness=imps[i].t();
        best=i;
      }
    }
    if(goodness>=0){
      return(imps[best]);
    }
    return new imp();
  }
  void draw(vector orig){
    vector[] verts = new vector[8];
    vector start=new vector();
    vector end = new vector();
    vector nP = p.vPlus(orig);
    nP.x(nP.x()-pCam.x()/bw);
    nP.y(nP.y()-pCam.y()/bw);
    nP.z(nP.z()-pCam.z()/bw);
    int dZone = 0;
    if(nP.x()*bw>d0||(nP.x()+x)*bw<-d0||nP.y()*bh<-d0||(nP.y()-y)*bh>d0||nP.z()*bw>d0||(nP.z()+z)*bw<-d0){
      dZone=1; 
    }
    if(nP.x()*bw>d1||(nP.x()+x)*bw<-d1||nP.y()*bh<-d1||(nP.y()-y)*bh>d1||nP.z()*bw>d1||(nP.z()+z)*bw<-d1){
      dZone=2; 
    }
    if(nP.x()*bw>d2||(nP.x()+x)*bw<-d2||nP.y()*bh<-d2||(nP.y()-y)*bh>d2||nP.z()*bw>d2||(nP.z()+z)*bw<-d2){
      dZone=3; 
    }
    if(nP.x()*bw>d3||(nP.x()+x)*bw<-d3||nP.y()*bh<-d3||(nP.y()-y)*bh>d3||nP.z()*bw>d3||(nP.z()+z)*bw<-d3){
      dZone=4; 
    }
    if(nP.x()*bw>d4||(nP.x()+x)*bw<-d4||nP.y()*bh<-d4||(nP.y()-y)*bh>d4||nP.z()*bw>d4||(nP.z()+z)*bw<-d4){
      dZone=5; 
    }
    if(nP.x()*bw>d5||(nP.x()+x)*bw<-d5||nP.y()*bh<-d5||(nP.y()-y)*bh>d5||nP.z()*bw>d5||(nP.z()+z)*bw<-d5){
      dZone=6; 
    }
    vector nNP = (nP.vMRot(cam));
    nP.y(nP.y()-y);
    nP = (nP.vMRot(cam));
    if(nP.z()<(x+y)&&nNP.z()<(x+y)){
      nP = p.vPlus(orig);

      if(dZone==6){
        /*start.x((nP.x()+x/2)*bw);
         start.y((nP.y())*bh);
         start.z((nP.z()+z/2)*bw);
         end.x((nP.x()+x/2)*bw);
         end.y((nP.y()-y)*bh);
         end.z((nP.z()+z/2)*bw);
         //render.addLine(start,end,c);
         render.addDot(start,bw*(x+z)/4,c);
         render.addDot(end,bw*(x+z)/4,c);
         render.addLine(start,end,c);*/
      }
      if(dZone<=5){
        int b1,b2,b3;
        b1=int(nP.x());
        b2=int(nP.y());
        b3=int(nP.z());
        int x1,x2,x3;
        int y1,y2;
        y1=floor(d3/bw);
        y2=floor(d3/bh);
        int y3,y4;
        y3=floor(d2/bw);
        y4=floor(d2/bw);
        x1=int(pCam.x());
        x2=int(pCam.y());
        x3=int(pCam.z());
        x1=floor(x1/bw);
        x2=floor(x2/bh);
        x3=floor(x3/bw);
        float d=0;
        float n=0;
        color c1;
        d=min(abs(b1-x1),abs(b1+x-x1));
        d=min(d,abs(b3-x3));
        d=min(d,abs(b3+z-x3));
        if(dZone<=1){
          start.y(max(nP.y()-y,x2-2)*bh);
          end.y(min(nP.y(),x2+2)*bh);
          for(int i = 0; i < verts.length; i++){
            verts[i]=new vector();
            if(i<4){
              verts[i].y(max(nP.y()-y,x2-2)*bh); 
            }
            else{
              verts[i].y(min(nP.y(),x2+2)*bh); 
            }
            verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
            if(i%4<2){
              verts[i].x((nP.x())*bw); 
            }
            else{
              verts[i].x((nP.x()+x)*bw); 
            }
            if((i+1)%4<2){
              verts[i].z((nP.z())*bw); 
            }
            else{
              verts[i].z((nP.z()+z)*bw); 
            }
          }
          c1 = color(32);
          for(int i = 0; i < 4; i++){
            render.addLine(verts[i],verts[(i+1)%4],c1);
            render.addLine(verts[i+4],verts[((i+1)%4)+4],c1);
          }
          for(int i = 0; i < verts.length; i++){
            if(i<4){
              verts[i].y(max(nP.y()-y,x2-12)*bh); 
            }
            else{
              verts[i].y(min(nP.y(),x2+12)*bh); 
            }
            verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
          }
          for(int i = 0; i < 4; i++){
            render.addLine(verts[i],verts[i+4],c1); 
          }
          if(dZone==0){
            for(int i = 0; i < verts.length; i++){
              if(i<4){
                verts[i].y(max(nP.y()-y,x2-1)*bh); 
              }
              else{
                verts[i].y(min(nP.y(),x2+1)*bh); 
              }
              verts[i].y(constrain(verts[i].y(),(nP.y()-y)*bh,(nP.y*bh)));
            }
            c1 = color(48);
            for(int i = 0; i < 4; i++){
              render.addLine(verts[i],verts[(i+1)%4],c1);
              render.addLine(verts[i+4],verts[((i+1)%4)+4],c1);
            }
            for(int i = 0; i < 4; i++){
              verts[i].y(constrain(x2,nP.y()-y,nP.y())*bh); 
            }
            c1 = color(64);
            for(int i = 0; i < 4; i++){
              render.addLine(verts[i],verts[(i+1)%4],c1); 
            }
          }
        }
        if(dZone<5){
          for(int i = b2-y;i<=b2; i+=int(pow(2,dZone))){
            start.y((nP.y()+i)*bh);
            start.x((nP.x())*bw);
            start.z((nP.z())*bw);
            render.addPoint(start);
            start.x((nP.x()+x)*bw);
            render.addPoint(start);
            start.z((nP.z()+z)*bw);
            render.addPoint(start);
            start.x((nP.x()*bw));
            render.addPoint(start);
          }
        }
        else{
          for(int i = b2-y;i<=b2; i+= y){
            start.y((nP.y()+i)*bh);
            start.x((nP.x())*bw);
            start.z((nP.z())*bw);
            render.addPoint(start);
            start.x((nP.x()+x)*bw);
            render.addPoint(start);
            start.z((nP.z()+z)*bw);
            render.addPoint(start);
            start.x((nP.x()*bw));
            render.addPoint(start);
          }
        }

        /*if(b2-y>x2-y4&&b2-y<x2+y4){
         start.y((b2-y)*bh);
         d=max(0,abs(b2-y-x2)-1)/float(y4);
         n=1-d;
         c1=color(n*red(c),n*green(c),n*blue(c));
         println("hi");
         for(int i = 0; i <= x; i+=1){
         for(int j = 0; j<=z; j+=1){
         start.x((b1+i)*bw);
         start.z((b3+j)*bw);
         render.addDot(start,bw/16,c1);
         }
         } 
         }
         if(b2>x2-y4&&b2-y<x2+y4){
         for(int k = max(b2-y,x2-y4);k<=min(b2,x2+y4);k+=1){
         start.y((k)*bh);
         d=max(0,abs(k-x2)-1)/float(y4);
         n=1-d;
         c1=color(n*red(c),n*green(c),n*blue(c));
         for(int i = 0; i <= x; i+=2){
         start.x((nP.x()+i)*bw);
         start.z((nP.z())*bw);
         render.addDot(start,bw/16,c1);
         start.z((nP.z()+z)*bw);
         render.addDot(start,bw/16,c1);
         }
         for(int i = 1; i <= z; i+=2){
         start.x((nP.x())*bw);
         start.z((nP.z()+i)*bw);
         render.addDot(start,bw/16,c1);
         start.x((nP.x()+x)*bw);
         render.addDot(start,bw/16,c1);
         }
         }
         }*/
      }
    }
  }
}
