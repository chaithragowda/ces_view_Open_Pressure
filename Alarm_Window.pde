//////////////////////////////////////////////////////////////////////////////////////////
//
//   Alarm Window:
//      - Toggle between ON/OFF
//      - Edit & View the threshold value to json file
//      - Initiates Buzzer Commands
//      - JFrame For Keyboard is popped to enter new threshold value
//
//   
//
//   Requires Java Swing Package
//   
/////////////////////////////////////////////////////////////////////////////////////////

import java.awt.event.MouseEvent;

public class Alarm_Window { 

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  alarmComponents() creates a Panel and add the necessary Components like Buttons, Labels, TextBox, etc.,
  //  This Function is called whenever the user wants to turn ON/OFF Alarm and to set the Threshold when it is ON.
  //  The save save the threshold in the ces_view_pressure\data\alarmConfigJSON.json file which is in json format.
  //  When the alarm is ON/OFF a function AlaramStatusInfo(boolean toggleStatus) is called.
  //  When Toff button is clicked, it sends the buzzer silent command to the device and turn off the alarm.
  //   
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  private void alarmComponents(JPanel panel) {

    panel.setLayout(null);
    panel.setBackground(new Color(0, 90, 148));

    l_err = new JLabel("*** Error : Only Numberic Values are allowed ***"); 
    l_err.setBounds(100, 5, 360, 35);
    l_err.setFont(new Font("", Font.BOLD, 15));
    l_err.setForeground(Color.RED);
    panel.add(l_err);
    l_err.setVisible(false);

    lStatus = new JLabel("Status");
    lStatus.setBounds(80, 50, 100, 35);
    lStatus.setFont(new Font("", Font.BOLD, 20));
    lStatus.setForeground(Color.white);
    panel.add(lStatus);

    lon = new JLabel("ON");
    lon.setBounds(340, 30, 50, 25);
    lon.setFont(new Font("", Font.BOLD, 20));
    lon.setForeground(Color.white);
    lon.setVisible(false);
    panel.add(lon);

    loff = new JLabel("OFF");
    loff.setBounds(340, 60, 50, 25);
    loff.setFont(new Font("", Font.BOLD, 20));
    loff.setForeground(Color.white);
    panel.add(loff);

    Ton = new JButton("");
    Ton.setBounds(260, 30, 80, 25);
    Ton.setBackground(new Color(0, 133, 0));
    panel.add(Ton);

    Toff = new JButton("");
    Toff.setBounds(260, 60, 80, 25);
    Toff.setBackground(new Color(193, 0, 0));
    panel.add(Toff);

    JLabel lText = new JLabel("Threshold Settings");
    lText.setBounds(150, 100, 300, 35);
    lText.setFont(new Font("", Font.BOLD, 20));
    lText.setForeground(Color.white);
    panel.add(lText);

    l1 = new JLabel("Minimum");
    l1.setBounds(80, 160, 100, 35);
    l1.setFont(new Font("", Font.BOLD, 20));
    l1.setForeground(Color.white);
    panel.add(l1);

    mText1 = new JTextField(20);
    mText1.setBounds(240, 165, 140, 25);
    mText1.setFont(new Font("", Font.BOLD, 20));
    mText1.setEnabled(false);
    panel.add(mText1);

    l2 = new JLabel("Maximum");
    l2.setBounds(80, 220, 100, 35);
    l2.setFont(new Font("", Font.BOLD, 20));
    l2.setForeground(Color.white);
    panel.add(l2);

    mText2 = new JTextField(20);
    mText2.setBounds(240, 225, 140, 25);
    mText2.setFont(new Font("", Font.BOLD, 20));
    mText2.setEnabled(false);
    panel.add(mText2);

    amin = int(getConfigInfo("alrmMin"));
    amax = int(getConfigInfo("alrmMax"));
    mText1.setText(amin+"");
    mText2.setText(amax+"");

    save = new JButton("SAVE");
    save.setBounds(80, 300, 100, 45);
    panel.add(save);

    close_c = new JButton("CLOSE");
    close_c.setBounds(280, 300, 100, 45);
    close_c.setBackground(new Color(0, 213, 0));
    panel.add(close_c);

    AlaramStatusInfo(toggleValue);

    Ton.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        alarm_S = 1;
        toggleValue = true;
        buzzerAlert = true;
        AlaramStatusInfo(toggleValue);
      }
    }
    );

    Toff.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        alarm_S = 0;
        toggleValue = false;
        ringing = false;
        buzzerAlert = false;
        println(toggleValue);
        String s = "0AFA180006000000000000000000000000000000000000000000000000000B";
        byte[] bytearray = hexStringToByteArray(s);
        for (int i=0; i<bytearray.length; i++) 
        {    
          port.write(bytearray[i]);
          delay(1);
        }

        AlaramStatusInfo(toggleValue);
      }
    }
    );

    mText1.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        if (alarm_S == 1)
        {
          keyboard.dispose();
          numberString = "";
          keyboard = new JFrame();
          keyboard.setSize(200, 200);
          keyboard.setLocation(width/2, height/2);
          keyboard.add(new JKeyBoard(mText1));
          keyboard.setVisible(true);
        }
      }
    }
    );

    mText2.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        if (alarm_S == 1)
        {
          keyboard.dispose();
          numberString = "";
          keyboard = new JFrame();
          keyboard.setSize(200, 200);
          keyboard.setLocation(width/2, height/2);
          keyboard.add(new JKeyBoard(mText2));
          keyboard.setVisible(true);
        }
      }
    }
    );

    save.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        if (alarm_S == 1)
        {
          keyboard.dispose();
          try
          {
            amin = Integer.parseInt(mText1.getText().toString());
            amax = Integer.parseInt(mText2.getText().toString());
            setConfigInfo("alrmMin", amin+"");
            setConfigInfo("alrmMax", amax+"");
            helpWidget.aStatus("Status : ON", "Minimum : "+amin, "Maximum : "+amax);
            if (toggleValue)
            {
              showMessageDialog(null, "Alarm threshold is changed");
            }
          }
          catch(Exception ex)
          {
            l_err.setVisible(true);
          }
          String s = "0AFA180003"+toHexa(alarm_S)+toHexa((long)amin) +toHexa((long)amax)+"000000000000000000000000000B";
          byte[] bytearray = hexStringToByteArray(s);
          for (int i=0; i<bytearray.length; i++) 
          {    
            port.write(bytearray[i]);
            delay(1);
          }
        }
      }
    }
    );

    close_c.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        Aframe.setVisible(false);
      }
    }
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  //
  //   Common Functionalities are together defined as a module
  //      - Visiblity
  //      - Enable/Disable
  //      - Color Scheme
  //      - Status Information
  //    This function is executed according to the toggle value
  //
  /////////////////////////////////////////////////////////////////////////////////////////

  public void AlaramStatusInfo(boolean toggleValue)
  {
    if (toggleValue)
    {
      Toff.setVisible(true);
      Ton.setVisible(false);
      lon.setVisible(true);
      loff.setVisible(false);
      mText1.setEnabled(true);
      mText2.setEnabled(true);
      save.setEnabled(true);
      save.setBackground(new Color(0, 213, 0));
      silence.setEnabled(true);
      silence.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      helpWidget.aStatus("Status : ON", "Minimum : "+amin, "Maximum : "+amax);
    } 
    if (!toggleValue)
    {
      Toff.setVisible(false);
      Ton.setVisible(true);
      loff.setVisible(true);
      lon.setVisible(false);
      mText1.setEnabled(false);
      mText2.setEnabled(false);
      save.setEnabled(false);
      save.setBackground(new Color(0, 90, 148));
      silence.setEnabled(false);
      silence.setLocalColorScheme(GCScheme.CYAN_SCHEME);
      helpWidget.aStatus("Status : OFF");
    }
  }
}