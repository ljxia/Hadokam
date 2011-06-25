import saito.objloader.*;
import processing.opengl.*;
import peasy.*;

// declare that we need a OBJModel and we'll be calling it "model"
OBJModel model;

int count = 0;

BoundingBox bbox;

PeasyCam cam;

PImage frontImage;
PImage sideImage;

ArrayList<KFace> kFaces;

void setup()
{
  size(800, 800, OPENGL);

  // making an object called "model" that is a new instance of OBJModel
  model = new OBJModel(this, "RYU_01.cos.emz.obj", TRIANGLES);

  // turning on the debug output (it's all the stuff that spews out in the black box down the bottom)
  model.enableDebug();
  model.scale(1000);
  model.translateToCenter();
  
  bbox = new BoundingBox(this, model);
  
  frontImage = loadImage("front.jpg");
  sideImage = loadImage("side.jpg");
  
  println(bbox.getMin().x + ", " + bbox.getMin().y);
  println(bbox.getMax().x + ", " + bbox.getMax().y);

  noStroke();
  
  cam = new PeasyCam(this,0,0,0,1000);
  
  cam.setRotations(0, PI, 0);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(4800);
  
  kFaces = new ArrayList<KFace>();
  
  ProcessFaces();
  
  println(kFaces.size() + " Faces");
}

void draw()
{
  background(200);
  
  ambientLight(255,255,255);
  lightSpecular(255,255,255);
  directionalLight(255,255,255,1,0.5,100);
  specular(255,255,255);
  shininess(17.0);
  
  //stroke(10);
  
  noStroke();
  fill(255,10);

  pushMatrix();
  
  //translate(width/2, height/2, 0);
  //rotateX(rotY);
  //rotateY(rotX);
  //scale(3);

  //model.draw();
  
  drawKFaces();
  
  
  noFill();
  
  stroke(255,0,0);
  line(0,0,5000,0);
  
  stroke(0,255,0);
  line(0,0,0,5000);
  
  stroke(0,0,255);
  line(0,0,0,0,0,5000);
  
  translate(0,0,-1000);
  
  image(frontImage, -frontImage.width/4, -frontImage.height/4, frontImage.width/2, frontImage.height/2);
  
  popMatrix();
}

void mousePressed()
{

}

void ProcessFaces()
{
  for (int i = 0; i < model.getSegmentCount(); i++)
  {
    Segment s = model.getSegment(i);
    for (int j = 0; j < s.faces.size(); j++)
    {
      Face f = s.faces.get(j);
      
      PVector []uvs = f.getUvs();
      // println(uvs[0].x + ", " + uvs[0].y);
      // println(uvs[1].x + ", " + uvs[1].y);
      // println(uvs[2].x + ", " + uvs[2].y);
      
      KFace kFace = new KFace(f);
      
      kFaces.add(kFace);      
    }
  }
}


void drawKFaces()
{
  
  
  fill(255);
  
  //println(kFaces.size());
  
  for (int i = 0; i < kFaces.size(); i++)
  {
    
    Face f = kFaces.get(i).getFace();
    
    //println(f.vertices.size());
    
    beginShape(TRIANGLES);
    texture(frontImage);
    for (int j = 0; j < f.vertices.size(); j++)
    {
     PVector v = f.vertices.get(j);
      
      vertex(v.x, v.y, v.z, v.x * 4.5 + frontImage.width/2, v.y * 4.5 + frontImage.height/2);
      
      //println(v.x + ", " + v.y + ", " + v.z);
    }
    endShape(CLOSE);
  }
  
  
}
