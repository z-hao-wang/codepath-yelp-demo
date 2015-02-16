//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, sort: Int = 0, category_filter: String, radius_filter: Int = 7000, deals_filter: Bool = false, location: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        if radius_filter > 0 {
            var params = ["term": term, "location": location, "sort": sort, "deals_filter": deals_filter, "radius_filter": radius_filter, "category_filter": category_filter]
            return self.GET("search", parameters: params, success: success, failure: failure)

        } else {
            var params = ["term": term, "location": location, "sort": sort, "deals_filter": deals_filter, "category_filter": category_filter]
            return self.GET("search", parameters: params, success: success, failure: failure)
        }
    }
}


