//////////////////////////////////////////////////////////////////////////////////////////
//
//   Temperature Window:
//      - Measure 3 Points Temperature Compensation [ or entered manually]
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

public class Temperature_Window { 
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  placeComponents() creates a Panel and add the necessary Components like Buttons, Labels, TextBox, etc.,
  //  This Function is called whenever the user needs to do Temperature Compensation.
  //  The Buttons like
  //      - Tread :  Calls the function Read_from_Device() in the main class to exceute the read operation
  //      - Twrite:  Calls the function Write_to_Device() in the main class which sends the data from the Textbox 
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
    l_unit.setBounds(250, 50, 140, 25);
    l_unit.setFont(new Font("", Font.BOLD, 15));
    l_unit.setForeground(Color.white);
    panel.add(l_unit);

    l1 = new JLabel("35 °C");
    l1.setBounds(80, 75, 100, 35);
    l1.setFont(new Font("", Font.BOLD, 20));
    l1.setForeground(Color.white);
    panel.add(l1);

    mText1 = new JTextField(20);
    mText1.setBounds(240, 80, 140, 25);
    mText1.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText1);

    mb1 = new JButton("Measure");
    mb1.setBounds(420, 80, 120, 25);
    mb1.setBackground(new Color(0, 213, 0));
    panel.add(mb1);

    l2 = new JLabel("40 °C");
    l2.setBounds(80, 145, 100, 35);
    l2.setFont(new Font("", Font.BOLD, 20));
    l2.setForeground(Color.white);
    panel.add(l2);

    mText2 = new JTextField(20);
    mText2.setBounds(240, 150, 140, 25);
    mText2.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText2);

    mb2 = new JButton("Measure");
    mb2.setBounds(420, 150, 120, 25);
    mb2.setBackground(new Color(0, 213, 0));
    panel.add(mb2);

    l3 = new JLabel("45 °C");
    l3.setBounds(80, 215, 120, 35);
    l3.setFont(new Font("", Font.BOLD, 20));
    l3.setForeground(Color.white);
    panel.add(l3);

    mText3 = new JTextField(80);
    mText3.setBounds(240, 220, 140, 25);
    mText3.setFont(new Font("", Font.BOLD, 20));
    panel.add(mText3);

    mb3 = new JButton("Measure");
    mb3.setBounds(420, 220, 120, 25);
    mb3.setBackground(new Color(0, 213, 0));
    panel.add(mb3);

    Tread = new JButton("READ FROM DEVICE");
    Tread.setBounds(60, 280, 150, 25);
    Tread.setBackground(new Color(0, 213, 0));
    panel.add(Tread);

    Twrite = new JButton("WRITE TO DEVICE");
    Twrite.setBounds(240, 280, 140, 25);
    Twrite.setBackground(new Color(0, 213, 0));
    panel.add(Twrite);

    close_c = new JButton("CANCEL");
    close_c.setBounds(420, 280, 120, 25);
    close_c.setBackground(new Color(0, 213, 0));
    panel.add(close_c);


    close_c.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        cali_win = false;
        TFrame.setVisible(false);
      }
    }
    );

    Tread.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        cali_win = true;
        Read_From_Device();
      }
    }
    );

    mb1.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText1.setText(""+data2);
      }
    }
    );

    mb2.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText2.setText(""+data2);
      }
    }
    );

    mb3.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        keyboard.dispose();
        mText3.setText(""+data2);
      }
    }
    );

    Twrite.addActionListener(new ActionListener()
    {
      public void actionPerformed(ActionEvent e)
      {
        try
        {
          keyboard.dispose();
          t1 = (long)(Double.parseDouble(mText1.getText()));
          t2 = (long)(Double.parseDouble(mText2.getText()));
          t3 = (long)(Double.parseDouble(mText3.getText()));
          Write_To_Device();
        }
        catch(Exception ex)
        {
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
  }
}