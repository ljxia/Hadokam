import controlP5.*;

ControlP5 controlP5;

float front_image_offset_x = 25;
float front_image_offset_y = 0;
float front_image_scale_x = 4.5;
float front_image_scale_y = 4.5;

int kinect_depth_threshold = 511;
int kinect_scale = 400;

Button exportButton;

void setupControls()
{
  controlP5 = new ControlP5(this);
  
  controlP5.setAutoDraw(false);
  controlP5.setColorActive(color(187,0,0));
  controlP5.setColorBackground(color(230));
  controlP5.setColorForeground(color(200,0,0));
  controlP5.setColorLabel(color(187,0,0));
  
  
  Slider slider;
  
  slider = controlP5.addSlider("front_image_offset_x",  -500,  500, 25,  40,40,200,10);
  slider.setLabel("Front Image Offset X");
  
  slider = controlP5.addSlider("front_image_offset_y",  -500,  500, 0,  40,60,200,10);
  slider.setLabel("Front Image Offset Y");
  
  slider = controlP5.addSlider("front_image_scale_x",  0.1, 5.0, 4.5,  40,80,200,10);
  slider.setLabel("Front Image Scale X");
  
  slider = controlP5.addSlider("front_image_scale_y",  0.1, 5.0, 4.5,  40,100,200,10);
  slider.setLabel("Front Image Scale Y");
  
  slider = controlP5.addSlider("kinect_depth_threshold",  0, 2047, kinect_depth_threshold,  340,40,200,10);
  slider.setLabel("Kinect Depth Filter");
  
  slider = controlP5.addSlider("kinect_scale",  1, 1000, 400,  340,60,200,10);
  slider.setLabel("Kinect Depth Map Scale");

  
  
  exportButton = controlP5.addButton("export",3000,40, 120,120,20);
}

public void export()
{
  println("export");
  println(mapMin);
  println(mapMax);
  
  PGraphics gfx = createGraphics(ceil(mapMax.x - mapMin.x), ceil(mapMax.y - mapMin.y), P3D);
  gfx.noStroke();
  gfx.fill(255);
  
  gfx.beginDraw();
  
  for (int i = 0; i < kFaces.size(); i++)
  {
    
    Face f = kFaces.get(i).getFace();
    
    gfx.beginShape(TRIANGLES);
    gfx.texture(frontImage);
    
    gfx.noStroke();
    
    for (int j = 0; j < f.getUvs().length; j++)
    {
      PVector v = f.uvs.get(j);
      PVector p = f.vertices.get(j);
      //gfx.vertex(v.x * 1000 - mapMin.x, v.y * 1000 - mapMin.y);
      gfx.vertex(v.x * factor - mapMin.x, v.y * factor - mapMin.y,0, p.x * front_image_scale_x + frontImage.width/2 + front_image_offset_x, p.y * front_image_scale_y + frontImage.height/2 + front_image_offset_y);
    }
    gfx.endShape(CLOSE);
  }
  
  gfx.endDraw();
  
  gfx.save("dump.png");
  
}