/*
 * PostTweetHttpRequest.fx
 *
 * Created on Mar 20, 2009, 7:33:09 PM
 */

package me.buzzyand.service;

import java.io.InputStream;
import javafx.io.http.HttpHeaders;
import javafx.io.http.HttpRequest;
import me.buzzyand.utils.Base64;
import java.lang.Exception;
//import fxtweet.FXTweet;
/**
 * @author Buzzy
 */
public class PostTweetHttpRequest extends HttpRequest {
    public var sendString:String = "";
    def POST_TWEET_URL = "http://twitter.com/statuses/update.xml";
    def DIRECT_MESSAGES_URL = "http://twitter.com/direct_messages/new.xml";
    init
    {
        //var credentials = Base64.encodeBytes("fxtweet:omicronthetaone".getBytes());
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
    public override var onOutput = function (output: java.io.OutputStream) {
         try {
            output.write(sendString.getBytes());
         } finally {
             output.close();
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
    public function postTweet(inputProcessorFunction:function(input:InputStream), message:String, username, password) {
        sendString = "status={message}";
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.POST;
        location = POST_TWEET_URL;
        var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
        this.enqueue();
    }
    public function postReply(inputProcessorFunction:function(input:InputStream), message:String, replyToStatusId:String, username, password) {
        sendString = "status={message}&in_reply_to_status_id={replyToStatusId}";
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.POST;
        location = POST_TWEET_URL;
        var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
        this.enqueue();
    }
    public function postDirectMessage(inputProcessorFunction:function(input:InputStream), user:String, text:String, username, password) {
        sendString = "user={user}&text={text}";
        inputProcessor = inputProcessorFunction;
        method = HttpRequest.POST;
        location = DIRECT_MESSAGES_URL;
        var credentials = Base64.encodeBytes("{username}:{password}".getBytes());
        this.setHeader(HttpHeaders.AUTHORIZATION, "Basic {credentials}");
        this.enqueue();
    }
}
