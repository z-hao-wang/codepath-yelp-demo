//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Hao Wang on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

//These are filters needs to be stored globally
var filterOptions = Dictionary<String, Bool>()
var price = 1  //1,2,3,4
var distance = 1.0
var sortBy = 1

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, filterDelegate {
    @IBOutlet weak var prices: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    let labelTexts = ["Open Now", "Hot & New", "Offering a Deal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prices.selectedSegmentIndex = price
    }

    @IBAction func didChangePrice(sender: UISegmentedControl) {
        price = sender.selectedSegmentIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterBoolCell") as FilterBoolTableViewCell
        
        var labelText = labelTexts[indexPath.row]
        
        cell.filterValue.on = false
        if let optionOn = filterOptions[labelText] {
            cell.filterValue.on = true
        }
        cell.filterName.text = labelText
        cell.delegate = self
        return cell
    }
    
    func setFilterValue(name: String, value: Bool) {
        filterOptions[name] = value
    }
    
    func onBoolValueChange(value: Bool, labelText: String) {
        println("value \(value) \(labelText)")
        setFilterValue(labelText, value: value)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
