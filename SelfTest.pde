//////////////////////////////////////////////////////////////////////////////////////////
//
//    Self Test:
//      - This class displays the status of the test
//      - System Test, ADC Communication Test, Temperature Compensation Test, Self Test
//
//   
//
//////////////////////////////////////////////////////////////////////////////////////////

 // class SelfTest{ 
  
  // public float x, y, w, h;                                // location of the top left corner of the widget with width and height
  // String patient = "NA";
  // String doctor = "NA";
  // String sysTest = "Not OK";
  // String tempTest = "Not OK";

  // String ADCComm = "Not OK";
  // String self = "Not OK";

  // int padding = 5;

  // Constructor set the location points

  // SelfTest(float _xPos, float _yPos, float _width, float _height) {
 //   x = _xPos;
  //  y = _yPos;
  //  w = _width;
  //  h = _height;
//  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  This draw method is called repeatedly by the main draw function
  //  This function shows the details of the self test, whether the test is ok or not ok.
  //  Functions:
  //    - text(string txt,x,y)     :  Draws text to the screen. 
  //                                  Displays the information specified in the first parameter on the screen in the position specified by the additional parameters
  //    - textAlign(alignX, alignY):  Sets the current alignment for drawing text.
  //    - textFont(which, size)    :  Sets the current font that will be drawn with the text() function.
  //    - fill(int color)          :  Sets the color used to fill shapes 
  //    - rect(x,y,w,h)            :  Draws a rectangle to the screen in the position specified in the parameters.
  //    - stroke(int color)        :  Sets the color used to draw lines and borders around shapes.
  //    - strokeWeight(int value)  :  Sets the width of the stroke used for lines, points, and the border around shapes.
  //    - noStroke()               :  Disables drawing the stroke (outline)
  //    - pushStyle()              :  Saves the current style settings
  //    - popStyle()               :  Restores the prior settings
  //
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 //  public void draw() {

  //  pushStyle();
 //   noStroke();
  //  strokeWeight(1);
 //   stroke(color(0, 5, 11));
    
  //  fill(255);
  //   textAlign(LEFT, TOP);
 //   textFont(createFont("Arial Bold", 10)); 

  //  text("Patient Name", x+padding*2, y + padding + 4);
  //   text(": "+patient, x+padding*2+110, y + padding + 4);
  //   text("Doctor Name", x+padding*2, y + padding + 14);
  //  text(": "+doctor, x+padding*2+110, y + padding + 14);
  //  if (TestFlag)
   // {
   //   text("System Test", x+padding*2, y + padding + 24);
  //    text(": "+sysTest, x+padding*2+110, y + padding + 24);
   //   text("ADC Communication", x+padding*2, y + padding + 34);
  //    text(": "+ADCComm, x+padding*2+110, y + padding + 34);
  //    text("Temp Compensation", x+padding*2, y + padding + 44);
    //  text(": "+tempTest, x+padding*2+110, y + padding + 44);
  //    text("Self Test", x+padding*2, y + padding + 54);
    //  text(": "+self, x+padding*2+110, y + padding + 54);
  //  }
  //  popStyle();
//  }
// };