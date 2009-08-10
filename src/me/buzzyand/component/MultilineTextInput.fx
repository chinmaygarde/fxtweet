/*
 * MultilineTextInput.fx
 *
 * Created on Mar 18, 2009, 7:54:55 PM
 *
 * Thanks Steve from
 * http://forums.sun.com/thread.jspa?threadID=5357725&messageID=10558050#10558050
 */

package me.buzzyand.component;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Font;
import javafx.ext.swing.SwingComponent;
import javax.swing.JComponent;
import javax.swing.JTextArea;
import java.awt.Color;

public class MultilineTextInput extends SwingComponent{

    var myComponent: JTextArea;

    public var length: Integer;
    public var readText: String;
    public var text: String on replace{
        myComponent.setText(text);
    }

    public var toolTipText: String on replace{
        myComponent.setToolTipText(toolTipText);
    }


    public override function createJComponent():JComponent{
        //translateX = 15;
        //translateY = 5;
        var f: Font = new Font("arial",Font.PLAIN, 14);

        myComponent = new JTextArea(4, 15);
        myComponent.setOpaque(false);
        myComponent.setFont(f);
        myComponent.setWrapStyleWord(true);
        myComponent.setLineWrap(true);
        myComponent.addKeyListener

        ( KeyListener{
                public override function
             keyPressed(keyEvent:KeyEvent) {
                    if (keyEvent.VK_PASTE == keyEvent.getKeyCode())
                 {
                        myComponent.paste();
                    }
                }

                public override function
             keyReleased( keyEvent:KeyEvent) {
                    var pos = myComponent.getCaretPosition();
                    text = myComponent.getText();
                    myComponent.setCaretPosition(pos);
                }

                public override function
             keyTyped(keyEvent:KeyEvent) {
                    length = myComponent.getDocument().getLength();
                }
        }
        );

        return myComponent;
    }




}