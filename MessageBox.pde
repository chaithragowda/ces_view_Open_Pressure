//////////////////////////////////////////////////////////////////////////////
//
//    MessageBox:
//      - This class displays set of values as an end result to the user
//      - The values includes : Current Pressure Values, Maximum Pressure
//        Maximum Peak, Time Stramp
//
//    Created : Balasundari, May 2016
//
//////////////////////////////////////////////////////////////////////////////

class MessageBox {

  public float x, y, w, h;                              // location of the top left corner of the widget with width and height
  String CurrValue = "0.0";                             // Holds the current pressure value
  String Max = "0.0";                                   // Holds Maximum of the pressure value
  String MP = "0.0";                                    // Holds Maximum Peak of the Maximum
  String MPDATE = ""+new Date();                        // Holds the TimeStramp  of the Maximum Peak
  int padding = 5;                                      // Constant value to fix the position of the Label

  /////////////////////////////////////////////////////////////////////////////////////
  //
  //  This Function gets the co-ordinate points likes x, y, width and height
  //  The values are passed from the draw function in the main class 
  //    and it is set in this method.
  //  This function is called repeatedly when the main draw function gets refreshed
  //
  ////////////////////////////////////////////////////////////////////////////////////

  void MessageBoxAxis(float _xPos, float _yPos, float _width, float _height) {
    x = _xPos;
    y = _yPos;
    w = _width;
    h = _height;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  This draw method is called repeatedly by the main draw function
  //  This function shows the Curresnt Pressure Value, Maximum Value, Maximum Peak and the TimeStramp of the Maximum Peak occurance.
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

  public void draw() {
    pushStyle();
    noStroke();
    strokeWeight(1);
    stroke(color(0, 5, 11));
    fill(color(0));
    rect(x + padding, y + padding, w - padding*2, h - padding *2);

    fill(255);
    textAlign(LEFT, TOP);
    textFont(createFont("Arial Bold", 20)); 

    text("Pressure", width/(15), y + padding + 4);
    text(": "+CurrValue+" bar", width/5, y + padding + 4);
    text("Peak", width/15, y + padding + 34);
    text(": "+Max+" bar", width/5, y + padding + 34);
    text("Max Peak", width/1.7, y + padding + 4);
    text(": "+MP+" bar", width/1.4, y + padding + 4);
    text(""+MPDATE, width/1.7, y + padding + 34); 
    popStyle();
  }
};