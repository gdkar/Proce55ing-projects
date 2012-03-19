PGraphics render;
class SKA{
  vector[] vVerts;
  int[] iAttach;
  int[][] iPolys;
  vector[] vNormals;
  String sName;
  vector[] tVerts;
  vector[] tNormals;
  float[][] uv;
  SKA(String sFileName){
    sName = sFileName;
    int fCurRow = 0;
    String[] sFile = loadStrings(sFileName);
    String[] sDataRow = new String[1];
    float[] fDataRow = new float[1];
    fCurRow = find(sFile, "VERTICES",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    vVerts = new vector[int(sDataRow[1])];
    iAttach = new int[int(sDataRow[1])];
    fCurRow+=1;
    for(int i = 0; i < vVerts.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      vVerts[i]=new vector(float(sDataRow[0].substring(0,sDataRow[0].length()-1)),float(sDataRow[1].substring(0,sDataRow[1].length()-1)),float(sDataRow[2].substring(0,sDataRow[2].length()-1)));
    }
    fCurRow = find(sFile, "NORMALS",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    vNormals = new vector[int(sDataRow[1])];
    fCurRow+=1;
    for(int i = 0; i < vVerts.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      vNormals[i]=new vector(float(sDataRow[0].substring(0,sDataRow[0].length()-1)),float(sDataRow[1].substring(0,sDataRow[1].length()-1)),float(sDataRow[2].substring(0,sDataRow[2].length()-1)));
    }
    fCurRow = find(sFile, "TRIANGLE_SET",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    iPolys = new int[int(sDataRow[1])][3];
    fCurRow+=1;
    for(int i = 0; i < iPolys.length; i++){
      fCurRow++;
      sDataRow = spRed(sFile[fCurRow],' ');
      iPolys[i][0] = int(sDataRow[0].substring(0,sDataRow[0].length()-1));
      iPolys[i][1] = int(sDataRow[1].substring(0,sDataRow[1].length()-1));
      iPolys[i][2] = int(sDataRow[2].substring(0,sDataRow[2].length()-1));
    }
    fCurRow = find(sFile, "TEXCOORDS",0);
    sDataRow = spRed(sFile[fCurRow],' ');
    uv = new float[int(sDataRow[1])][2];
    int rowStart = fCurRow+2;
    for(int i = 0; i < uv.length; i++){
      sDataRow = spRed(sFile[rowStart+i],' ');
      uv[i][0] = float(sDataRow[0].substring(0,sDataRow[0].length()-1));
      uv[i][1] = float(sDataRow[1].substring(0,sDataRow[1].length()-1));
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
        sDataRow = spRed(sFile[fCurRow],' ');
        iAttach[int(sDataRow[1].substring(0,sDataRow[1].length()-1))] = i;
      }
    }
    tVerts = new vector[vVerts.length];
    for(int i = 0; i < tVerts.length; i++){
      tVerts[i]=new vector(); 
    }
    tNormals = new vector[vNormals.length];
    for(int i = 0; i < tNormals.length; i++){
      tNormals[i]=new vector(); 
    }
    println((sFileName + " Loaded. " + str(millis()) + " Millis"));
    println((str(iPolys.length) + " Polys. " + str(vVerts.length) + " Verts."));
  }
  void draw(float x, float y, float z, float xr, float yr, float zr,float R,float G,float B){
    M4 M = new M4();
    M4 M1= new M4();
    M4 M2= new M4();
    vector pos = new vector();
    vector rot = new vector();
    float[] vector;
    vector trueRot = new vector(xr,yr,zr);
    M2.MRot(xr,yr,zr);
    x-=vPos.x();
    y-=vPos.y();
    z-=vPos.z();
    M2=MMulti(cam,M2);
    vector = M2.MDerot();
    xr = vector[0];
    yr = vector[1];
    zr = vector[2];
    vector = cam.MMulti(x,y,z);
    x = vector[0]+width/2;
    y = vector[1]+height/2;
    z = vector[2]+cameraZ;
    pos= new vector(x,y,z);
    rot = new vector(xr,yr,zr);

    for(int i = 0; i < tVerts.length; i++){
      vector = M2.MMulti(vVerts[i].x(),vVerts[i].y(),vVerts[i].z());
      tVerts[i].x(vector[0]);
      tVerts[i].y(vector[1]);
      tVerts[i].z(vector[2]);
      tVerts[i]=tVerts[i].vPlus(pos);
    }
    M2.MRot(trueRot.x(),trueRot.y(),trueRot.z());
    for(int i = 0; i < tNormals.length; i++){
      vector = M2.MMulti(vNormals[i].x(),vNormals[i].y(),vNormals[i].z());
      tNormals[i].x(vector[0]);
      tNormals[i].y(vector[1]);
      tNormals[i].z(vector[2]);
    }
    float[] fills = new float[tVerts.length];
    for(int i = 0; i < tVerts.length; i++){
      fills[i] = .125+(1-.125)*(max(-(tNormals[i].vDot(tVerts[i].vMinus(sun)))/(tNormals[i].vMag()*tVerts[i].vMinus(sun).vMag()),0));
    }
    //if(z<cameraZ){
    float Fill=0;
    int culled = 0;
    beginShape(TRIANGLES);
    for(int i = 0; i < iPolys.length; i++){
      if((tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][1]]).vCross(tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][2]]))).vDot(tVerts[iPolys[i][0]].vMinus(vOrigin))<0){
        for(int j = 0; j < 3; j++){
          fill(fills[iPolys[i][j]]*R,fills[iPolys[i][j]]*G,fills[iPolys[i][j]]*B);
          vertex(tVerts[iPolys[i][j]].x(),tVerts[iPolys[i][j]].y(),tVerts[iPolys[i][j]].z());
        }
      }
      else{
        culled++;
      }
    }

    endShape();
    //println(culled);
  }
  void draw(float x, float y, float z, M4 r,PImage tex){
    M4 M = new M4();
    M4 M1= new M4();
    M4 M2= new M4();
    vector pos = new vector();
    vector rot = new vector();
    float[] vector;
    x-=vPos.x();
    y-=vPos.y();
    z-=vPos.z();
    M2=MMulti(cam,r);
    vector = cam.MMulti(x,y,z);
    x = vector[0]+width/2;
    y = vector[1]+height/2;
    z = vector[2]+cameraZ;
    pos= new vector(x,y,z);
    for(int i = 0; i < tVerts.length; i++){
      vector = M2.MMulti(vVerts[i].x(),vVerts[i].y(),vVerts[i].z());
      tVerts[i].x(vector[0]);
      tVerts[i].y(vector[1]);
      tVerts[i].z(vector[2]);
      tVerts[i]=tVerts[i].vPlus(pos);
    }
    for(int i = 0; i < tNormals.length; i++){
      vector = r.MMulti(vNormals[i].x(),vNormals[i].y(),vNormals[i].z());
      tNormals[i].x(vector[0]);
      tNormals[i].y(vector[1]);
      tNormals[i].z(vector[2]);
    }
    float[] fills = new float[tVerts.length];
    for(int i = 0; i < tVerts.length; i++){
      fills[i] = .5+(1-.5)*(max(-(tNormals[i].vDot(tVerts[i].vMinus(sun)))/(tNormals[i].vMag()*tVerts[i].vMinus(sun).vMag()),0));
    }
    //if(z<cameraZ){
    float Fill=0;
    int culled = 0;
    textureMode(NORMALIZED);
    background(200);
    beginShape(TRIANGLES);
    texture(tex);
    for(int i = 0; i < iPolys.length; i++){
      if((tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][1]]).vCross(tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][2]]))).vDot(tVerts[iPolys[i][0]].vMinus(vOrigin))<0){
        //fill(fills[iPolys[i][1]]*256);
        for(int j = 0; j < 3; j++){
          fill(fills[iPolys[i][j]]*256);
          //fill(255);
          noStroke();
          vertex(tVerts[iPolys[i][j]].x(),tVerts[iPolys[i][j]].y(),tVerts[iPolys[i][j]].z(),uv[iPolys[i][j]][0],1-uv[iPolys[i][j]][1]);
          // vertex(tVerts[iPolys[i][j]].x(),tVerts[iPolys[i][j]].y(),tVerts[iPolys[i][j]].z());
        }
      }
      else{
        culled++;
      }
    }
    endShape();
    /*beginShape(TRIANGLES);
    for(int i = 0; i < iPolys.length; i++){
      if((tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][1]]).vCross(tVerts[iPolys[i][0]].vMinus(tVerts[iPolys[i][2]]))).vDot(tVerts[iPolys[i][0]].vMinus(vOrigin))>=0){
        //fill(fills[iPolys[i][1]]*256);
        for(int j = 0; j < 3; j++){
          noFill();
          stroke(0);
          //fill(0);
          vertex(tVerts[iPolys[i][j]].x(),tVerts[iPolys[i][j]].y(),tVerts[iPolys[i][j]].z());
          //vertex(tVerts[iPolys[i][j]].x(),tVerts[iPolys[i][j]].y(),tVerts[iPolys[i][j]].z());
          //rectLine(tVerts[iPolys[i][j]],tVerts[iPolys[i][(j+1)%3]],0);
        }
      }
    }
    endShape();*/
    noStroke();
    //println(culled);
  }
  //}
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
void rectLine(vector start, vector end, float fWidth){
  vector perp = new vector();
  perp.y(end.vMinus(start).x());
  perp.x(-end.vMinus(start).y());
  perp.normalize();
  perp.vTimes(fWidth/2);
  vector vert = new vector();
  beginShape(QUADS);
  noStroke();
  vert = start.vPlus(perp);
  vertex(vert.x(),vert.y(),vert.z());
  vert=end.vPlus(perp);
  vertex(vert.x(),vert.y(),vert.z());
  vert=end.vMinus(perp);
  vertex(vert.x(),vert.y(),vert.z());
  vert=start.vMinus(perp);
  vertex(vert.x(),vert.y(),vert.z());
  endShape();

}
