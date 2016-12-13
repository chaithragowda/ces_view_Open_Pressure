//////////////////////////////////////////////////////////////////////////////
//
//    HelpWidget 
//      - This class differentiate the footer from the whole application
//      - Shows the status and threshold values of the alarm
//
//    
//
//////////////////////////////////////////////////////////////////////////////

class HelpWidget {

  public float x, y, w, h;                                     // location of the top left corner of the widget with width and height
  String currentOutput = "Click Start button";                 // current text shown in help widget, based on most recent command

  // Alarm Status, Minimum and Maximum Values
  String alrmStatus = "Status : OFF";                          
  String alrmMin = "Minimum : -1";
  String alrmMax = "Maximum : 20";
  int padding = 5;                                             // Constant value to fix the position of the Label

  ////////////////////////////////////////////////////////////////////////////////
  //
  //  This Constructor gets the co-ordinate points likes x, y, width and height
  //  The values are passed from the setup function in the main class 
  //    and it is set in this constructor
  //
  ///////////////////////////////////////////////////////////////////////////////

  HelpWidget(float _xPos, float _yPos, float _width, float _height) {
    x = _xPos;
    y = _yPos;
    w = _width;
    h = _height;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  This draw method is called repeatedly by the main draw function
  //  This function creates a rectangle which shows the differentiation like a Footer.
  //  Functions:
  //    - text(string txt,x,y)     :  Draws text to the screen. 
  //                                  Displays the information specified in the first parameter on the screen in the position specified by the additional parameters
  //    - textSize(int size)       :  Sets the current font size
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
    fill(0, 102, 204);
    rect(x, height-h, width, h);
    strokeWeight(1);
    stroke(color(0, 5, 11));
    fill(color(0, 5, 11));
    rect(x + padding, height-h + padding, width - padding+5 - 128, h - padding *2);

    // Alarm Information

    textSize(18);
    fill(255);
    textAlign(LEFT, TOP);
    text("Alarm : ", padding*2, height - h + padding + 4);
    text(alrmStatus, padding*15, height - h + padding + 4);
    if (alrmStatus.equals("Status : ON"))
    {
      text(alrmMin, padding*45, height - h + padding + 4);
      text(alrmMax, padding*75, height - h + padding + 4);
    }
    popStyle();
  }

  /********** Methods to assign current values for status information **************/

  public void aStatus(String _alrmStatus, String _alrmMin, String _alrmMax)
  {
    alrmStatus = _alrmStatus;
    alrmMin = _alrmMin;
    alrmMax = _alrmMax;
  }

  public void aStatus(String _alrmStatus)
  {
    alrmStatus = _alrmStatus;
  }
};