/*
 * PasswordInput.fx
 *
 * Created on Mar 18, 2009, 7:00:14 PM
 *
 *
 * @author Buzzy
 * Thanks to http://jfx.wikia.com/wiki/SwingComponents
 * Excellent Stuff
 */
package me.buzzyand.component;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javafx.ext.swing.SwingComponent;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.JComponent;
import javax.swing.JPasswordField;

public class PasswordInput extends SwingComponent {

    var passwordField: JPasswordField;
    public var columns: Integer on replace oldValue = newValue{
        passwordField.setColumns(newValue);
    };

    public var text: String;

    var external: Boolean = false;

    var triggered: String = bind text on replace oldValue{
        if(external){
            external = false;
        }
        else
        passwordField.setText(text);
    }
    public var action: function();

    public override function createJComponent():JComponent{
        passwordField = new JPasswordField();
        passwordField.setColumns(12);

        passwordField.addActionListener

        (ActionListener{
                public override function actionPerformed(e:ActionEvent){
                    action();
                }
        });

        passwordField.getDocument().addDocumentListener

        (DocumentListener {
                public override function insertUpdate( e:DocumentEvent) {
                    external = true;
                    text = passwordField.getText();
                }

                public override function removeUpdate( e:DocumentEvent) {
                    external = true;
                    text = passwordField.getText();
                }

                public override function changedUpdate( e:DocumentEvent) {
                    external = true;
                    text = passwordField.getText();
                }

        });

        return passwordField;
    }

}