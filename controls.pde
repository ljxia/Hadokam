import controlP5.*;

ControlP5 controlP5;

float front_image_offset_x = 25;
float front_image_offset_y = 0;
float front_image_scale_x = 4.5;
float front_image_scale_y = 4.5;

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
}