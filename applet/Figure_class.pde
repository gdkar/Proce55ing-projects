class fig{
  int iAm =-1;
  vector[][] l = new vector[0][2];
  color[] lc = new color[0];
  pTrail[] tTrail = new pTrail[0];
  vector[] pTrail = new vector[0];
  color[] pc = new color[0];
  vector[] points = new vector[0];
  pTrail[] tt = new pTrail[0];
  fig(){
  }
  fig(String name){
    vector[] tp;
    vector[][] tl;
    float[] tr;
    color[] tc;
    String[] data = loadStrings(name+"/model.txt");
    String[] row = new String[0];
    for(int j= 0; j < data.length; j++){
      row=split(data[j],' ');
      if(row[0].equals("line")){
        tl=new vector[l.length+1][2];
        tc=new color[lc.length+1];
        for(int i = 0; i < l.length;i++){
          tl[i]=l[i];
          tc[i]=lc[i]; 
        }
        tl[tl.length-1][0]=new vector(float(row[1]),float(row[2]),float(row[3]));
        tl[tl.length-1][1]=new vector(float(row[4]),float(row[5]),float(row[6]));
        tc[tc.length-1]=color(float(row[7]),float(row[8]),float(row[9]));
        l=tl;
        lc=tc;
      }
      if(row[0].equals("point")){
        tp=new vector[points.length+1];
        tc=new color[pc.length+1];
        for(int i = 0; i < points.length; i++){
          tp[i]=points[i];
          tc[i]=pc[i];
        } 
        tp[tp.length-1]=new vector(float(row[1]),float(row[2]),float(row[3]));
        if(row.length>=7){
          tc[tc.length-1]=color(float(row[4]),float(row[5]),float(row[6])); 
        }
        else{
          tc[tc.length-1]=render.nullC;  
        }
        pc=tc;
        points=tp;
      }
      if(row[0].equals("trail")){
        tt=new pTrail[tTrail.length+1];
        tp = new vector[pTrail.length+1];
        for(int i = 0; i < tTrail.length; i++){
          tt[i]=tTrail[i];
          tp[i]=pTrail[i];
        }
        tt[tt.length-1]=new pTrail(int(row[1]),float(row[2]));
        tp[tp.length-1]=new vector(float(row[3]),float(row[4]),float(row[5]));
        tTrail=tt;
        pTrail=tp;
      }
    }
  }
  fig(String name,color col){
    vector[] tp;
    vector[][] tl;
    float[] tr;
    color[] tc;
    String[] data = loadStrings(name+"/model.txt");
    String[] row = new String[0];
    for(int j= 0; j < data.length; j++){
      row=split(data[j],' ');
      if(row[0].equals("line")){
        tl=new vector[l.length+1][2];
        tc=new color[lc.length+1];
        for(int i = 0; i < l.length;i++){
          tl[i]=l[i];
          tc[i]=lc[i]; 
        }
        tl[tl.length-1][0]=new vector(float(row[1]),float(row[2]),float(row[3]));
        tl[tl.length-1][1]=new vector(float(row[4]),float(row[5]),float(row[6]));
        tc[tc.length-1]=col;
        l=tl;
        lc=tc;
      }
      if(row[0].equals("point")){
        tp=new vector[points.length+1];
        tc=new color[pc.length+1];
        for(int i = 0; i < points.length; i++){
          tp[i]=points[i];
          tc[i]=pc[i];
        } 
        tp[tp.length-1]=new vector(float(row[1]),float(row[2]),float(row[3]));
        if(row.length>=7){
          tc[tc.length-1]=col; 
        }
        else{
          tc[tc.length-1]=col;  
        }
        pc=tc;
        points=tp;
      }
      if(row[0].equals("trail")){
        tt=new pTrail[tTrail.length+1];
        tp = new vector[pTrail.length+1];
        for(int i = 0; i < tTrail.length; i++){
          tt[i]=tTrail[i];
          tp[i]=pTrail[i];
        }
        tt[tt.length-1]=new pTrail(int(row[1]),float(row[2]));
        tp[tp.length-1]=new vector(float(row[3]),float(row[4]),float(row[5]));
        tTrail=tt;
        pTrail=tp;
      }
    }
  }

  void draw(vector pAt, M4 rAt){
    if(pAt.vMinus(pCam).vMag()<render.lineFade){
      for(int i = 0; i < l.length; i++){
        render.addLine(pAt.vPlus(l[i][0].vMRot(rAt)),pAt.vPlus(l[i][1].vMRot(rAt)),lc[i]); 
      }
      for(int i = 0; i < tTrail.length;i++){
        tTrail[i].addPoint(pAt.vPlus(pTrail[i].vMRot(rAt)));
        tTrail[i].draw();
      }
      for(int i = 0; i < points.length; i++){
        render.addPoint(pAt.vPlus(points[i].vMRot(rAt)),pc[i]);
      }
    }
    else{
      if(pAt.vMinus(pCam).vMag()<render.pointFade){
        if(points.length>0){
          render.addPoint(pAt,pc[0]);
        }
        else{
          if(l.length>0){
            render.addPoint(pAt,lc[0]); 
          }
        }
      } 
    }
  } 

  /*void draw(vector p, QUAT r){
   //render.addDot((new vector(32,-128,-32).vMRot(r).vPlus(p)),24,color(255));
   //render.addDot((new vector(-32,-128,-32).vMRot(r).vPlus(p)),24,color(255));    
   
   render.addDot((new vector(0,-112,0).vMRot(r).vPlus(p)),48,color(255));             
   render.addDot((new vector(0,-32,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(0,48,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(64,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(112,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(-64,-48,0).vMRot(r).vPlus(p)),16,color(255));
   render.addDot((new vector(-112,-48,0).vMRot(r).vPlus(p)),16,color(255)); 
   render.addDot((new vector(-32,128,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(-64,216,0).vMRot(r).vPlus(p)),40,color(255));
   render.addDot((new vector(140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(104,-80,0).vMRot(r).vPlus(p)),8,color(255)); 
   render.addDot((new vector(32,128,0).vMRot(r).vPlus(p)),32,color(255));
   render.addDot((new vector(64,216,0).vMRot(r).vPlus(p)),40,color(255));
   render.addDot((new vector(144,-48,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(104,-80,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-144,-48,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-140,-32,0).vMRot(r).vPlus(p)),8,color(255));                 
   render.addDot((new vector(-140,-64,0).vMRot(r).vPlus(p)),8,color(255));
   render.addDot((new vector(-104,-80,0).vMRot(r).vPlus(p)),8,color(255));
   }*/
}
