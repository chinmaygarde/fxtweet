/*
 * DecoratedTweetBox.fx
 *
 * Created on Mar 18, 2009, 1:35:04 AM
 */

package me.buzzyand.container;

import java.lang.Math;
import java.net.URLEncoder;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.data.pull.PullParser;
import javafx.ext.swing.SwingLabel;
import javafx.scene.Cursor;
import javafx.scene.CustomNode;
import javafx.scene.effect.PerspectiveTransform;
import javafx.scene.Group;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import me.buzzyand.component.MultilineTextInput;
import me.buzzyand.service.PostTweetHttpRequest;
import me.buzzyand.ui.TweetBoxUI;
import me.buzzyand.vo.Tweet;

/**
 * @author Buzzy
 */

public class DecoratedTweetBox extends CustomNode {

    public var username:String;
    public var password:String;
    var time = Math.PI / 2;
    var anim = Timeline {
        keyFrames: [
            at(0s) { time => Math.PI / 2 tween Interpolator.LINEAR},
            at(0.5s) { time => 0 tween Interpolator.LINEAR},
            at(1s) { time => Math .PI / 2 tween Interpolator.LINEAR},
            KeyFrame {
                time: 0.5s
                action: function() {
                    toggleEditMode();
                }
            }
        ]
    }

    function getPerspectiveTransform(t:Number):PerspectiveTransform {
        var width = 357;
        var height = 184;
        var radius = width / 2;
        var back = height / 10;
        return PerspectiveTransform {
            ulx: radius - Math.sin(t)*radius     uly: 0 - Math.cos(t)*back
            urx: radius + Math.sin(t)*radius     ury: 0 + Math.cos(t)*back
            lrx: radius + Math.sin(t)*radius     lry: height - Math.cos(t)*back
            llx: radius - Math.sin(t)*radius     lly: height + Math.cos(t)*back
        }
    }
    public override var effect =  bind getPerspectiveTransform(time);
    public function toggleEditMode()
    {
        if(editMode)
        {
            editMode = false;
        }
        else
        {
            editMode = true;
        }
    }
    public var postType: String = "Reply";
    public var tweet: Tweet;
    
    public var editMode: Boolean = false on replace oldValue = newValue {
        if(not newValue)
        {
            ui.post_tweet_button.visible = false;
        }
        else
        {
            ui.post_tweet_button.visible = true;
        }


    };
    public var boxColor: String on replace oldValue = newValue{
        setBoxColor(newValue);
    };
    public var bringFrontHandler = function(event)
    {
        this.toFront();
    }
    public var dragHandler = function(event:MouseEvent):Void
    {
        this.translateX = event.dragX + event.dragAnchorX - 185;
        this.translateY = event.dragY + event.dragAnchorY - 35;
    }
    function setBoxColor(color:String) {
        if(boxColor == "blue")
        {
            ui.blue_background.visible = true;
            ui.green_background.visible = false;
            ui.orange_background.visible = false;
        }
        else if(boxColor == "orange") {
            ui.blue_background.visible = false;
            ui.green_background.visible = false;
            ui.orange_background.visible = true;
        }
        else
        {
            ui.blue_background.visible = false;
            ui.green_background.visible = true;
            ui.orange_background.visible = false;
        }
    }

    public var ui = TweetBoxUI {
        
    };
    var tweetInput: MultilineTextInput;

    var closeHandler = function (event):Void {
        println("Close Button Clicked");
        //TODO: Find out how to remove objects from parent container
        this.visible = false;
    }
    var replyHandler = function (event):Void {
        postType = "Reply";
        tweetInput.text = "@{tweet.user.screenName} ";
        anim.playFromStart();
    }
    var retweetHandler = function (event):Void {
        postType = "Retweet";
        tweetInput.text = "RT @{tweet.user.screenName}: {tweet.text}";
        anim.playFromStart();
    }
    var directMessageHandler = function (event):Void {
        postType = "Direct Message";
        anim.playFromStart();
    }
    var postTweetHandler = function(event):Void {
        if(postType == "Reply")
        {
            var postTweetHttpRequest = PostTweetHttpRequest {
            }.postReply(httpInputProcessor, URLEncoder.encode(tweetInput.text) , tweet.id, username, password);
            tweetInput.text = "";
            
        }
        else if(postType == "Retweet") {
            var postTweetHttpRequest = PostTweetHttpRequest {
            }.postTweet(httpInputProcessor, URLEncoder.encode(tweetInput.text), username, password);
            tweetInput.text = "";
        }
        else if(postType == "Direct Message") {
            var postTweetHttpRequest = PostTweetHttpRequest {
            }.postDirectMessage(httpInputProcessor, tweet.user.screenName, URLEncoder.encode(tweetInput.text), username, password);
            tweetInput.text = "";
        }
        anim.playFromStart();
    }

    var httpInputProcessor = function(input:java.io.InputStream) {
        println("Got Input");
        PullParser {
            var tempTweet: Tweet = Tweet {
            };
            input: input;
            documentType: PullParser.XML;
            onEvent: function(event) {
                //TODO: Process event accordingly

            }

        }.parse();
    }
    init {
        ui.close_button.onMouseClicked = closeHandler;
        ui.direct_message_button.onMouseClicked = directMessageHandler;
        ui.reply_button.onMouseClicked = replyHandler;
        ui.retweet_button.onMouseClicked = retweetHandler;
        ui.post_tweet_button.onMouseClicked = postTweetHandler;

        ui.blue_background.onMouseClicked = bringFrontHandler;
        ui.green_background.onMouseClicked = bringFrontHandler;
        ui.orange_background.onMouseClicked = bringFrontHandler;

        ui.blue_background.onMouseDragged = dragHandler;
        ui.green_background.onMouseDragged = dragHandler;
        ui.orange_background.onMouseDragged = dragHandler;

        ui.blue_background.cursor = Cursor.MOVE;
        ui.green_background.cursor = Cursor.MOVE;
        ui.orange_background.cursor = Cursor.MOVE;

        ui.close_button.cursor = Cursor.HAND;
        ui.direct_message_button.cursor = Cursor.HAND;
        ui.reply_button.cursor = Cursor.HAND;
        ui.retweet_button.cursor = Cursor.HAND;
        ui.post_tweet_button.cursor = Cursor.HAND;

        ui.post_tweet_button.visible = false;

        setBoxColor(boxColor);
    }
    var mainGroup = Group {
        content: [
            ui,
            ImageView {
                translateX: 45;
                translateY: 45;
                image: Image {
                    preserveRatio: true;
                    url: tweet.user.profileImageUrl;
                    width: 48;
                    width: 48;
                    backgroundLoading: true;
                }
            },
            Text {
                translateX: 130;
                translateY: 80;
                content: tweet.text;
                wrappingWidth: 200;
                font: Font {
                    size: 14;
                }
                visible: bind not editMode;
            },
            SwingLabel {
                translateX: 130;
                translateY: 70;
                text: bind "Your Message ({postType}):  ";
                width: 200;
                font: Font {
                    size: 12;
                }
                visible: bind editMode;
            }
            tweetInput = MultilineTextInput {
                translateY: 90;
                translateX: 130;
                text: ""
                visible: bind editMode;
            }
            SwingLabel {
                translateX: 240;
                translateY: 110;
                text: bind
                (140 - tweetInput.text.length()).toString();
                font: Font {
                    size: 40;
                }
                visible: bind editMode;
                opacity: 0.30;
                width: 100;
            }
            SwingLabel {
                translateX: 140;
                translateY: 25;
                text: "{tweet.user.screenName} via {getStrippedString(tweet.source)} ";
                font: Font {
                    size: 12;
                }
            }
        ]
    };
    public override function create():
    Node {
        return mainGroup;
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