//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "pJ_jBXz1p2EMjnwZIeAmXA"
    let yelpConsumerSecret = "mfiIYQ6KSKcrhhiQfT9lsQS1TXQ"
    let yelpToken = "AYC_4RWA2pdnp01F0vWekL18SSR2RaI9"
    let yelpTokenSecret = "SUam3twaVp35TEuT8x6aW05aGzc"
    
    var businesses = NSArray()
    var region = NSDictionary()
    var total = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //init yelp client
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }
    
    func searchTerm(term: String, location: String) {
        client.searchWithTerm(term, location: location, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            if let responseWrapped = response as? NSDictionary {
                self.businesses = responseWrapped["businesses"] as NSArray
                self.region = responseWrapped["region"] as NSDictionary
                self.total = responseWrapped["total"] as Int
            }
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("view Did load")
        searchTerm("Restaurant", location: "San Francisco")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Search \(searchBar.text)");
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("itemTableCell") as ItemTableViewCell
        if let name = businesses[indexPath.row]["name"] as? String {
            cell.businessTitle.text = name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
}

