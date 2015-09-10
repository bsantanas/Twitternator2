//
//  FeedViewController.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/7/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit
import TwitterKit

class FeedViewController: UIViewController, NSURLSessionDataDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    var textToSearch:String?
    var tweets = [TWTRTweet]()
    var twtviews = [TWTRTweetView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "TweetCell")
        getTweets()
    }
    
    //MARK:- API Methods
    
    func getTweets() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": textToSearch!]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                var jsonError : NSError?
                if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as?  [String:AnyObject] {
                    if let statuses = json["statuses"] as? [[NSObject:AnyObject]] {
                        //println(statuses)
                        for eachTweet in statuses {
                            let tweet = TWTRTweet(JSONDictionary: eachTweet)
                            self.tweets.append(tweet)
                            let twtview = TWTRTweetView(tweet: tweet, style: .Compact)
                            self.twtviews.append(twtview)
                            }
                        println("Fetched \(self.tweets.count) tweets")
                        self.tableView.reloadData()
                    }
                
                
                }
            }
            else {
                println("Error: \(connectionError)")
            }
        }

    }
    
    
    //MARK:- Table View Data Source & Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! SwipeableCell
        cell.childContentView.hidden = false
        //let twtView = TWTRTweetView(tweet: tweet, style: .Compact)
        let twtView = twtviews[indexPath.row]
        twtView.frame = cell.childContentView.bounds
        cell.childContentView.addSubview(twtView)
        cell.identifier = tweet.tweetID
        cell.delegate = self
        //cell.tweetView.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return twtviews[indexPath.row].bounds.height
        //return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
    
    var previous = "0"
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !tableView.visibleCells().isEmpty {
            let first = tableView.visibleCells().first as? UITableViewCell
            if first!.textLabel?.text != previous {
                //previous = first.textLabel!.text!
                //println(previous)
            }
        }
    }
}

//MARK:- Extensions: SwipeCellDelegate
extension FeedViewController: SwipeCellDelegate {
    func removeCellWithID(identifier: String) {
        if let found = find(tweets.map({ $0.tweetID }), identifier) {
            tweets.removeAtIndex(found)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: found, inSection: 0)], withRowAnimation: .Top)
        } else {
            println("tweet not found!!! weird")
        }
    }
}

