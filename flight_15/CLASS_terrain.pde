class map{
  int mType = 0;
  float[][] fHeight=new float[0][0];
  float yScale;
  float tile;
  float rScale;
  float rTrans;
      vector[][] verts;
  map(int iWidth, int iDepth,float tileSize,float randomScale, float heightScale, String texName, int iType){
    yScale = heightScale;
    rScale = randomScale;
    mType = iType;
    fHeight=new float[iWidth][iDepth];
    tile = tileSize;
    float randomTrans = millis();
    rTrans=randomTrans;
     verts = new vector[fHeight.length][fHeight[0].length];
  }
  void draw(){
    vector[] vCamera=new vector[2];
    vCamera[0]=new vector(fCamera[0],fCamera[1],fCamera[2]);
    vCamera[1]=new vector(fCamera[3],fCamera[4],fCamera[5]);
    float[] fTri=new float[4];
    noStroke();
    textureMode(NORMALIZED);

    vector vNorm;
    vector v1;
    vector v2;
    int x, y;
    x=floor(fCamera[0]/tile-verts.length/2.);
    y=floor(fCamera[2]/tile-verts[0].length/2.);
    for(int i = 0; i < verts.length; i++){
      for(int j = 0; j < verts.length; j++){
        fTri=cam.MMulti((i+x)*tile-vCamera[0].x(),(noise((i+x)*rScale,(j+y)*rScale,rTrans)*yScale)*tile-vCamera[0].y(),(j+y)*tile-vCamera[0].z());
        verts[i][j]=new vector(fTri[0]+width/2,fTri[1]+height/2,fTri[2]+cameraZ);
      } 
    }
    for(int i = 0; i < verts.length-1; i++){
      beginShape(TRIANGLE_STRIP);       
      if(bGround){
        noStroke();
       fill(255,255,255); 
      }else{
        stroke(0,255,0);

        fill(255,255,255,63);
                noFill();
      }
      for(int j = 0; j < verts[0].length-1;j++){
        vertex(verts[i][j].x(),verts[i][j].y(),verts[i][j].z());
        vertex(verts[i+1][j].x(),verts[i+1][j].y(),verts[i+1][j].z());

        /*         fTri[0]=M.MMulti(i*tile-vCamera[0].x(),fHeight[i][j]*tile-vCamera[0].y(),j*tile-vCamera[0].z());
         fTri[1]=M.MMulti(i*tile-vCamera[0].x(),fHeight[i][j+1]*tile-vCamera[0].y(),(j+1)*tile-vCamera[0].z());
         fTri[2]=M.MMulti((i+1)*tile-vCamera[0].x(),fHeight[i+1][j+1]*tile-vCamera[0].y(),(j+1)*tile-vCamera[0].z());
         vertex(fTri[0][0]+width/2,fTri[0][1]+height/2,fTri[0][2]+cameraZ);
         vertex(fTri[1][0]+width/2,fTri[1][1]+height/2,fTri[1][2]+cameraZ);
         vertex(fTri[2][0]+width/2,fTri[2][1]+height/2,fTri[2][2]+cameraZ);
         fTri[0]=M.MMulti(i*tile-vCamera[0].x(),fHeight[i][j]*tile-vCamera[0].y(),j*tile-vCamera[0].z());
         fTri[1]=M.MMulti((i+1)*tile-vCamera[0].x(),fHeight[i+1][j]*tile-vCamera[0].y(),(j)*tile-vCamera[0].z());
         fTri[2]=M.MMulti((i+1)*tile-vCamera[0].x(),fHeight[i+1][j+1]*tile-vCamera[0].y(),(j+1)*tile-vCamera[0].z());
         vertex(fTri[0][0]+width/2,fTri[0][1]+height/2,fTri[0][2]+cameraZ);
         vertex(fTri[1][0]+width/2,fTri[1][1]+height/2,fTri[1][2]+cameraZ);
         vertex(fTri[2][0]+width/2,fTri[2][1]+height/2,fTri[2][2]+cameraZ);*/
      }
      endShape();
    }
  }
  void write(float x, float y, color c){
  }
  void write(float x, float y,float w, float h, color c){
  }
  void crater(float x, float y, float r, float d){
  }
  float heightAt(float x, float y){
return int( (noise((x/tile)*rScale,(y/tile)*rScale,rTrans)*yScale)*tile);
  }
}
