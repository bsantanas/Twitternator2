//
//  FeedViewController.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/7/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit
import TwitterKit

class FeedViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    var textToSearch:String?
    var tweets = [TWTRTweet]()
    var twtviews = [TWTRTweetView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(SwipeableCell.self, forCellReuseIdentifier: "TweetCell")
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
        // Configure cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! SwipeableCell
        let tweet = tweets[indexPath.row]
        cell.configureWithTweet(tweet)
        cell.identifier = tweet.tweetID
        
        // Add gesture recognizer
        if cell.gestureRecognizers == nil { // TweetViews come with 1 gesture recognizer
            let pan = UIPanGestureRecognizer(target: self, action: "panTweetView:")
            pan.delegate = self
            cell.addGestureRecognizer(pan)
            cell.tweetView.userInteractionEnabled = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        //return twtviews[indexPath.row].bounds.height
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
        
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
    
    
    //MARK:- UIGestureRecognizer methods
    
    var initialFrame:CGRect?
    var startingRightLayoutConstraintConstant: CGFloat?
    var panStartPoint:CGPoint?
    var viewStartPoint:CGPoint?
    
    func panTweetView(pan:UIPanGestureRecognizer) {
        let cell = pan.view as! SwipeableCell
        
        switch pan.state {
            
        case .Began:
            //contentView.layer.removeAllAnimations()
            panStartPoint = pan.locationInView(cell.contentView)
            viewStartPoint = cell.tweetView.center
            initialFrame = cell.tweetView.frame
            
        case .Changed:
            let deltaX = pan.locationInView(cell.contentView).x - panStartPoint!.x
            let y = cell.tweetView.bounds.midY
            cell.tweetView.center = CGPoint(x: viewStartPoint!.x + deltaX, y: y)
            
        case .Ended:
            let invOffset = cell.tweetView.frame.width - cell.tweetView.frame.origin.x
            var center = cell.contentView.center
            var remove = false
            var duration:NSTimeInterval = 1
            
            if invOffset < 100 { // pulled to the right
                center.x = cell.contentView.frame.width * 2 // remove from screen
                remove = true
                duration = 0.4
            }
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
                
                cell.tweetView.center = center
                
                if remove {
                    self.removeCellWithID(cell.identifier!)
                }
                
                }, completion: { value in
                    
                    if remove {
                        //cell.tweetView.hidden = true
                        cell.tweetView.frame = self.initialFrame!
                    }
            })
            
        default:
            // Cancelled
            println("Gesture recognizer was cancelled")
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func removeCellWithID(identifier: String) {
        
        if let found = find(tweets.map({ $0.tweetID }), identifier) {
            tweets.removeAtIndex(found)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: found, inSection: 0)], withRowAnimation: .Top)
        } else {
            println("tweet not found!!! weird")
        }
    }
    
}

