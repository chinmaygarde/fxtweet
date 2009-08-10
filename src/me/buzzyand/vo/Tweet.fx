/*
 * Tweet.fx
 *
 * Created on Mar 7, 2009, 1:38:27 AM
 */

package me.buzzyand.vo;

/**
 * @author Buzzy
 */

public class Tweet {
    public var createdAt: String;
    public var id: String;
    public var text: String;
    public var source: String;
    public var user:User = User{};
}