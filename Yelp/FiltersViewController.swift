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
var sortBy = 0 //0 = Best Match, 1 = Distance, 2 = Highest Rated

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, filterDelegate {
    //Bool table view
    @IBOutlet weak var boolTableView: UITableView!
    
    //Sort tableview Expandable
    @IBOutlet weak var sortTableView: ExpandUITableView!
    
    let labelTexts = ["Offering a Deal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove table view seperator
        boolTableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.boolTableView {
            return labelTexts.count
        } else if tableView == sortTableView {
            return sortTableView.expanded ? 3 : 1
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.boolTableView {
            var cell = boolTableView.dequeueReusableCellWithIdentifier("FilterBoolCell") as FilterBoolTableViewCell
            
            var labelText = labelTexts[indexPath.row]
            
            cell.filterValue.on = false
            if let optionOn = filterOptions[labelText] {
                cell.filterValue.on = optionOn
            }
            cell.filterName.text = labelText
            cell.delegate = self
            return cell
        } else if tableView == sortTableView {
            var cell = sortTableView.dequeueReusableCellWithIdentifier("sortCell") as SortTableViewCell
            let labels = ["Best Match", "Distance", "Highest Rated"]
            if sortTableView.expanded {
                cell.sortByLabel.text = labels[indexPath.row]
            } else {
                cell.sortByLabel.text = labels[sortBy]
            }
            return cell
        }
        // This does not matter
        return boolTableView.dequeueReusableCellWithIdentifier("FilterBoolCell") as FilterBoolTableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == sortTableView {
            if sortTableView.expanded {
                //apply new sort method
                sortBy = indexPath.row
            }
            sortTableView.expanded = !sortTableView.expanded
            sortTableView.reloadData()
            sortTableView.frame.size.height = sortTableView.rowHeight * (sortTableView.expanded ? 3 : 1)
        }
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
