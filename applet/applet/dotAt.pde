M4 cam = new M4();
vector pCam = new vector();
class dotRender{
  /*PImage[] tex = new PImage[0];
   color nullC = color(0,0,0);
   int[] wTex=new int[0];
   vector[] p=new vector[0];
   float[] r = new float[0];
   vector[] tP;
   float[] tR;
   color[] tC;
   int[] tW;*/
  color[] lC=new color[0];
  vector[][] lP=new vector[0][2];
  vector[] points = new vector[0];
  color[] pC=new color[0];
  color back;
  int eq = -1;
  int curLine=-1;
  int curPoint=-1;
  int maxDot=-1;
  int maxLine=-1;
  int maxPoint=-1;
  float dPoint=-1;
  float dLine=-1;
  int[] lineDist;
  int[] pointDist;
  int lineFade;
  int pointFade;
  color nullC=color(255);
  dotRender(int lines,int pts,int lDrawDist,int pDrawDist,color backgrnd){
    back=backgrnd;
    lineFade=lDrawDist;
    pointFade=pDrawDist;
    points=new vector[pts];
    pC=new color[pts];
    pointDist=new int[pts];
    lP=new vector[lines][2];
    lineDist=new int[lines];
    lC=new color[lines];

  }
  void addPoint(vector nP,color c){
    nP = (nP.vMinus(pCam)).vMRot(cam);
    int d = floor(nP.vMag());
    if(nP.z()<0&&d<pointFade){
      if(curPoint<points.length-1){
        curPoint++;
        points[curPoint]=nP;
        pC[curPoint]=c;
        if(d>dPoint){
          dPoint=nP.vMag();
          maxPoint=curPoint; 
          pointDist[curPoint]=d;
        }
      }
      else{
        if(d<dPoint){
          points[maxPoint]=nP;
          pC[maxPoint]=c;
          pointDist[maxPoint]=d;
          maxPoint=-1;
          dPoint=-1;
          for(int i = 0; i < points.length;i++){
            if(pointDist[i]>dPoint){
              dPoint=pointDist[i];
              maxPoint=i;
            } 
          }
        }
      }
    }
  }
  void addPoint(vector nP){
    nP = (nP.vMinus(pCam)).vMRot(cam);
    int d = floor(nP.vMag());
    if(nP.z()<0&&d<pointFade){
      if(curPoint<points.length-1){
        curPoint++;
        points[curPoint]=nP;
        pC[curPoint]=nullC;
        if(d>dPoint){
          dPoint=nP.vMag();
          maxPoint=curPoint; 
          pointDist[curPoint]=d;
        }
      }
      else{
        if(d<dPoint){
          points[maxPoint]=nP;
          pC[maxPoint]=nullC;
          pointDist[maxPoint]=d;
          dPoint=-1;
          maxPoint=-1;
          for(int i = 0; i < points.length;i++){
            if(pointDist[i]>dPoint){
              dPoint=pointDist[i];
              maxPoint=i;
            } 
          }
        }
      }
    }
  }
  void addLine(vector start, vector end, color col){
    start=(start.vMinus(pCam)).vMRot(cam);
    end=(end.vMinus(pCam)).vMRot(cam);
    int d=floor(min(start.vMag(),end.vMag()));
    if(curLine<lP.length-1&&d<lineFade){
      curLine++;
      lP[curLine][0]=start;
      lP[curLine][1]=end;
      lC[curLine]=col;
      lineDist[curLine]=d;
      if(d>dLine){
        dLine=d;
        maxLine=curLine;
      }
    }
    else{
      if(d<dLine){
        lP[maxLine][0]=start;
        lP[maxLine][1]=end;
        lC[maxLine]=col;
        lineDist[maxLine]=d;
        dLine=-1;
        for(int i = 0; i < lP.length;i++){
          if(lineDist[i]>dLine){
            dLine=lineDist[i];
            maxLine=i;
          } 
        }
      }
    }
  }
  void draw3(){
    background(back);
    loadPixels();
    float x=0;
    float y=0;
    float x1=0;
    float y1=0;
    float mole=0;
    float k = cameraZ;
    for(int i = 0; i <= curLine; i++){
      if(lP[i][0].z()<0||lP[i][1].z()<0){
        if(lP[i][0].z()>=0){
          lP[i][0]=lP[i][1].vPlus(lP[i][0].vMinus(lP[i][1]).vTimes((lP[i][1].z()+2)/(-lP[i][0].vMinus(lP[i][1]).z())));
        }
        if(lP[i][1].z()>=0){
          lP[i][1]=lP[i][0].vPlus(lP[i][1].vMinus(lP[i][0]).vTimes((lP[i][0].z()+2)/(-lP[i][1].vMinus(lP[i][0]).z())));
        }
        x=(-lP[i][0].x()*k/lP[i][0].z())+width/2;
        y=(-lP[i][0].y()*k/lP[i][0].z())+height/2;
        x1=(-lP[i][1].x()*k/lP[i][1].z())+width/2;
        y1=(-lP[i][1].y()*k/lP[i][1].z())+height/2;
        if((!(x<0&&x1<0||x1>width&&x>width))&&(!(y<0&&y1<0||y>height&&y1>height))){
          stroke(lC[i]);
          line(x,y,x1,y1);
        }
      }
    }
    for(int i = 0; i <= curPoint&&i<points.length; i++){
      if(points[i].z()<0){
        stroke(255);
        x =-points[i].x()*k/points[i].z()+width/2;
        y = -points[i].y()*k/points[i].z()+height/2;
        if(0<x&&x<width&&0<y&&y<height){
          if(0<int(y*width+x)&&int(y*width+x)<width*height){
            //point(x,y);
            y=floor(y);
            x=floor(x);
            pixels[int(y*width+x)]=pC[i];
          }
        }
      } 
    }
    updatePixels();
    curPoint=-1;
    dPoint=-1;
    maxPoint=-1;
    curLine=-1;
    dLine=-1;
    maxLine=-1;
  }
}

