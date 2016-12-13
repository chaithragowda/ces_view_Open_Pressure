//////////////////////////////////////////////////////////////////////////////////////////
//
//   Calibration Window:
//      - Measure 6 Points Calibration [ or entered manually]
//      - Write Button - The values are stored in the device
//      - Read Button - The values are read from the device
//      - JFrame For Keyboard is popped to enter values manually
//      - When the textbox is pressed, it pops up a Keyboard to enter the values
//
//  
//
//   Requires Java Swing Package
//   
/////////////////////////////////////////////////////////////////////////////////////////

import java.awt.event.MouseEvent;

public class Calibration_Window { 
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  placeComponents() creates a Panel and add the necessary Components like Buttons, Labels, TextBox, etc.,
  //  This Function is called whenever the user needs to do Calibration.
  //  The Buttons like
  //      - Cread :  Calls the function Read_from_Device() in the main class to exceute the read operation
  //      - Cwrite:  Calls the function Write_to_Device() in the main class which sends the data from the Textbox 
  //   
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  private void placeComponents(JPanel panel) {

    panel.setLayout(null);
    panel.setBackground(new Color(0, 90, 148));

    l_err = new JLabel("*** Error : Only Numberic Values are allowed ***"); 
    l_err.setBounds(200, 5, 360, 35);
    l_err.setFont(new Font("", Font.BOLD, 15));
    l_err.setForeground(Color.RED);
    panel.add(l_err);
    l_err.setVisible(false);


    l_unit = new JLabel("ADC Value (µV)");
    l_unit.setBounds(250, 30, 140, 25);
    l_unit.setFont(new Font("", Font.BOLD, 15));
    l_unit.setForeground(Color.white);
    panel.add(l_unit);

    l1 = new JLabel("0.1 mmHg");
    l1.setBounds(80, 55, 100, 35);
    l1.setFont(new Font("", Font.BOLD, 20));
    l1.setForeground(Color.white);
    panel.add(l1);

    mText1 = new JTextField(20);
    mText1.setBounds(240, 65, 140, 25);
    mText1.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText1);

    mb1 = new JButton("Measure");
    mb1.setBounds(450, 55, 120, 45);
    mb1.setBackground(new Color(0, 213, 0));
    panel.add(mb1);

    l2 = new JLabel("1 mmHg");
    l2.setBounds(80, 105, 100, 35);
    l2.setFont(new Font("", Font.BOLD, 20));
    l2.setForeground(Color.white);
    panel.add(l2);

    mText2 = new JTextField(20);
    mText2.setBounds(240, 115, 140, 25);
    mText2.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText2);

    mb2 = new JButton("Measure");
    mb2.setBounds(450, 105, 120, 45);
    mb2.setBackground(new Color(0, 213, 0));
    panel.add(mb2);

    l3 = new JLabel("5 mmHg");
    l3.setBounds(80, 155, 120, 35);
    l3.setFont(new Font("", Font.BOLD, 20));
    l3.setForeground(Color.white);
    panel.add(l3);

    mText3 = new JTextField(80);
    mText3.setBounds(240, 165, 140, 25);
    mText3.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText3);

    mb3 = new JButton("Measure");
    mb3.setBounds(450, 155, 120, 45);
    mb3.setBackground(new Color(0, 213, 0));
    panel.add(mb3);

    l4 = new JLabel("10 mmHg");
    l4.setBounds(80, 205, 120, 35);
    l4.setFont(new Font("", Font.BOLD, 20));
    l4.setForeground(Color.white);
    panel.add(l4);

    mText4 = new JTextField(80);
    mText4.setBounds(240, 215, 140, 25);
    mText4.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText4);

    mb4 = new JButton("Measure");
    mb4.setBounds(450, 205, 120, 45);
    mb4.setBackground(new Color(0, 213, 0));
    panel.add(mb4);

    l5 = new JLabel("40 mmHg");
    l5.setBounds(80, 255, 120, 35);
    l5.setFont(new Font("", Font.BOLD, 20));
    l5.setForeground(Color.white);
    panel.add(l5);

    mText5 = new JTextField(80);
    mText5.setBounds(240, 265, 140, 25);
    mText5.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText5);

    mb5 = new JButton("Measure");
    mb5.setBounds(450, 255, 120, 45);
    mb5.setBackground(new Color(0, 213, 0));
    panel.add(mb5);

    l6 = new JLabel("100 mmHg");
    l6.setBounds(80, 305, 120, 35);
    l6.setFont(new Font("", Font.BOLD, 20));
    l6.setForeground(Color.white);
    panel.add(l6);

    mText6 = new JTextField(80);
    mText6.setBounds(240, 315, 140, 25);
    mText6.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText6);

    mb6 = new JButton("Measure");
    mb6.setBounds(450, 305, 120, 45);
    mb6.setBackground(new Color(0, 213, 0));
    panel.add(mb6);

    Cread = new JButton("READ FROM DEVICE");
    Cread.setBounds(60, 380, 150, 55);
    Cread.setBackground(new Color(0, 213, 0));
    panel.add(Cread);

    Cwrite = new JButton("WRITE TO DEVICE");
    Cwrite.setBounds(240, 380, 140, 55);
    Cwrite.setBackground(new Color(0, 213, 0));
    panel.add(Cwrite);

    close_c = new JButton("CANCEL");
    close_c.setBounds(420, 380, 120, 55);
    close_c.setBackground(new Color(0, 213, 0));
    panel.add(close_c);


    close_c.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        cali_win = false;
        keyboard.dispose();
        CFrame.setVisible(false);
      }
    }
    );

    Cread.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        cali_win = true;
        keyboard.dispose();
        Read_From_Device();
      }
    }
    );

    mb1.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText1.setText(""+data1);
      }
    }
    );

    mb2.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText2.setText(""+data1);
      }
    }
    );

    mb3.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText3.setText(""+data1);
      }
    }
    );

    mb4.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText4.setText(""+data1);
      }
    }
    );

    mb5.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText5.setText(""+data1);
      }
    }
    );

    mb6.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText6.setText(""+data1);
      }
    }
    );

    Cwrite.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        try
        {
          keyboard.dispose();
          c11 = (long)(Double.parseDouble(mText1.getText()));
          c12 = (long)(Double.parseDouble(mText2.getText()));
          c13 = (long)(Double.parseDouble(mText3.getText()));
          c14 = (long)(Double.parseDouble(mText4.getText()));
          c15 = (long)(Double.parseDouble(mText5.getText()));
          c16 = (long)(Double.parseDouble(mText6.getText()));
          Write_To_Device();
        }
        catch(Exception ex)
        {
          println(ex);
          l_err.setVisible(true);
        }
      }
    }
    );

    mText1.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
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
    );

    mText2.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
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
    );

    mText3.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        keyboard.dispose();
        numberString = "";
        keyboard = new JFrame();
        keyboard.setSize(200, 200);
        keyboard.setLocation(width/2, height/2);
        keyboard.add(new JKeyBoard(mText3));
        keyboard.setVisible(true);
      }
    }
    );

    mText4.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        keyboard.dispose();
        numberString = "";
        keyboard = new JFrame();
        keyboard.setSize(200, 200);
        keyboard.setLocation(width/2, height/2);
        keyboard.add(new JKeyBoard(mText4));
        keyboard.setVisible(true);
      }
    }
    );

    mText5.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        keyboard.dispose();
        numberString = "";
        keyboard = new JFrame();
        keyboard.setSize(200, 200);
        keyboard.setLocation(width/2, height/2);
        keyboard.add(new JKeyBoard(mText5));
        keyboard.setVisible(true);
      }
    }
    );

    mText6.addMouseListener(new MouseAdapter()
    {
      public void mouseClicked(MouseEvent e)
      {
        keyboard.dispose();
        numberString = "";
        keyboard = new JFrame();
        keyboard.setSize(200, 200);
        keyboard.setLocation(width/2, height/2);
        keyboard.add(new JKeyBoard(mText6));
        keyboard.setVisible(true);
      }
    }
    );
  }
}