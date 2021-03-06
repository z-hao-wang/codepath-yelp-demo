//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var locationManager:CLLocationManager
    
    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "pJ_jBXz1p2EMjnwZIeAmXA"
    let yelpConsumerSecret = "mfiIYQ6KSKcrhhiQfT9lsQS1TXQ"
    let yelpToken = "AYC_4RWA2pdnp01F0vWekL18SSR2RaI9"
    let yelpTokenSecret = "SUam3twaVp35TEuT8x6aW05aGzc"
    
    var businesses = NSArray()
    var region = NSDictionary()
    var total = 0
    var currentSearchTerm = "Restaurant"
    var dealFilterOn = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    required init(coder aDecoder: NSCoder) {
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
        
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        locationManager.startUpdatingLocation()

        // init yelp client
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }
    
    func radiusFilterToMeters(radiusNumber: Int) -> Int{
        switch radiusNumber {
        case 0:
            return 0
        case 1:
            return 483 // 0.3 miles
        case 2:
            return 1609 // 1 mile
        case 3:
            return 8047 //5 miles
        case 4:
            return 32187 // 20 miles
        default:
            return 0
        }
    }
    
    func searchTerm(term: String, location: String) {
        var category = categoryCode
        client.searchWithTerm(term, sort: sortBy, category_filter: category, deals_filter: self.dealFilterOn, radius_filter: radiusFilterToMeters(radiusFilter), location: location, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            if let responseWrapped = response as? NSDictionary {
                self.businesses = responseWrapped["businesses"] as NSArray
                self.region = responseWrapped["region"] as NSDictionary
                self.total = responseWrapped["total"] as Int
            }
            println(response)
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func applyFilters() {
        if let dealFromFilter = filterOptions["Offering a Deal"] {
            self.dealFilterOn = dealFromFilter
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //apply filter
        applyFilters()
        searchTerm(currentSearchTerm, location: "San Francisco")
    }
    
    func deviceLocation() {
        var lat = locationManager.location?.coordinate.latitude
        var lon = locationManager.location?.coordinate.longitude
        println("\(lat),\(lon)");
    }
    
    func updateTopBarSize() {
        if let navFrame = self.navigationController?.navigationBar.frame {
            topBarView.frame.size.height = navFrame.size.height
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            topBarView.frame.size.width = screenWidth
            println("\(screenWidth)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.bringSubviewToFront(topBarView)
        topBarView.frame.origin.y = 64
        //UITapGestureRecognizer.initialize()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.navigationItem.titleView = topBarView
        updateTopBarSize()
        searchBar.layer.borderWidth = 1
        var barColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [213.0/255.0, 42.0/255.0, 4.0/255.0, 1.0])
        searchBar.layer.backgroundColor = barColor
        searchBar.layer.borderColor = barColor
        //deviceLocation()
        searchTerm(currentSearchTerm, location: "San Francisco")
        //To disable inset gap, but not working
        tableView.contentInset = UIEdgeInsetsZero
        //Auto table row height
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateTopBarSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard () {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Search \(searchBar.text)");
        searchTerm(searchBar.text, location: "San Francisco")
    }
    
    func setCellData(cell: ItemTableViewCell, indexPath: NSIndexPath) {
        if let name = businesses[indexPath.row]["name"] as? String {
            cell.businessTitle.text = name
        }
        
        if let location = businesses[indexPath.row]["location"] as? NSDictionary {
            cell.address.text = ""
            if let addresses = location["address"] as? NSArray {
                if addresses.count > 0 {
                    if let address = addresses[0] as? NSString {
                        cell.address.text = address
                    }
                }
            }
            
        }
        
        if let categories = businesses[indexPath.row]["categories"] as? NSArray {
            var textParts = ""
            if categories.count > 0 {
                if let categories1 = categories[0] as? NSArray {
                    textParts += categories1[0] as String
                }
            }
            if categories.count > 1 {
                if let categories2 = categories[1] as? NSArray {
                    textParts += ", "
                    textParts += categories2[0] as String
                }
            }
            cell.category.text = textParts
        }
        
        if let image_url = businesses[indexPath.row]["image_url"] as? String {
            if let img = cell.photoView? {
                Utils.setImageWithUrl(image_url, imageView: img, placeHolerImg: nil, success: {(imageData: UIImage) -> () in }, fail: {})
            }
        }
        
        if let ratingImageUrl = businesses[indexPath.row]["rating_img_url"] as? String{
            if let img = cell.ratingImage? {
                Utils.setImageWithUrl(ratingImageUrl, imageView: img, placeHolerImg: nil, success: {(imageData: UIImage) -> () in }, fail: {})
            }
        }
        if let review_count = businesses[indexPath.row]["review_count"] as? Int{
            cell.ratingCount.text = String(review_count) + " Reviews"
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemTableCell") as ItemTableViewCell
        setCellData(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
}

