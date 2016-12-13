//////////////////////////////////////////////////////////////////////////////////////////
//
//   Keyboard FRame:
//      - When the textbox is pressed, it pops up a Keyboard to enter the values
//
//   
//
//   Requires Java Swing Package
//   
/////////////////////////////////////////////////////////////////////////////////////////

import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

class JKeyBoard extends JPanel {

  JTextField jtf;                                              // Refers to a specific TextField/TextBox

  // Java Swing Button Declaration

  JButton b1 = new JButton("1");
  JButton b2 = new JButton("2");
  JButton b3 = new JButton("3");
  JButton b4 = new JButton("4");
  JButton b5 = new JButton("5");
  JButton b6 = new JButton("6");
  JButton b7 = new JButton("7");
  JButton b8 = new JButton("8");
  JButton b9 = new JButton("9");
  JButton b0 = new JButton("0");
  JButton bclear = new JButton("C");
  JButton bminus = new JButton("-");

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  This Function creates a Panel and add the necessary Components like Buttons, Labels, TextBox, etc.,
  //  Whenever the user click the textfield, a pop up keyboard frame is called and the panels are added.
  //  The Frame disappears when we click outside the textBox. [like Buttons]
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  public JKeyBoard(JTextField text) {

    jtf = text;

    JPanel panel1 = new JPanel(new GridLayout(4, 3));              // Declaring JAva Swing Panel

    // Adding buttons to the panel declared
    panel1.add(b1);
    panel1.add(b2);
    panel1.add(b3);
    panel1.add(b4);
    panel1.add(b5);
    panel1.add(b6);
    panel1.add(b7);
    panel1.add(b8);
    panel1.add(b9);
    panel1.add(b0);
    panel1.add(bminus);
    panel1.add(bclear);

    // Button Listner Class Object
    ButtonListener listener = new ButtonListener();

    // add listener to all buttons
    b1.addActionListener(listener);
    b2.addActionListener(listener);
    b3.addActionListener(listener);
    b4.addActionListener(listener);
    b5.addActionListener(listener);
    b6.addActionListener(listener);
    b7.addActionListener(listener);
    b8.addActionListener(listener);
    b9.addActionListener(listener);
    b0.addActionListener(listener);
    bclear.addActionListener(listener);
    bminus.addActionListener(listener);

    setLayout(new BorderLayout());
    add(panel1, BorderLayout.CENTER);
  }

  /************ Button Listner Class ***************/

  ////////////////////////////////////////////////////////////////////////////////
  //
  //  This class handles the Listener of all the buttons in the panel
  //  A String concatenates the numbers that are pressed in the keyboard frame
  //  It Displays the value to the respective TextField
  //
  ///////////////////////////////////////////////////////////////////////////////

  class ButtonListener implements ActionListener {

    @Override
      public void actionPerformed(ActionEvent e) {
      if (e.getSource() == b1) {
        numberString += "1";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b2) {
        numberString += "2";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b3) {
        numberString += "3";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b4) {
        numberString += "4";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b5) {
        numberString += "5";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b6) {
        numberString += "6";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b7) {
        numberString += "7";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b8) {
        numberString += "8";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b9) {
        numberString += "9";
        jtf.setText(numberString);
      }  
      if (e.getSource() == b0) {
        numberString += "0";
        jtf.setText(numberString);
      }  
      if (e.getSource() == bclear) {
        numberString = "";
        jtf.setText("");
      }  
      if (e.getSource() == bminus) {
        numberString += "-";
        jtf.setText(numberString);
      }
    }
  }
}