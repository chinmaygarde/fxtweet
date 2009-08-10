/*
 * TwitterHttpRequest.fx
 *
 * Created on Mar 15, 2009, 2:38:59 PM
 */

package me.buzzyand.service;

import fxtweet.FXTweet;
import java.io.InputStream;
import javafx.io.http.*;
import me.buzzyand.utils.Base64;
import java.lang.Exception;
/**
 * @author Buzzy
 */

public class TwitterHttpRequest extends HttpRequest {

    def PUBLIC_TIMELINE_URL = "http://twitter.com/statuses/public_timeline.xml";
    def USER_REPLIES_URL = "http://twitter.com/statuses/replies.xml";
    def FRIENDS_TIMELINE_URL = "http://twitter.com/statuses/friends_timeline.xml";
    init
    {
        //var credentials = Base64.encodeBytes("{FXTweet.username}:{FXTweet.password}".getBytes());
        //var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        //this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
    }
    public var inputProcessor: function(input:InputStream);
    public override var onInput = bind inputProcessor;
    
    public override var onResponseCode = function(responseCode:Integer) {
        if (responseCode == 200)
        {
            println("200 OK");
        }
        else
        {
            println("{responseCode} NOT OK");
        }
    }
    public override var onException = function(exception: Exception)
    {
        exception.printStackTrace();
        println(exception.toString());
    }
    public override var  onStarted = function()
    {
        println("Started");
    }
    public function getPublicTimeline(inputProcessorFunction:function(input:InputStream)) {
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.GET;
        location = PUBLIC_TIMELINE_URL;
        this.enqueue();
    }
    public function getReplyTweets(inputProcessorFunction:function(input:InputStream), username, password) {
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.GET;
        location = USER_REPLIES_URL;
        var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
        this.enqueue();
    }
    public function getFriendTweets(inputProcessorFunction:function(input:InputStream), username, password) {
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.GET;
        location = FRIENDS_TIMELINE_URL;
        var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
        this.enqueue();
    }
}