/*
 * TweetBox.fx
 *
 * Created on Mar 7, 2009, 2:52:16 PM
 */

package me.buzzyand.container;

import javafx.ext.swing.SwingLabel;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javafx.scene.text.Text;
import me.buzzyand.vo.Tweet;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.input.MouseEvent;
import javafx.animation.Interpolator;

/**
 * @author Buzzy
 */

public class TweetBox extends CustomNode {

    var r = 0;
    var sx = 0.99;
    var sy = 0.99;
    public var timeline = Timeline {
        repeatCount: 1
        keyFrames: [
            KeyFrame {
                time: 1s;
                canSkip: true;
                values: [
                    r => 360 tween Interpolator.EASEBOTH,
                    sx => 0 tween Interpolator.EASEBOTH,
                    sy => 0 tween Interpolator.EASEBOTH
                ]
            }
        ]
    }
    public var tweet: Tweet;
    public var dataContent: Group = Group {
        content: [ 
            ImageView {
                translateX: 10;
                translateY: 10;
                image: Image {
                    preserveRatio: true;
                    url: tweet.user.profileImageUrl;
                    width: 48;
                    width: 48;
                    backgroundLoading: true;
                }
                onMouseClicked: function( e: MouseEvent ):Void {
                    timeline.play();
                }
            },
            Text {
                translateX:65;
                translateY:20;
                content: tweet.text;
                wrappingWidth: 200;
            },
            SwingLabel {
                translateX:10;
                translateY:75;
                text: "{tweet.user.screenName} via {getStrippedString(tweet.source)} ";
            }
        ]
    };
    public var container:Group = Group{
        rotate: bind r;
        scaleX: bind sx;
        scaleY: bind sy;
        content: [
            Rectangle {
                x: 0,
                y: 0,
                width: 270,
                height: 125,
                fill: Color.GRAY
            },
            dataContent
        ]
    }

    public override function create(): Node {
        return container;
    }
    public function getStrippedString(source:String):String {
        var index1 = tweet.source.indexOf('>');
        var index2 = tweet.source.indexOf('<', index1);
        if(index1 != - 1 or index2 != - 1)
        {
            return source.substring(index1 + 1, index2);
        }
        else
        {
            return source;
        }
    }

}