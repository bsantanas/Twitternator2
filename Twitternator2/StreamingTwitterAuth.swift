//
//  StreamingTwitterAuth.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/9/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import Foundation
//MARK: StreamingAPI
class StreamingAPI: NSObject {
    
    var swifter:Swifter?
    var authenticationRequired = false
    
    func authorizeStreaming() {
        if authenticationRequired {
            var oauthToken : String? = NSUserDefaults.standardUserDefaults().valueForKey("oauth_token") as? String
            var oauthTokenSecret : String?  = NSUserDefaults.standardUserDefaults().valueForKey("oauth_secret") as? String
            if oauthToken != nil && oauthTokenSecret != nil {
                self.swifter = Swifter(consumerKey: "lTDvE17axNaFEtl5lLzm11Pdj", consumerSecret: "AmRqfhJ7mz0anqIb3NkPuDHogIJcDMWVeH6qA1uagtHYyBTR6V", oauthToken: oauthToken!, oauthTokenSecret: oauthTokenSecret!)
                self.startStreamingWithFilters(["Saints"])
                
            } else { // Get oauth secret and token
                
                swifter = Swifter(consumerKey: "lTDvE17axNaFEtl5lLzm11Pdj", consumerSecret: "AmRqfhJ7mz0anqIb3NkPuDHogIJcDMWVeH6qA1uagtHYyBTR6V")
                
                let callbackURL = NSURL(string: "swifter://success")!
                
                swifter!.authorizeWithCallbackURL(callbackURL, success: {
                    (accessToken: SwifterCredential.OAuthAccessToken?, response: NSURLResponse) in
                    
                    //            println("Access Token key \(accessToken?.key)")
                    println("userId\(accessToken?.userID)")
                    //            println("userName\(accessToken?.screenName)")
                    println("Access Token secret\(accessToken?.secret)")
                    //Save the values that you need in NSUserDefaults
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(accessToken!.key, forKey: "oauth_token")
                    defaults.setObject(accessToken!.secret, forKey: "oauth_secret")
                    defaults.synchronize()
                    
                    self.swifter = Swifter(consumerKey: "lTDvE17axNaFEtl5lLzm11Pdj", consumerSecret: "AmRqfhJ7mz0anqIb3NkPuDHogIJcDMWVeH6qA1uagtHYyBTR6V", oauthToken: accessToken!.key, oauthTokenSecret: accessToken!.secret)
                    self.startStreamingWithFilters(["RCTV"])
                    },
                    failure: {
                        (error: NSError) in
                        
                        // Handle error: TODO
                        
                })
                
            }
            
        }
        
    }
    
    func startStreamingWithFilters(tracks:[String]) {
        swifter!.postStatusesFilterWithFollow(follow: nil, track: tracks, locations:["50.87, -1.47,50.95, -1.33"], delimited: false, stallWarnings: true, progress: {
            (status: Dictionary<String, JSONValue>?) in
            
            println(status)
            
            }, stallWarningHandler: {
                (code: String?, message: String?, percentFull: Int?) in
                
                print(percentFull)
                
            }, failure: { error in
                println(error)
        })
        
    }
}
