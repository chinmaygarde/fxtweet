/*
 * FXTweet.fx
 * Thanks to http://weblogs.java.net/blog/malenkov/archive/2009/03/sidebarfx_1.html
 * for the transparent fullscreen windows hack
 * Created on Mar 19, 2009, 6:57:09 PM
 */

package fxtweet;

import java.lang.Math;
import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.data.pull.PullParser;
import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javafx.scene.Group;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.Scene;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.text.Font;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import me.buzzyand.component.PasswordInput;
import me.buzzyand.container.DecoratedTweetBox;
import me.buzzyand.service.*;
import me.buzzyand.vo.Tweet;
var username:String = bind userInput.text;
var password:String = bind passwordInput.text;
var isLoggedIn:Boolean = false;
var currentRequestColor:String = "blue";
var boxCount = 0;
var tweetGroup:Group;
var tweets: Tweet[] = [] on replace oldValues[low .. hi] = newValues {
    for (val in newValues) {
        insert
        DecoratedTweetBox {
            boxColor: "blue";
            tweet: val;
            translateX: width * (Math.random() * 0.8);
            translateY: height * (Math.random() * 0.8);
        } into group.content
    }

};

var httpInputProcessor = function(input:java.io.InputStream) {
    PullParser {
        var tempTweet: Tweet = Tweet {
        };
        input: input;
        documentType: PullParser.XML;
        onEvent: function(event) {
            if(event.type == PullParser.END_ELEMENT)
                {
                    //Tweet
                if(event.qname.name == "created_at" and event.level == 2)
                tempTweet.createdAt = event.text;
                if(event.qname.name == "id" and event.level == 2)
                tempTweet.id = event.text;
                if(event.qname.name == "text" and event.level == 2)
                tempTweet.text = event.text;
                if(event.qname.name == "source" and event.level == 2)
                tempTweet.source = event.text;

                //Tweet.User
                if(event.qname.name == "id" and event.level == 3)
                tempTweet.user.id = event.text;
                if(event.qname.name == "screen_name" and event.level == 3)
                tempTweet.user.screenName = event.text;
                if(event.qname.name == "location" and event.level == 3)
                tempTweet.user.location = event.text;
                if(event.qname.name == "description" and event.level == 3)
                tempTweet.user.description = event.text;
                if(event.qname.name == "profile_image_url" and event.level == 3)
                tempTweet.user.profileImageUrl = event.text;
                if(event.qname.name == "status")
                {
                        //insert tempTweet into tweets;
                        if(boxCount < 6)
                        {
                            insert DecoratedTweetBox {
                                boxColor: currentRequestColor;
                                tweet: tempTweet;
                                translateX: width * (Math.random() * 0.8);
                                translateY: height * (Math.random() * 0.8);
                                username: this.username;
                                password: this.password;
                            } into group.content;
                            tempTweet = Tweet {};
                        }
                        boxCount ++ ;
                }
            }
            if(event.type == PullParser.END_DOCUMENT){ };
        }

    }.parse();
}
var tweetInputProcessor = function(input:java.io.InputStream) {
    PullParser {
        input: input;
        documentType: PullParser.XML;
        onEvent: function(event) {
        
        }
    }.parse();
}
var screenWidth = bind screen.width;
var screenHeight = bind screen.height;
var col = Color.rgb(30, 30, 255);
var yPoz = 0;
var op = 0.50;
var hidden: Boolean = true;
var userInput: SwingTextField;
var passwordInput: PasswordInput;
var newTweetInput: SwingTextField;
var inputBox: Group = Group {
    translateY:20;
    content: [
        SwingLabel {
          translateY: 0;
          translateX: bind screenWidth - (screenWidth / 12) - 250;
          text: bind (140 - newTweetInput.text.length()).toString();
          opacity:0.75;
          foreground:Color.WHITE;
          font:Font {
                size:100;
            }
        },

        VBox {
            spacing: 10;
            visible:bind not isLoggedIn;
            translateX: bind screenWidth / 12 + 250;
            translateY: bind screenHeight / 5 - 120;
            content: [
                HBox {
                    spacing: 10;
                    content: [
                        SwingLabel {
                            text: "Username"
                            foreground:Color.WHITE;
                        },
                        userInput = SwingTextField {
                            columns: 10
                            text: "";
                            editable: true
                        },
                    ];
                },
                HBox {
                    spacing: 10;
                    content: [
                        SwingLabel {
                            text: "Password"
                            foreground:Color.WHITE;
                        },
                        passwordInput = PasswordInput {
                            columns: 10
                        },
                    ];
                },
                SwingButton {
                    text: "Login"
                    width: 150
                    action: function() {
                        //Do login
                        isLoggedIn = true;
                    }
                }

            ];
        }
        
        HBox {
            visible:bind isLoggedIn;
            spacing: 10;
            translateX: bind screenWidth / 12 + 250;
            translateY: bind screenHeight / 5 - 130;
            content: [
                SwingButton {
                    text: "Public"
                    action: function() {
                        delete group.content[1..];
                        boxCount = 0;
                        col = Color.ORANGE;
                        currentRequestColor = "orange";
                        var userHttpRequest = TwitterHttpRequest {
                        }.getPublicTimeline(httpInputProcessor);
                    }
                },
                SwingButton {
                    text: "Friends"
                    action: function() {
                        delete group.content[1..];
                        boxCount = 0;
                        col = Color.BLUE;
                        currentRequestColor = "blue";
                        var userHttpRequets =
                        TwitterHttpRequest {
                        }.getFriendTweets(httpInputProcessor, username, password);
                    }
                },
                SwingButton {
                    text: "Replies"
                    action: function() {
                        delete group.content[1..];
                        boxCount = 0;
                        col = Color.GREEN;
                        currentRequestColor = "green";
                        var userHttpRequets =
                        TwitterHttpRequest {
                        }.getReplyTweets(httpInputProcessor, username, password);
                    }
                },
            ];
        }


        HBox {
            visible:bind isLoggedIn;
            translateX: bind screenWidth / 12 + 110;
            translateY: bind screenHeight / 5 - 50;
            spacing: 5;
            content: [
                newTweetInput = SwingTextField {
                    columns: 50
                    text: ""
                    editable: true
                }
                SwingButton {
                    text: "Post Tweet"
                    action: function() {
                        var postTweetRequest = PostTweetHttpRequest {
                        }.postTweet(tweetInputProcessor, newTweetInput.text, username, password);
                        newTweetInput.text = "";
                    }
                }
                SwingButton {
                    text: bind if (hidden) "Hide" else "Show";
                    width:100;
                    action: function() {
                        if(hidden)
                        {
                            timeline.rate = 1;
                        }
                        else
                        {
                            timeline.rate = -1;
                        }
                        timeline.play();
                    }
                }
            ]
        }
    ];
};
/*
    Control Panel
*/



var timeline = Timeline {
    repeatCount: 1;
    keyFrames: [
        KeyFrame {
            time: 0.5s
            values: [
                yPoz => - (screenHeight / 5) + 65 tween Interpolator.EASEBOTH,
                op => 1 tween Interpolator.EASEBOTH
            ];
            action: function() {
                if(hidden)
                {
                    hidden = false;
                }
                else
                {
                    hidden = true;
                }
            }
        }
    ]
}

var path:Path = Path {
    //translateY: bind yPoz;
    fill: bind col;
    opacity: bind op;
    strokeWidth: 0;

    elements: [
        MoveTo {
            x: 0.0,
            y: 0.0
        },
        LineTo {
            x: bind screenWidth / 12,
            y: bind screenHeight / 5
        },
        LineTo {
            x: bind screenWidth - (screenWidth / 12),
            y: bind screenHeight / 5
        },
        LineTo {
            x: bind screenWidth,
            y: 0;
        },
        LineTo {
            x: 0,
            y: 0;
        },
    ]
};

var controlPanel:Group = Group {
    translateX: 0;
    translateY: bind yPoz;
    content: [path, inputBox]
}

var group: Group = Group{
    content: [
        controlPanel,
    ];
};
def stage = Stage {
    y: 0
    width: 250
    height: 1
    style: StageStyle.TRANSPARENT;
    title: "FXTweet";
    scene: Scene {
        fill: null
        content: bind group
    }
}
def screen = Stage {
    fullScreen: true
}

def height = bind screen.height on replace {
    if (height > 0) {
        screen.close();
        stage.height = height;
        stage.width = screen.width;
    }
}
def width = bind screen.width;