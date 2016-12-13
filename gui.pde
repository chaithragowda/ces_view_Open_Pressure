/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void start_click(GButton source, GEvent event) { //_CODE_:start:291966:
  //  println("start - GButton >> GEvent." + event + " @ " + millis());
  startSerial();
  close.setVisible(true);
  start.setVisible(false);
  close.setEnabled(true);
  close.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  pause.setEnabled(true);
  pause.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  resume.setEnabled(true);
  resume.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  record.setEnabled(true);
  record.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  done.setEnabled(true);
  done.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  zero.setEnabled(true);
  zero.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  setting.setEnabled(true);
  setting.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  set = true;
} //_CODE_:start:291966:

public void portList_click(GDropList source, GEvent event) { //_CODE_:portList:984505:
  //println("portList - GDropList >> GEvent." + event + " @ " + millis());
  selectedPort = portList.getSelectedText();
  portSelected = true;
  portList.setEnabled(false);
  portList.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  
} //_CODE_:portList:984505:

public void close_click(GButton source, GEvent event) { //_CODE_:close:584959:
  // println("close - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Sends a close packet to the device and close the application
  //    In case of raspberry pi, the button initiates poweroff functionality
  //  
  ///////////////////////////////////////////////////////////////////////////////
  int n = JOptionPane.showConfirmDialog(null, "Confirm Close Application", "", JOptionPane.YES_NO_OPTION);
  if (n == 0) {
    try
    {
      String  s = "0AFA18000A000000000000000000000000000000000000000000000000000B";
      println(s);
      byte[] bytearray = hexStringToByteArray(s);
      for (int i=0; i<bytearray.length; i++) 
      {    
        port.write(bytearray[i]);
        delay(1);
      }
      Runtime runtime = Runtime.getRuntime();
      Process proc = runtime.exec("sudo poweroff");
      System.exit(0);
    }
    catch(Exception e)
    {
      exit();
    }
  } else
  {
  }
} //_CODE_:close:584959:

public void pause_click(GButton source, GEvent event) { //_CODE_:pause:423227:
  //  println("pause - GButton >> GEvent." + event + " @ " + millis());
  Npaused = false;
  pause.setVisible(false);
  resume.setVisible(true);
} //_CODE_:pause:423227:

public void resume_click(GButton source, GEvent event) { //_CODE_:resume:417523:
  // println("resume - GButton >> GEvent." + event + " @ " + millis());
  Npaused = true;
  pause.setVisible(true);
  resume.setVisible(false);
} //_CODE_:resume:417523:

public void record_click(GButton source, GEvent event) { //_CODE_:record:357970:
  //println("record - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Enable the buttons and calls the serial port function
  //    Comselect is made true to call the serial function
  //  
  ///////////////////////////////////////////////////////////////////////////////
  try
  {
    jFileChooser = new JFileChooser();
    jFileChooser.setSelectedFile(new File("log.txt"));
    jFileChooser.showSaveDialog(null);
    String filePath = jFileChooser.getSelectedFile()+"";

    if ((filePath.equals("log.txt"))||(filePath.equals("null")))
    {
    } else
    {    
      done.setVisible(true);
      record.setVisible(false);

      start.setEnabled(false);
      close.setEnabled(false);
      pause.setEnabled(false);
      resume.setEnabled(false);

      zero.setEnabled(false);

      start.setLocalColorScheme(GCScheme.CYAN_SCHEME);
      close.setLocalColorScheme(GCScheme.CYAN_SCHEME);
      pause.setLocalColorScheme(GCScheme.CYAN_SCHEME);
      resume.setLocalColorScheme(GCScheme.CYAN_SCHEME);
      zero.setLocalColorScheme(GCScheme.CYAN_SCHEME);


      logging = true;
      date = new Date();
      output = new FileWriter(jFileChooser.getSelectedFile(), true);
      bw = new BufferedWriter(output);
      bw.newLine();
      bw.write(date+"");
      bw.newLine();
      bw.newLine();
      bw.flush();
      bw.close();
    }
  }
  catch(Exception e)
  {
    println("File Not Found");
  }
} //_CODE_:record:357970:

public void done_click(GButton source, GEvent event) { //_CODE_:done:344756:
  //println("done - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Save the file and displays a success message
  //  
  ///////////////////////////////////////////////////////////////////////////////
  if (logging == true)
  {
    showMessageDialog(null, "Log File Saved successfully");

    record.setVisible(true);
    done.setVisible(false);

    close.setEnabled(true);
    close.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    pause.setEnabled(true);
    pause.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    resume.setEnabled(true);
    resume.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    record.setEnabled(true);
    record.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    done.setEnabled(true);
    done.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    zero.setEnabled(true);
    zero.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    logging = false;
  }
} //_CODE_:done:344756:

public void zero_click(GButton source, GEvent event) { //_CODE_:zero:947821:
  //println("zero - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Prompts a dialog box with a message and saves the values in a json file
  //  
  ///////////////////////////////////////////////////////////////////////////////
  if (set)
  {
    CableProfile = new JSONObject();
    zeroCorrected = true;
    showMessageDialog(null, "Please ensure that the sensor is placed in sterialized water");
    CableProfile.setString("Zero_Value", data1+"");
    CableProfile.setString("Maximum Peak", msgBox.MP);
    CableProfile.setString("Time", msgBox.MPDATE);
    saveJSONObject(CableProfile, sketchPath()+"/data/Zero.json");
    ZeroValue = data1;
  }
} //_CODE_:zero:947821:

public void silence_click(GButton source, GEvent event) { //_CODE_:silence:258065:
  //println("silence - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    This function send a command to stop ringing the buzzer
  //  
  ///////////////////////////////////////////////////////////////////////////////
  try
  {
    if (toggleValue)
    {
      String s = "0AFA180006000000000000000000000000000000000000000000000000000B";
      byte[] bytearray = hexStringToByteArray(s);
      for (int i=0; i<bytearray.length; i++) 
      {    
        port.write(bytearray[i]);
        delay(1);
      }
    }
  }
  catch(Exception e)
  {
  }
} //_CODE_:silence:258065:

public void slider1_click(GSlider source, GEvent event) { //_CODE_:slider1:245341:
  //println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Change the x axis size with the totalSize of the buffer
  //  
  ///////////////////////////////////////////////////////////////////////////////
  slider1.setVisible(true);
  arraySize = slider1.getValueI()*SPS;
  g.xMax = arraySize;
  g.xDiv = arraySize/SPS;
} //_CODE_:slider1:245341:

public void setting_click(GButton source, GEvent event) { //_CODE_:setting:315451:
  //println("setting - GButton >> GEvent." + event + " @ " + millis());
  if (!setVisible)
  {
    alarm.setVisible(true);
    calibration.setVisible(true);
    temp.setVisible(true);
    reset.setVisible(true);
    window.setVisible(true);
    setVisible = true;
  } else
  {
    alarm.setVisible(false);
    calibration.setVisible(false);
    temp.setVisible(false);
    reset.setVisible(false);
    window.setVisible(false);
    setVisible = false;
  }
} //_CODE_:setting:315451:

public void alarm_click(GButton source, GEvent event) { //_CODE_:alarm:592820:
  //println("alarm - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Creates Alarm Frame and calls the Alarm Window is called
  //  
  ///////////////////////////////////////////////////////////////////////////////
  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);

  Aframe.dispose();
  JPanel panel = new JPanel();   
  Aframe = new JFrame("Alarm");
  Aframe.setSize(500, 400);
  Aframe.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);
  Aframe.add(panel);
  aw.alarmComponents(panel);
  Aframe.setVisible(true);
  Aframe.toFront();
  Aframe.repaint();
  frameName = "Aframe";
} //_CODE_:alarm:592820:

public void calibration_click(GButton source, GEvent event) { //_CODE_:calibration:451149:
  //println("calibration - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Creates Calibration Frame and calls the calibration Window is called
  //  
  ///////////////////////////////////////////////////////////////////////////////
  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);
  CFrame.dispose();
  JPanel panel2 = new JPanel();    
  CFrame = new JFrame("Sensor Calibration");
  CFrame.setSize(700, 500);
  CFrame.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);
  CFrame.add(panel2);
  cw.placeComponents(panel2);
  CFrame.setVisible(true);
  CFrame.toFront();
  CFrame.repaint();
  frameName = "CFrame";
} //_CODE_:calibration:451149:

public void temp_click(GButton source, GEvent event) { //_CODE_:temp:534106:
  //println("temp - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Creates Temperature Frame and calls the Temperature Window is called
  //  
  ///////////////////////////////////////////////////////////////////////////////
  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);

  TFrame.dispose();
  JPanel panel3 = new JPanel();    
  TFrame = new JFrame("Temperature Calibration");
  TFrame.setSize(600, 400);
  TFrame.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);
  TFrame.add(panel3);
  tw.placeComponents(panel3);
  TFrame.setVisible(true);
  TFrame.toFront();
  TFrame.repaint();
  frameName = "frame2";
} //_CODE_:temp:534106:

public void reset_click(GButton source, GEvent event) { //_CODE_:reset:764816:
  //println("reset - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    Sends command to reset the device
  //    Prompts for a paasword to do the reset
  //  
  ///////////////////////////////////////////////////////////////////////////////
  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);

  JLabel jPassword = new JLabel("Please enter the password to do factory set");
  JPasswordField password = new JPasswordField();
  Object[] ob = {jPassword, password};
  int result = JOptionPane.showConfirmDialog(null, ob, "Authentication", JOptionPane.OK_CANCEL_OPTION);

  if (result == JOptionPane.OK_OPTION)
  {
    String pwd = new String(password.getPassword());
    if ("abcd".equals(pwd))
    {
      String s = "0AFA180004000000000000000000000000000000000000000000000000000B";
      byte[] bytearray = hexStringToByteArray(s);
      for (int i=0; i<bytearray.length; i++) 
      {    
        port.write(bytearray[i]);
        delay(1);
      }
      showMessageDialog(null, "Factory Reset Done Successfully");
    } else
    {
      showMessageDialog(null, "Authentication Failed\n Reset cannot be done", "Alert", ERROR_MESSAGE);
    }
  }
} //_CODE_:reset:764816:

public void window_click(GButton source, GEvent event) { //_CODE_:window:798002:
  //println("window - GButton >> GEvent." + event + " @ " + millis());
  ////////////////////////////////////////////////////////////////////////////////
  //
  //    This function calls the Window Scale method to resize the window
  //  
  ///////////////////////////////////////////////////////////////////////////////
  alarm.setVisible(false);
  calibration.setVisible(false);
  temp.setVisible(false);
  reset.setVisible(false);
  window.setVisible(false);
  WindowScale();
} //_CODE_:window:798002:

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("ICP Sensor");
  start = new GButton(this, 143, 6, 100, 55);
  start.setText("CONNECT");
  start.setTextBold();
  start.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  start.addEventHandler(this, "start_click");
  portList = new GDropList(this, 2, 14, 136, 270, 8);
  portList.setItems(loadStrings("list_984505"), 0);
  portList.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  portList.addEventHandler(this, "portList_click");
  close = new GButton(this, 144, 6, 100, 55);
  close.setText("CLOSE");
  close.setTextBold();
  close.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  close.addEventHandler(this, "close_click");
  pause = new GButton(this, 251, 6, 100, 55);
  pause.setText("PAUSE");
  pause.setTextBold();
  pause.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  pause.addEventHandler(this, "pause_click");
  resume = new GButton(this, 250, 6, 100, 55);
  resume.setText("RESUME");
  resume.setTextBold();
  resume.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  resume.addEventHandler(this, "resume_click");
  record = new GButton(this, 360, 6, 100, 55);
  record.setText("RECORD");
  record.setTextBold();
  record.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  record.addEventHandler(this, "record_click");
  done = new GButton(this, 360, 6, 100, 55);
  done.setText("DONE");
  done.setTextBold();
  done.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  done.addEventHandler(this, "done_click");
  zero = new GButton(this, 468, 6, 100, 55);
  zero.setText("ZERO");
  zero.setTextBold();
  zero.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  zero.addEventHandler(this, "zero_click");
  silence = new GButton(this, 577, 7, 100, 55);
  silence.setText("SILENCE");
  silence.setTextBold();
  silence.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  silence.addEventHandler(this, "silence_click");
  slider1 = new GSlider(this, 452, 68, 128, 55, 10.0);
  slider1.setShowValue(true);
  slider1.setLimits(10, 6, 10);
  slider1.setNbrTicks(8);
  slider1.setNumberFormat(G4P.INTEGER, 0);
  slider1.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  slider1.setOpaque(false);
  slider1.addEventHandler(this, "slider1_click");
  setting = new GButton(this, 687, 8, 110, 55);
  setting.setText("SETTINGS");
  setting.setTextBold();
  setting.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  setting.addEventHandler(this, "setting_click");
  alarm = new GButton(this, 687, 60, 110, 55);
  alarm.setText("ALARM");
  alarm.setTextBold();
  alarm.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  alarm.addEventHandler(this, "alarm_click");
  calibration = new GButton(this, 687, 105, 110, 55);
  calibration.setText("CALIBRATION");
  calibration.setTextBold();
  calibration.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  calibration.addEventHandler(this, "calibration_click");
  temp = new GButton(this, 687, 156, 110, 55);
  temp.setText("TEMPERATURE");
  temp.setTextBold();
  temp.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  temp.addEventHandler(this, "temp_click");
  reset = new GButton(this, 687, 207, 110, 55);
  reset.setText("RESET");
  reset.setTextBold();
  reset.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  reset.addEventHandler(this, "reset_click");
  window = new GButton(this, 687, 256, 110, 55);
  window.setText("WINDOW SACLE");
  window.setTextBold();
  window.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  window.addEventHandler(this, "window_click");
}

// Variable declarations 
// autogenerated do not edit
GButton start; 
GButton close; 
GButton pause; 
GButton resume; 
GButton record; 
GButton done; 
GButton zero; 
GButton silence; 
GSlider slider1; 
GButton setting; 
GButton alarm; 
GButton calibration; 
GButton temp; 
GButton reset; 
GButton window; 
GDropList portList; 