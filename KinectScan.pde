import saito.objloader.*;
import processing.opengl.*;
import peasy.*;

import org.openkinect.*;
import org.openkinect.processing.*;

// import hypermedia.video.*;
// import java.awt.Rectangle;

// declare that we need a OBJModel and we'll be calling it "model"
OBJModel model;
Kinect kinect;
// OpenCV opencv;

int count = 0;

BoundingBox bbox;

PeasyCam cam;

PImage frontImage;
PImage sideImage;

ArrayList<KFace> kFaces;

PVector mapMin;
PVector mapMax;

int factor = 1000;
PVector depthRange;

// Size of kinect image
int w = 640;
int h = 480;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup()
{
  size(1280, 800, OPENGL);

  // making an object called "model" that is a new instance of OBJModel
  model = new OBJModel(this, "RYU_01.cos.emz.obj", TRIANGLES);

  // turning on the debug output (it's all the stuff that spews out in the black box down the bottom)
  model.enableDebug();
  model.scale(factor);
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
  cam.setMaximumDistance(6000);
  
  kFaces = new ArrayList<KFace>();
  
  ProcessFaces();
  
  //println(kFaces.size() + " Faces");
  
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  // We don't need the grayscale image in this example
  // so this makes it more efficient
  kinect.processDepthImage(false);

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
  
  setupControls();
  
  depthRange = new PVector(9000, -9000);
  
  //kinect.enableRGB(true);
  
  // opencv = new OpenCV(this);
  // opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );
}

void draw()
{
  background(20);
  
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
  
  //image(kinect.getVideoImage(),-800, -h/2);
  
  pushMatrix();
  translate(0,0,-3000);
  
  image(frontImage, -frontImage.width/4, -frontImage.height/4, frontImage.width/2, frontImage.height/2);
  popMatrix();
  
  
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  int skip = 6;
  
  stroke(0);
  fill(0);
  
  for(int x=0; x<w; x+=skip) {
    for(int y=0; y<h; y+=skip) {
      int offset = x+y*w;
  
      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      
      if (rawDepth < kinect_depth_threshold)
      {
        PVector v = depthToWorld(x,y,rawDepth);
        
        PVector vthreshold = depthToWorld(x,y,kinect_depth_threshold);

        // if (v.z < depthRange.x){depthRange.x = v.z;}
        // if (v.z > depthRange.y){depthRange.y = v.z;}

        stroke(255);
        pushMatrix();
        // Scale up by 200
        translate(v.x*kinect_scale - 300,v.y*kinect_scale,(v.z - vthreshold.z)*kinect_scale);
        // Draw a point
        point(0,0);
        popMatrix();
      }
    }
  }
  
  
  
  popMatrix();
  
  
  cam.beginHUD();
  
  controlP5.draw();
  
  cam.endHUD();
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
  
  mapMin = new PVector(9000, 9000);
  mapMax = new PVector(-9000, -9000);
}


void drawKFaces()
{
  
  
  fill(255);
  
  //println(kFaces.size());
  //PVector in = new PVector(0,0,1);
  
  for (int i = 0; i < kFaces.size(); i++)
  {
    
    Face f = kFaces.get(i).getFace();
    
    // if (f.isFacingPosition(in))
    // {
    //   continue;
    // }
    
    //println(f.vertices.size());
    
    beginShape(TRIANGLES);
    texture(frontImage);
    for (int j = 0; j < f.vertices.size(); j++)
    {
     PVector v = f.vertices.get(j);
      
      vertex(v.x, v.y, v.z, v.x * front_image_scale_x + frontImage.width/2 + front_image_offset_x, v.y * front_image_scale_y + frontImage.height/2 + front_image_offset_y);
      
      //println(v.x + ", " + v.y + ", " + v.z);
    }
    endShape(CLOSE);
    
    
    beginShape(TRIANGLES);
    texture(frontImage);
    for (int j = 0; j < f.getUvs().length; j++)
    {
      PVector v = (f.getUvs())[j];
      PVector p = f.vertices.get(j);
      
      vertex(v.x * factor - width/2, v.y * factor - height/2, 3000, p.x * front_image_scale_x + frontImage.width/2 + front_image_offset_x, p.y * front_image_scale_y + frontImage.height/2 + front_image_offset_y);
      
      //println(v.x + ", " + v.y + ", " + v.z);
      
      if (v.x * factor < mapMin.x)
      {
        mapMin.x = v.x * factor;
      }
      if (v.x * factor > mapMax.x)
      {
        mapMax.x = v.x * factor;
      }
      if (v.y * factor < mapMin.y)
      {
        mapMin.y = v.y * factor;
      }
      if (v.y * factor > mapMax.y)
      {
        mapMax.y = v.y * factor;
      }
    }
    endShape(CLOSE);
  }
  
  
}

void stop() {
  kinect.quit();
  super.stop();
}
