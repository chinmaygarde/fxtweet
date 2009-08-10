/*
 * Generated by JavaFX Production Suite NetBeans plugin.
 * TweetBoxUI.fx
 *
 * Created on Fri Mar 20 22:39:25 IST 2009
 */
package me.buzzyand.ui;

import java.lang.Object;
import java.lang.System;
import java.lang.RuntimeException;
import javafx.scene.Node;
import javafx.fxd.UiStub;

public class TweetBoxUI extends UiStub {
	
	override public var url = "{__DIR__}TweetBox.fxz";
	
	public var blue_background: Node;
	public var close_button: Node;
	public var direct_message_button: Node;
	public var green_background: Node;
	public var orange_background: Node;
	public var post_tweet_button: Node;
	public var reply_button: Node;
	public var retweet_button: Node;
	
	override protected function update() {
		lastNodeId = null;
		 try {
			blue_background=getNode("blue_background");
			close_button=getNode("close_button");
			direct_message_button=getNode("direct_message_button");
			green_background=getNode("green_background");
			orange_background=getNode("orange_background");
			post_tweet_button=getNode("post_tweet_button");
			reply_button=getNode("reply_button");
			retweet_button=getNode("retweet_button");
		} catch( e:java.lang.Exception) {
			System.err.println("Update of the  attribute '{lastNodeId}' failed with: {e}");
			throw e;
		}
	}
}

