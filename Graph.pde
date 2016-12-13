//////////////////////////////////////////////////////////////////////////////////////////
//
//   Graph Class
//      - Draw Axes Lines
//      - Set the Limits for each axes
//      - Function to plot the current pressure value
//
//   
//
//   
/////////////////////////////////////////////////////////////////////////////////////////

class Graph
{
  int xDiv=5, yDiv=5;                                        // Number of sub divisions
  int xPos, yPos;                                            // location of the top left corner of the graph  
  int Width, Height;                                         // Width and height of the graph
  color GraphColor;                                          // Color for the trace

  float yMax=1024, yMin=0;                                   // Default axis dimensions
  float xMax=10, xMin=0;

  PFont   Font;                                              // Selected font used for text 

  /******************** The main declaration function ************************************/

  void GraphAxis(int x, int y, int w, int h) {               
    xPos = x;
    yPos = y;
    Width = w;
    Height = h;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  The DrawAxis() is called repeatedly by the main draw function
  //  This function draw x axis with its respective axis points.
  //  Functions:
  //    - text(string txt,x,y)     :  Draws text to the screen. 
  //                                  Displays the information specified in the first parameter on the screen in the position specified by the additional parameters
  //    - fill(int color)          :  Sets the color used to fill shapes 
  //    - rect(x,y,w,h)            :  Draws a rectangle to the screen in the position specified in the parameters.
  //    - stroke(int color)        :  Sets the color used to draw lines and borders around shapes.
  //    - strokeWeight(int value)  :  Sets the width of the stroke used for lines, points, and the border around shapes.
  //    - noStroke()               :  Disables drawing the stroke (outline)
  //    - noFill()                 :  Disables filling geometry.
  //    - smooth()                 :  Draws all geometry with smooth (anti-aliased) edges.
  //    - line(x1,y1,x2,y2)        :  Draws a line (a direct path between two points) to the screen. The two points are taken from the parameter.
  //    - pushStyle()              :  Saves the current style settings
  //    - popStyle()               :  Restores the prior settings
  //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void DrawAxis() {

    fill(255);
    textAlign(CENTER);
    textSize(14);
    textSize(10); 
    noFill(); 
    stroke(255); 
    smooth();
    strokeWeight(1);
    line(xPos, yPos+Height+25, Width, yPos+Height+25);                                                     // x-axis line 
    stroke(255);

    for (int x=0; x<=xDiv; x++) {
      line(float(x)/xDiv*Width+xPos-3, yPos+Height+25, float(x)/xDiv*Width+xPos-3, yPos+Height+30);        // x-axis Sub devisions     
      textSize(10);                                                                                        // x-axis Labels
      String xAxis=str((xMin+float(x)/xDiv*(xMax-xMin))/SPS);                                              // the only way to get a specific number of decimals
      String[] xAxisMS=split(xAxis, '.');                                                                  // is to split the float into strings 
      text(xAxisMS[0]+"."+xAxisMS[1].charAt(0), float(x)/xDiv*Width+xPos-3, yPos+Height+40);               // x-axis Labels
    }
  }

  /************************ Function to Draw the Trace in the graph ************************************/

  void LineGraph(float[] x, float[] y, int arraySize) {

    for (int i=0; i<(arraySize-1); i++)
    {
      smooth();
      strokeWeight(3);
      stroke(GraphColor);
      // x & y points to draw line            
      line(
        xPos-22+(x[i]-x[0])/(x[arraySize-1]-x[0])*Width, 
        yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height, 
        xPos-22+(x[i+1]-x[0])/(x[arraySize-1]-x[0])*Width, 
        yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height
        );
    }
    stroke(0);
    fill(0);
    // Rectangle is drawn to differentiate previous line and current line
    rect(xPos-22+((t-0.2)-x[0])/(x[arraySize-1]-x[0])*Width, 0, 20, height);
  }
}