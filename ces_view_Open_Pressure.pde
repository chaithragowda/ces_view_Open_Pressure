//////////////////////////////////////////////////////////////////////////////////////////
//
//   GUI for controlling the ICP Sensor
//
//
//   Requires g4p_control graphing library for processing.  Built on V4.1
//   Downloaded from Processing IDE Sketch->Import Library->Add Library->G4P Install
//
/////////////////////////////////////////////////////////////////////////////////////////

import g4p_controls.*;                       // Processing GUI Library to create buttons, dropdown,etc.,
import processing.serial.*;                  // Serial Library

// Java Swing Packages For creating Dialog Box, Buttons, Frames, etc., 
import javax.swing.*;                        
import static javax.swing.JOptionPane.*;     
import java.awt.*;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField; 
import java.awt.event.*;

// File Packages to record the data into a text file
import javax.swing.JFileChooser;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.BufferedReader;

// General Packages
import java.text.*;
import java.math.*;
import java.util.*;
import java.lang.Math;

// Date Format
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

/************** Packet Validation  **********************/
private static final int CESState_Init = 0;
private static final int CESState_SOF1_Found = 1;
private static final int CESState_SOF2_Found = 2;
private static final int CESState_PktLen_Found = 3;

/*CES CMD IF Packet Format*/
private static final int CES_CMDIF_PKT_START_1 = 0x0A;
private static final int CES_CMDIF_PKT_START_2 = 0xFA;
private static final int CES_CMDIF_PKT_STOP = 0x0B;

/*CES CMD IF Packet Indices*/
private static final int CES_CMDIF_IND_LEN = 2;
private static final int CES_CMDIF_IND_LEN_MSB = 3;
private static final int CES_CMDIF_IND_PKTTYPE = 4;
private static int CES_CMDIF_PKT_OVERHEAD = 5;

/************** Packet Related Variables **********************/

int SPS = 10;                                            // This is the no.of samples received per second.
int ecs_rx_state = 0;                                    // To check the state of the packet
int CES_Pkt_Len;                                         // To store the Packet Length Deatils
int CES_Pkt_Pos_Counter;                                  
int CES_Pkt_Data_Counter1, CES_Pkt_Data_Counter2, CES_Pkt_Cali_Data_Counter;
int CES_Pkt_PktType;                                     // To store the packet type of the sample.
char DataRcvPacket1[] = new char[10];                    // Receive the 1st channel raw data from the packet.
char DataRcvPacket2[] = new char[10];                    // Recieve the 2nd channel raw data from the packet.
char CalibrationPacket[] = new char[30];                 // To receive the calibrated raw data recieved from the device.
int acknowledgement;                                     // To receieve the acknowledgment related values from the device.
long data1, data2;                                       // To store the shifted values from the raw data.
int arraySize = SPS * 10;                                // Total Size of the buffer, calculated from the SPS.

/************** User Defined Class Object **********************/

HelpWidget helpWidget;                                   
HeadWidgets headWidgets;
MessageBox msgBox;
//SelfTest st;
Graph g;
Calibration_Window cw;
Alarm_Window aw;
Temperature_Window tw;

/************** File Related Variables **********************/

boolean logging = false;                                // Variable to check whether to record the data or not
FileWriter output;                                      // In-built writer class object to write the data to file
JFileChooser jFileChooser;                              // Helps to choose particular folder to save the file
Date date, MPDate;                                      // Variables to record the date related values                              
BufferedWriter bw;
DateFormat dateFormat;

/************** Port Related Variables **********************/

Serial port = null;                                     // Oject for communicating via serial port
String[] comList;                                       // Buffer that holds the serial ports that are paired to the laptop
boolean serialSet, portSelected;                        // Conditional Variable for connecting to the selected serial port
char inString = '\0';                                   // To receive the bytes from the packet
String selectedPort;                                    // Holds the selected port number

/************** Graph and Buffer Variables **********************/

int inc = 0;                                            // Increment Variable for the buffer
float t = 0;                                            // X axis increment variable
float xValues[] = new float[arraySize];                 // X axis Buffer
float dataArray[] = new float[arraySize];               // Y axis Buffer that have the Pressure Values
double maxAxis, minAxis, mp;                            // To store the max and min value for auto scaling. mp = Maximum Peak
boolean Npaused = true, win_size = false;               // Conditional variable to pause the graph and resize the window
float dum = 0;                                          // Dummy variable to store the calculated values
String presValue = "";                                  // Current Pressure Value is stored                   
boolean set = false;                                    // Conditional Variable to start and stop the plot
BigDecimal rvolts;                                      // To store the current pressure value with 2 decimal precision
JSONObject CableProfile;                                // JSON Object for cable profile
boolean zeroCorrected = false;                          // Conditional Variable for zeroCorrection

/************** Alarm Variables **********************/

String topSketchPath = "";                              // To store the current sketchPath
JSONObject alarmConfigJSON;                             // JSON Object for alarm configuration
Boolean toggleValue = false;                            // Conditional Variable to toggle between alarm on and off
int amin, amax;                                         // Store threshold for alarm settings
boolean buzzerAlert = false, ringing;                   // Conditonal Variables for buzzer

/************** Calibration Related Variables **********************/

long c11, c12, c13, c14, c15, c16;                      // 6 points Calibration Variables
long t1, t2, t3;                                        // 3 points Temperature Varialbes
long cali_values[] = new long[6];                       // Calibrated Values Buffer
long Cvalue1, Cvalue2, ZeroValue;                       // Holds 2 points of calibration and zeroCorrected Values
int presValue1, presValue2, presValue3, presValue4, presValue5;  // Holds threshold for calibration say 1,5,10,40,100
boolean cali_done, cali_win;                            // Conditional Variable for calibration window

/************** SelfTest Variables **********************/

boolean TestFlag = true;                                // Conditional Variable for Self Test
int dummyCount= 0;                                      // Dummy Count

/************** Swing Variables **********************/

String frameName = "";                                                  // Frame Name
JFrame CFrame, TFrame, keyboard, Aframe;                                // Frame Objects
JTextField mText1, mText2, mText3, mText4, mText5, mText6;              
JLabel l1, l2, l3, l_unit, lStatus, lon, loff, l4, l5, l6, l_err;       
JButton mb1, mb2, mb3, mb4, mb5, mb6, Cread, Cwrite, Tread, Twrite, close_c, toggleStatus, save, Ton, Toff;
String numberString = "";                                               // Hold numbers as String for Swing Keyboard purpose
int alarm_S;                                                            // Alarm Status

// Calulating the minimum, maximum, average, etc.,  
BigDecimal min, max;
BigDecimal avg, rms, a;
boolean setVisible;                                    // Conditional variable for dropdown box

/*********************************************** Set Up Function *********************************************************/

////////////////////////////////////////////////////////////////////////////////
//
//  This Function is executed only once
//  The Objects for classes are initialized here
//
///////////////////////////////////////////////////////////////////////////////

/*************************************************************************************************************************/

public void setup() {
    size(800, 480, JAVA2D);
  //fullScreen();
  frameRate(20);

  /* G4P created Methods */

  createGUI();
  customGUI();

  /**********************/

  /* Object initialization for User-defined classes */

  headWidgets = new HeadWidgets(0, 0, width, 70);
  msgBox = new MessageBox();
  helpWidget = new HelpWidget(0, height - 50, width, 50);
 // st = new SelfTest(0, 70, 200, 200);
  g = new Graph();
  g.GraphColor = color(0, 255, 0);

  cw = new Calibration_Window();
  aw = new Alarm_Window();
  tw = new Temperature_Window();

  CFrame = new JFrame("Sensor Calibration");
  CFrame.setSize(700, 500);
  CFrame.setLocation(0, 0);
  CFrame.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);

  TFrame = new JFrame("Temperature Calibration");
  TFrame.setSize(600, 400);
  TFrame.setLocation(0, 0);
  TFrame.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);

  keyboard = new JFrame();
  keyboard.setSize(200, 200);
  keyboard.setLocation(width/2, height/2);
  keyboard.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);

  Aframe = new JFrame("Alarm");
  Aframe.setSize(500, 400);
  Aframe.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);

  /**************************************************/

  topSketchPath = sketchPath();

  alarmConfigJSON = loadJSONObject(topSketchPath+"/data/alarmConfigJSON.json");        // Loading the alarm configuration file
  setChartSettings();                                    // graph function to set minimum and maximum for axis

  /*******  Initializing zero for buffer ****************/

  for (int i=0; i<arraySize; i++) 
  {
    t = t+0.1;
    xValues[i]=t;
    dataArray[i] = 0;
  }
  t = 0;

  /*****************************************************/

  try
  {
    CableProfile = loadJSONObject(topSketchPath+"/data/Zero.json");                     // Loading Zero Corrected value from cable profile config file
    ZeroValue = Long.parseLong(CableProfile.getString("Zero_Value"));
  }
  catch(Exception e)
  {
    ZeroValue = 0;
  }
}

/*********************************************** Draw Function *********************************************************/

////////////////////////////////////////////////////////////////////////////////
//
//  This Function is executed repeatedly according the Frame Refresh Rate
//
///////////////////////////////////////////////////////////////////////////////

/***********************************************************************************************************************/

public void draw() {
  background(0);
  if (dummyCount < 10)
  {
    dummyCount++;
  }
  if (Npaused)                              // When Npaused is true, then the following methods will be called
  {
    if (set)
    {
      g.LineGraph(xValues, dataArray, arraySize);    // Method call to trace the graph
    }
    
    /****** User Defined Class Call *********************/
    
    msgBox.MessageBoxAxis(0, height - 120, width, 70);
    headWidgets.draw();
    msgBox.draw();
    helpWidget.draw();
    // st.draw();
    g.GraphAxis(0, height-315, width, 140);
    g.DrawAxis();
    
    /****************************************************/
    
    /************* Logic to draw the Average Value of the Pressure Value ************/
    
    if (set)
    {
      if (toggleValue) {
        if (((avg.intValue()) > int(getConfigInfo("alrmMin"))) && ((avg.intValue()) < int(getConfigInfo("alrmMax"))))
        {
          fill(255);
        } else
        {
          fill(255, 0, 0);
        }
      } else
      {
        fill(255);
      }
    
     float bar = dum/10000.4;
     bar = bar*1000;
     bar = Math.round(bar);
     bar = bar/1000;
  
     float psi = dum/716.8;
     psi = psi*1000;
     psi = Math.round(psi);
     psi = psi/1000;
     
     float mmHg = psi*51.71;
     mmHg = mmHg*1000;
     mmHg = Math.round(mmHg);
     mmHg = mmHg/1000;
 
      
      textFont(createFont("Arial Bold", 25));
      text(" "+bar, 150, 110);
      //  println(data1,data2,ZeroValue,dum);

      textFont(createFont("Arial", 15));
      text("bar", 150, 140);
      fill(255);
      
      textFont(createFont("Arial Bold", 25));
      text(" "+psi, 460, 110);
        //  println(data1,data2,ZeroValue,dum);
    
      textFont(createFont("Arial", 15));
      text("psi", 460, 140);
      fill(255);
      
      textFont(createFont("Arial Bold", 25));
      text(" "+mmHg, 700, 110);
      //  println(data1,data2,ZeroValue,dum);
      
      textFont(createFont("Arial", 15));
      text("mmHg", 700, 140);
      fill(255);
      
      
      textFont(createFont("Arial Bold", 15));
      text("Temperature Read Out : "+(int)(data2/1000), width-200, height/1.5);
    }
    
    /***********************************************************************************/
  }
}

/*********** Method to connect with the selected or inputted port number  *************************/ 

void startSerial()
{
  try
  {
    //port = new Serial(this, "/dev/ttyAMA0", 57600);                  // Static Port Used In Raspberry Pi
    port = new Serial(this, selectedPort, 57600);                           // Used to connect with the port selected from the drop down    
    port.clear();
    start.setEnabled(true);
    start.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    
    /*************** Prompt Box To Get the Patient and Doctor Name **********/ 
    
   // JTextField pName = new JTextField();
    //JTextField dName = new JTextField();
    //Object[] message = {
    //  "Patient's Name :", pName, 
  //   "Doctor's Name  :", dName
//    };

//    int option = JOptionPane.showConfirmDialog(null, message, "Patient's Profile", JOptionPane.OK_CANCEL_OPTION);
//    if (option == JOptionPane.OK_OPTION) {
   //   if (pName.getText().equals(""))
    //    pName.setText("NA");
   //   if (dName.getText().equals(""))
  //      dName.setText("NA");
     // st.patient = pName.getText();
      // st.doctor = dName.getText();
   // }
    
    /*************************************************************************/
    
//    selfTest();            // Call for selfTest module
  }
  catch(Exception e)
  {
    showMessageDialog(null, "Port is busy", "Alert", ERROR_MESSAGE);
    System.exit (0);
  }
}

/*********************************************** Serial Port Event Function *********************************************************/

///////////////////////////////////////////////////////////////////
//
//  Event Handler To Read the packets received from the Device
//
//////////////////////////////////////////////////////////////////


void serialEvent (Serial blePort) 
{
  inString = blePort.readChar();
  ecsProcessData(inString);
}

/*********************************************** Getting Packet Data Function *********************************************************/

///////////////////////////////////////////////////////////////////////////
//  
//  The Logic for the below function :
//      //  The Packet recieved is separated into header, footer and the data
//      //  If Packet is not received fully, then that packet is dropped
//      //  Futher Computation for linearity is done with the calibrated values
//      //  If Record option is true, then the values are stored in the text file
//      //  If Alarm is on, Then the value is checked for the threshold
//      //  If Threshold crosses then, Buzzer comment is initiated
//
//////////////////////////////////////////////////////////////////////////

void ecsProcessData(char rxch)
{
  switch(ecs_rx_state)
  {
  case CESState_Init:
    if (rxch==CES_CMDIF_PKT_START_1)
      ecs_rx_state=CESState_SOF1_Found;
    break;

  case CESState_SOF1_Found:
    if (rxch==CES_CMDIF_PKT_START_2)
      ecs_rx_state=CESState_SOF2_Found;
    else
      ecs_rx_state=CESState_Init;                    //Invalid Packet, reset state to init
    break;

  case CESState_SOF2_Found:
    ecs_rx_state = CESState_PktLen_Found;
    CES_Pkt_Len = (int) rxch;
    CES_Pkt_Pos_Counter = CES_CMDIF_IND_LEN;
    CES_Pkt_Data_Counter1 = 0;
    CES_Pkt_Data_Counter2 = 0;
    CES_Pkt_Cali_Data_Counter = 0;
    break;

  case CESState_PktLen_Found:
    CES_Pkt_Pos_Counter++;
    if (CES_Pkt_Pos_Counter < CES_CMDIF_PKT_OVERHEAD)                          //Read Header
    {
      if (CES_Pkt_Pos_Counter==CES_CMDIF_IND_LEN_MSB)
        CES_Pkt_Len = (int) ((rxch<<8)|CES_Pkt_Len);
      else if (CES_Pkt_Pos_Counter==CES_CMDIF_IND_PKTTYPE)
        CES_Pkt_PktType = (int) rxch;
    } else if ( (CES_Pkt_Pos_Counter >= CES_CMDIF_PKT_OVERHEAD) && (CES_Pkt_Pos_Counter < CES_CMDIF_PKT_OVERHEAD+CES_Pkt_Len+1) )  //Read Data
    {
      /********************** Receiving the actual data  *********************/
      
      if (CES_Pkt_PktType == 2)
      {
        if (CES_Pkt_Data_Counter1 < 4)                                  // Buffer to receive Digital Value for Pressure
        {
          DataRcvPacket1[CES_Pkt_Data_Counter1]= (char) (rxch);
          CES_Pkt_Data_Counter1++;
        } else if (CES_Pkt_Data_Counter2 < 4)                           // Buffer to receive Temperature Value
        {
          DataRcvPacket2[CES_Pkt_Data_Counter2]= (char) (rxch);
          CES_Pkt_Data_Counter2++;
        }
      } 
      
      /****************** Receiving the calibrated data  *****************/
      
      if (CES_Pkt_PktType == 3)
      {
        CalibrationPacket[ CES_Pkt_Cali_Data_Counter++] = (char) (rxch);
      }
      
      
    } else                                                               //All header and data received
    {
      if (rxch==CES_CMDIF_PKT_STOP)                                      //Check for EOF Byte
      {     
        /**************************** Assigning Calibrated Value to the textfield *********************************************/
        if (CES_Pkt_Cali_Data_Counter > 0)
        {
          int j=0;
          for (int i = 0; i<CES_Pkt_Cali_Data_Counter-1; i=i+4)
          {
            char dummy[] = new char[4];
            dummy[0] = CalibrationPacket[i];
            dummy[1] = CalibrationPacket[i+1];
            dummy[2] = CalibrationPacket[i+2];
            dummy[3] = CalibrationPacket[i+3];
            cali_values[j++] = ecsParsePacket(dummy, dummy.length-1);
          }
          if (cali_win)
          {
            mText1.setText(cali_values[0]+"");
            mText2.setText(cali_values[1]+"");
            mText3.setText(cali_values[2]+"");
            mText4.setText(cali_values[3]+"");
            mText5.setText(cali_values[4]+"");
            mText6.setText(cali_values[5]+"");
            showMessageDialog(null, "The Data has been read successfully from the device");
            CFrame.toFront();
          }

          CES_Pkt_Cali_Data_Counter = 0;
        } 
        
        /***********************************************************************************************/
        
        else
        {
          data1 = ecsParsePacket(DataRcvPacket1, DataRcvPacket1.length-1);  
          data2 = ecsParsePacket(DataRcvPacket2, DataRcvPacket2.length-1);
          dum = (float)(data1/Math.pow(10, 3));
          
          t = t+0.1;
          xValues[inc] = t;                                                      // Assigning X Axis values
          
          /************ Conversion Factor TO Get Pressure Value **************************/
          
          try {
            if (cali_done)
            {
              Cvalue1 = cali_values[1];
              Cvalue2 = cali_values[2];
              dum = conversion(data1, 1, 5);
              if ((dum <= presValue3)&&(dum > presValue2))
              {
                Cvalue1 = cali_values[2];
                Cvalue2 = cali_values[3];
                dum = conversion(data1, 5, 10);
              }
              if ((dum > presValue3)&&(dum <= presValue4))
              {
                Cvalue1 = cali_values[3];
                Cvalue2 = cali_values[4];
                dum = conversion(data1, 10, 40);
              }
              if ((dum > presValue4))
              {
                Cvalue1 = cali_values[4];
                Cvalue2 = cali_values[5];
                dum = conversion(data1, 40, 100);
              }
            }

            dataArray[inc++] = dum;
          }
          
          catch(Exception e)
          {
            println("Exception :"+e);
          }
          
          
          if (inc >= arraySize)
          {
            inc = 0;
            t = 0;
          }
          
          // Calculating Minimum, Maximum, Average, RMS and rounding of using BigDecimal type
          
          a = new BigDecimal(averageValue(dataArray));
          avg = a.setScale(1, BigDecimal.ROUND_HALF_EVEN); 
          a = new BigDecimal(RMSValue(dataArray));
          rms = a.setScale(1, BigDecimal.ROUND_HALF_EVEN); 
          a = new BigDecimal(max(dataArray));
          max = a.setScale(1, BigDecimal.ROUND_HALF_EVEN); 
          a = new BigDecimal(min(dataArray));
          min = a.setScale(1, BigDecimal.ROUND_HALF_EVEN); 
          a = new BigDecimal(dum);
          rvolts = a.setScale(1, BigDecimal.ROUND_HALF_EVEN);
          maxAxis = max(dataArray);
          minAxis = min(dataArray);

          int m = avg.intValue();

          if (m > 300)
            presValue = "Overload";
          else if (m < -50)
            presValue = "Underload";
          else
            presValue = avg+"";

          // Displaying the Values Below

          if (maxAxis > mp)
          {
            mp = maxAxis;
            mp = (Math.round(mp * 100))/100;

            println(mp);
            msgBox.MP = mp+"";
            msgBox.MPDATE = new Date()+"";
            
          // Updating Cable Profile with Maximum Peak and Time Stramp
          
            if (zeroCorrected)
            {
              CableProfile = loadJSONObject(sketchPath()+"/data/Zero.json");
              CableProfile.setString("Maximum Peak", msgBox.MP);
              CableProfile.setString("Time", msgBox.MPDATE);
              saveJSONObject(CableProfile, sketchPath()+"/data/Zero.json");
            }
          }

        // Auto Scaling

          if (maxAxis >= g.yMax)
          {
            g.yMax=(int)maxAxis;
          }
          if (minAxis <= g.yMin)
          {
            g.yMin=(int)minAxis;
          }
          
        // Validation for Alarm Threshold for Buzzer Initiation

          if (set && Npaused)
          {
            msgBox.CurrValue = rvolts+"";
            msgBox.Max = max+"";

            if (toggleValue) {
              if (((rvolts.intValue()) > int(getConfigInfo("alrmMin"))) && ((rvolts.intValue()) < int(getConfigInfo("alrmMax"))))
              {
                buzzerAlert = true;
              } else
              {
                if (buzzerAlert && !(ringing))
                {
                  String s = "0AFA180006010000000000000000000000000000000000000000000000000B";
                  println(s);
                  byte[] bytearray = hexStringToByteArray(s);
                  for (int i=0; i<bytearray.length; i++) 
                  {    
                    port.write(bytearray[i]);
                    delay(1);
                  }
                  ringing = true;
                  buzzerAlert = false;
                }
              }
            }
          }
          
          // Logging the data in a txt file
          
          if (logging == true)
          {
            try {
              date = new Date();
              dateFormat = new SimpleDateFormat("HH:mm:ss");
              output = new FileWriter(jFileChooser.getSelectedFile(), true);
              bw = new BufferedWriter(output);
              bw.write(dateFormat.format(date)+" : " +avg+" , "+data2);
              bw.newLine();
              bw.flush();
              bw.close();
            }
            catch(IOException e) {
              e.printStackTrace();
            }
          }
          
        }
        ecs_rx_state=CESState_Init;                                  // Setting to initial State
      } else                                                         // Packet end not found, drop packet
      {
        ecs_rx_state=CESState_Init;
      }
    }
    break;

  default:
      //Invalid state
    break;
  }
}


/*********************************************** Recursion Function To Shift The data *********************************************************/

public long ecsParsePacket(char DataRcvPacket[], int n)
{
  if (n == 0)
    return (long) DataRcvPacket[n]<<(n*8);
  else
    return (DataRcvPacket[n]<<(n*8))| ecsParsePacket(DataRcvPacket, n-1);
}

/********************************************* User-defined Method for G4P Controls  **********************************************************/

///////////////////////////////////////////////////////////////////////////////
//
//  Customization of controls is done here
//  That includes : Font Size, Visibility, Enable/Disable, ColorScheme, etc.,
//
//////////////////////////////////////////////////////////////////////////////

public void customGUI() {
  comList = port.list();
  String comList1[] = new String[comList.length+1];
  comList1[0] = "SELECT THE PORT";
  for (int i = 1; i <= comList.length; i++)
  {
    comList1[i] = comList[i-1];
  }
  close.setVisible(false);
  resume.setVisible(false);
  done.setVisible(false);
  slider1.setVisible(false);  
  comList = comList1;
  portList.setItems(comList1, 0);
  close.setEnabled(false);
  pause.setEnabled(false);
  resume.setEnabled(false);
  record.setEnabled(false);
  done.setEnabled(false);
  setting.setEnabled(false);
  zero.setEnabled(false);
  silence.setEnabled(false);


  close.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  pause.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  resume.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  record.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  done.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  zero.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  setting.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  silence.setLocalColorScheme(GCScheme.CYAN_SCHEME);

  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);
}

/**************** Setting the Limits for the graph **************/

void setChartSettings() {
  g.xDiv=10;  
  g.xMax=arraySize; 
  g.xMin=0;  
  g.yMax=10; 
  g.yMin=0;
}

/*************** Function to Calculate Average & RMS *********************/

double averageValue(float dataArray[])
{

  float total = 0;
  for (int i=0; i<dataArray.length; i++)
  {
    total = total + dataArray[i];
  }

  return total/dataArray.length;
}

double RMSValue(float dataArray[])
{
  float total = 0;
  for (int i=0; i<dataArray.length; i++)
  {
    total = (float)(total + Math.pow(dataArray[i], 2));
  }
  total /= dataArray.length;
  return Math.sqrt(total);
}

/*********************************************** Hexadecimal to Byte Array Conversion Function *********************************************************/

public static byte[] hexStringToByteArray(String s) {

  int len = s.length();
  byte[] data = new byte[len / 2];
  for (int i = 0; i < len; i += 2) {
    data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i+1), 16));
  }
  return data;
}

/**************** Getter and Setter to read value from JSON Config file ************************************/

public String getConfigInfo(String id)
{
  String r = "";
  try
  {
    r = alarmConfigJSON.getString(id);
  }
  catch(Exception e)
  {
    println(e);
  }
  return r;
}

public void setConfigInfo(String id, String value)
{
  try
  {
    alarmConfigJSON.setString(id, value);
    saveJSONObject(alarmConfigJSON, topSketchPath+"/data/alarmConfigJSON.json");
  }
  catch(Exception e)
  {
    println(e);
  }
}

/********************** Function to convert decimal to hexadecimal ***************************/

public String toHexa(long a)
{
  String hexa = (Long.toHexString(a));
  if (hexa.length() != 8)
  {
    for (int i = hexa.length(); i < 8; i++)
      hexa = "0"+hexa;
  }
  return hexa;
}

/********************** Digital to Pressure Value conversion *********************************/

public float conversion(long rawData, int cali1, int cali2)
{
  float pres = 0;
  try
  {
    pres = ((rawData - ZeroValue)/((Cvalue2-Cvalue1)/(cali2-cali1)));
    return (float)pres;
  }
  catch(Exception e)
  {
    println(e);
    return 0;
  }
}

/************ Window Scaling ****************/

public void WindowScale()
{
  win_size = false;
  slider1.setVisible(true);
}

/************ Function to Revert To Initial Values ****************/

public void StartValues()
{
  buzzerAlert = false;
  logging = false;
  win_size = false;
  set = false;
  Npaused = true;
  toggleValue = false;
  zeroCorrected = false;
  TestFlag = true;
  cali_done = false;
  cali_win = false;
  dummyCount = 0;
  mp = 0;
  ringing = false;
}

/************ Self Test Validation Function *****************/

//public void selfTest()
//{
 // int testCount = 0;

  // SYSTEM TEST

  //String s = "0AFA180007010000000000000000000000000000000000000000000000000B";
 // println(s);
 // byte[] bytearray = hexStringToByteArray(s);
//  for (int i=0; i<bytearray.length; i++) 
 // {    
 //   port.write(bytearray[i]);
  //  delay(1);
 // }

  // inString = port.readChar();
 //  ecsProcessData(inString);
 // println(acknowledgement);
//  if (acknowledgement == 0)
//  { 
    // st.sysTest = "OK";
 //   testCount++;
// }
  // ADC COMMUNICATION

//  s = "0AFA180007020000000000000000000000000000000000000000000000000B";
//  println(s);
//  bytearray = hexStringToByteArray(s);
//  for (int i=0; i<bytearray.length; i++) 
//  {    
//    port.write(bytearray[i]);
//   delay(1);
//  }
//  inString = port.readChar();
//  ecsProcessData(inString);
//  println(acknowledgement);
//  if (acknowledgement == 0)
//  { 
    // st.ADCComm = "OK";
//    testCount++;
//  }
  // TEMPERATURE COMPENSATION

//  s = "0AFA180007030000000000000000000000000000000000000000000000000B";
//  println(s);
//  bytearray = hexStringToByteArray(s);
//  for (int i=0; i<bytearray.length; i++) 
//  {    
//    port.write(bytearray[i]);
//    delay(1);
//  }
//  inString = port.readChar();
//  ecsProcessData(inString);
//  println(acknowledgement);
//  if (acknowledgement == 0)
 // {
    // st.tempTest = "OK";
  //  testCount++;
//  }

  // Self Test Confirmation

//  if (testCount == 3)
//  {
    // st.self = "OK";
//  }

//  s = "0AFA180009000000000000000000000000000000000000000000000000000B";
//  println(s);
//  bytearray = hexStringToByteArray(s);
 // for (int i=0; i<bytearray.length; i++) 
 // {    
  //  port.write(bytearray[i]);
 //   delay(1);
//  }
//  inString = port.readChar();
//  ecsProcessData(inString);

 // s = "0AFA180008000000000000000000000000000000000000000000000000000B";
//  println(s);
//  bytearray = hexStringToByteArray(s);
//  for (int i=0; i<bytearray.length; i++) 
//  {    
  //  port.write(bytearray[i]);
//    delay(1);
//  }

//  presValue1 = 1;
//  presValue2 = 5; 
//  presValue3 = 10;
//  presValue4 = 40;
//  presValue5 = 100;

//  cali_done = true;
 // }

/************ Writing Calibrated Value to ICP Device ******************/

public void Write_To_Device()
{
  try
  {
    if (set)
    {
      String s = "0AFA180002"+toHexa(c11)+toHexa(c12)+toHexa(c13)+toHexa(c14)+toHexa(c15)+toHexa(c16)+"000B";
      println(s);
      byte[] bytearray = hexStringToByteArray(s);
      for (int i=0; i<bytearray.length; i++) 
      {    
        port.write(bytearray[i]);
        delay(1);
      }
      showMessageDialog(null, "The Values stored in the device");
      cali_values[0] = c11;
      cali_values[1] = c12;
      cali_values[2] = c13;
      cali_values[3] = c14;
      cali_values[4] = c15;
      cali_values[5] = c16;
      CFrame.toFront();
    }
  }
  catch(Exception e)
  {
    println(e);
  }
}

/************ Read Calibrated Value from ICP Device ******************/

public void Read_From_Device()
{
  try
  {
    String s = "0AFA180001000000000000000000000000000000000000000000000000000B";
    println(s);
    byte[] bytearray = hexStringToByteArray(s);
    for (int i=0; i<bytearray.length; i++) 
    {    
      port.write(bytearray[i]);
      delay(1);
    }
  }
  catch(Exception e)
  {
    println(e);
  }
}

/************ Key Controls ******************/

void keyPressed() {
  if (key == ESC) {
    key = 0;
  }
}