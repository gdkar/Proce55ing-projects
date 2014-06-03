class land{
  float[][] fTiles;
  float r;
  land(int x, int y, int tr){
    float translation = millis();
    fTiles = new float[x][y];
    r = tr;
    float lowest = 1000000;
    for(int i = 0; i <fTiles.length; i++){
      for(int j = 0; j < fTiles[0].length; j++){
        fTiles[i][j] = noise(i*.05+translation,j*.05)*(r*32);
        if(fTiles[i][j]<lowest){
          lowest = fTiles[i][j];
        }
      }
    }
    for(int i = 0; i < fTiles.length;i++){
      for(int j = 0; j < fTiles[0].length; j++){
        fTiles[i][j]-=lowest;
      } 
    }
  }
  void draw(){
    noStroke();
    fill(59);
    beginShape(TRIANGLES);
    float[][] verts = new float[4][4];
    for(int i = 0; i < fTiles.length-1; i++){
      for(int j = 0; j < fTiles[0].length-1; j++){
        verts[0] = cam.MMulti(i*r-fCamera[0],fTiles[i][j]-fCamera[1],j*r-fCamera[2]);
        verts[1] = cam.MMulti((i+1)*r-fCamera[0],fTiles[i+1][j]-fCamera[1],j*r-fCamera[2]);
        verts[2] = cam.MMulti((i+1)*r-fCamera[0],fTiles[i+1][j+1]-fCamera[1],(j+1)*r-fCamera[2]);
        verts[3] = cam.MMulti(i*r-fCamera[0],fTiles[i][j+1]-fCamera[1],(j+1)*r-fCamera[2]);
        vertex(verts[0][0],verts[0][1],verts[0][2]);
        vertex(verts[1][0],verts[1][1],verts[1][2]);
        vertex(verts[2][0],verts[2][1],verts[2][2]);
        vertex(verts[0][0],verts[0][1],verts[0][2]);
        vertex(verts[3][0],verts[3][1],verts[3][2]);
        vertex(verts[2][0],verts[2][1],verts[2][2]);
      } 
    }
    endShape();
  }
  boolean impact(float x, float y, float z){
    int[] which = new int[2];
    which[0]=round(x/r);
    which[1]=round(z/r);
    if(which[0]*r>x){
      which[0]--; 
    }
    if(which[1]*r>z){
      which[1]--; 
    }
    if(which[0]<0)
      which[0]=0;
    if(which[1]<0)
      which[1]=0;
    float depth = lerp(fTiles[which[0]][which[1]],fTiles[which[0]+1][which[1]],(x-which[0]*r)/r)+lerp(fTiles[which[0]][which[1]],fTiles[which[0]][which[1]+1],(z-which[1]*r)/r)-fTiles[which[0]][which[1]];
    return(y>depth);
  }
  float gLevel(float x, float z){
    int[] which = new int[2];
    which[0]=round(x/r);
    which[1]=round(z/r);
    if(which[0]*r>x){
      which[0]--; 
    }
    if(which[1]*r>z){
      which[1]--; 
    }
    if(which[0]<0)
      which[0]=0;
    if(which[1]<0)
      which[1]=0;
    float depth = lerp(fTiles[which[0]][which[1]],fTiles[which[0]+1][which[1]],(x-which[0]*r)/r)+lerp(fTiles[which[0]][which[1]],fTiles[which[0]][which[1]+1],(z-which[1]*r)/r)-fTiles[which[0]][which[1]];
    return(depth);
  }
}
