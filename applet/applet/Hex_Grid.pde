float sin30 = sin(PI/6);
float cos30=cos(PI/6);
vector hexCoord(vector p,float r){
  int x = floor(p.x());
  int y = floor(p.y());
  int z = floor(p.z());
  return new vector((x+z*cos30)*r,y*r,z*sin30+r);
}
void pCell(vector p,float r){
  vector nP=new vector(p.x(),p.y(),p.z());
  for(float i = -1; i < 2; i++){
     for(float j=-1; j < 2; j+=2){
       nP=new vector(p.x()+i/2,p.y(),p.z()+j/2);
       render.addPoint(hexCoord(nP,r));
     }
  }
}
