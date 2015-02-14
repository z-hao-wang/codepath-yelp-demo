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
var sortBy = 1

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, filterDelegate {
    @IBOutlet weak var tableView: UITableView!
    let labelTexts = ["Offering a Deal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove table view seperator
        tableView.separatorStyle = .None;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelTexts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FilterBoolCell") as FilterBoolTableViewCell
        
        var labelText = labelTexts[indexPath.row]
        
        cell.filterValue.on = false
        if let optionOn = filterOptions[labelText] {
            cell.filterValue.on = optionOn
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
