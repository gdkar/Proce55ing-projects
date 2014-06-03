class SKA{
  float[][] fVerts;
  int[][] fPolys;
  float[][] fNormals;
  String sName;
  SKA(String sFileName){
    sName = sFileName;
    int fCurRow = 0;
    String[] sFile = loadStrings(sFileName);
    String[] sDataRow = new String[1];
    float[] fDataRow = new float[1];
    fCurRow = find(sFile, "VERTICES",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    fVerts = new float[int(sDataRow[1])][4];
    fCurRow+=1;
    for(int i = 0; i < fVerts.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      fVerts[i][0] = float(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fVerts[i][1] = float(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fVerts[i][2] = float(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "NORMALS",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    fNormals = new float[int(sDataRow[1])][4];
    fCurRow+=1;
    for(int i = 0; i < fVerts.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      fNormals[i][0] = float(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fNormals[i][1] = float(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fNormals[i][2] = float(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "TRIANGLE_SET",0);
      sDataRow = spRed(sFile[fCurRow],' ');
    fPolys = new int[int(sDataRow[1])][3];
    fCurRow+=1;
    for(int i = 0; i < fPolys.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      fPolys[i][0] = int(sDataRow[0].substring(0,sDataRow[0].length()-1));
      fPolys[i][1] = int(sDataRow[1].substring(0,sDataRow[1].length()-1));
      fPolys[i][2] = int(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "WEIGHTS",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    int iWeights = int(sDataRow[1]);
    for(int i = 0; i < iWeights; i++){
      fCurRow = find(sFile, "WEIGHT_SET",0,fCurRow+1);
      int fSetStart = fCurRow;
      sDataRow = spRed(sFile[fCurRow],' ');
      int iSet = int(sDataRow[1]);
      for(int j = fSetStart+2; j < fSetStart+iSet+2; j++){
        fCurRow = j;
        sDataRow = spRed(sFile[fCurRow]);
        fVerts[int(sDataRow[1].substring(0,sDataRow[1].length()-1))][3] = i;
      }
    }
    println((sFileName + " Loaded. " + str(millis()) + " Millis"));
    println((str(fPolys.length) + " Polys. " + str(fVerts.length) + " Verts."));
  }
  void draw(float x, float y, float z, float xr, float yr, float zr){
    M4 M = new M4();
    M4 M1= new M4();
    M4 M2= new M4();

    float[] vector;
    M2.MRot(xr,yr,zr);
    x-=fCamera[0];
    y-=fCamera[1];
    z-=fCamera[2];
    M2=MMulti(cam,M2);
    vector = M2.MDerot();
    xr = vector[0];
    yr = vector[1];
    zr = vector[2];
    vector = cam.MMulti(x,y,z);
    x = vector[0]+width/2;
    y = vector[1]+height/2;
    z = vector[2]+cameraZ;
    if(z<cameraZ){
      M.MRot(xr,yr,zr);
      float[] pos = new float[4];
      beginShape(TRIANGLES);
      for(int i = 0; i < fPolys.length; i++){
          for(int j = 0; j < 3; j++){
            pos = M.MMulti(fVerts[int(fPolys[i][j])][0]/4,-fVerts[int(fPolys[i][j])][1]/4,fVerts[int(fPolys[i][j])][2]/4);
            pos[0]+=x;
            pos[1]+=y;
            pos[2]+=z;
            vertex(pos[0], pos[1],pos[2]);
          }
      }
      endShape();
    }
  }
}
int addModel(String fileName){
  for(int i = 0; i < sModels.length; i++){
    if(sModels[i].sName == fileName){
      return i;
    } 
  }
  SKA[] tModels = new SKA[sModels.length+1];
  for(int i = 0; i < sModels.length; i++){
    tModels[i] = sModels[i]; 
  }
  tModels[tModels.length-1] = new SKA(fileName);
  sModels = tModels;
  return(sModels.length-1);
}
