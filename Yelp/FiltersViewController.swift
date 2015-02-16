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
var sortBy = 0 // 0 = Best Match, 1 = Distance, 2 = Highest Rated
var radiusFilter = 0 // 0 = auto, 1 = 0.3 miles, 2 = 1 mile, 3 = 5 miles, 4 = 20 miles
var categoryName = "All"
var categoryCode = ""

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, filterDelegate {
    //Bool table view
    @IBOutlet weak var boolTableView: UITableView!
    
    @IBOutlet weak var radiusTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var radiusTableView: ExpandUITableView!
    //Sort tableview Expandable
    @IBOutlet weak var sortTableView: ExpandUITableView!
    @IBOutlet weak var categoriesPicker: UIPickerView!
    @IBOutlet weak var categoryButton: UIButton!
    
    let sortByLabels = ["Best Match", "Distance", "Highest Rated"]
    let radiusLabels = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    
    let labelTexts = ["Offering a Deal"]
    
    let categories = Categories()
    var categoriesData: [Dictionary<String, String>] = []
    var categoriesPickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove table view seperator
        boolTableView.separatorStyle = .None
        self.categoriesPicker.dataSource = self;
        self.categoriesPicker.delegate = self;
        categoriesData = categories.getData()
    }
    @IBAction func categoryButtonDidClick(sender: AnyObject) {
        categoriesPickerHidden = !categoriesPickerHidden
        categoriesPicker.hidden = categoriesPickerHidden
    }
    // Data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesData.count + 1
    }
    
    func getCategoryNameFromRow(row: Int) -> String {
        if row == 0 {
            return "All"
        } else {
            return categoriesData[row + 1]["name"]!
        }
    }
    
    func setCategoryButtonTitle() {
        categoryButton.setTitle(categoryName, forState: UIControlState.Normal)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return getCategoryNameFromRow(row)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoriesPickerHidden = true
        categoriesPicker.hidden = categoriesPickerHidden
        categoryName = getCategoryNameFromRow(row)
        categoryCode = categories.codeFromName(categoryName)
        setCategoryButtonTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        categoriesPicker.hidden = true
        setCategoryButtonTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.boolTableView {
            return labelTexts.count
        } else if tableView == sortTableView {
            return sortTableView.expanded ? 3 : 1
        } else if tableView == radiusTableView {
            return radiusTableView.expanded ? 5 : 1
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
            
            if sortTableView.expanded {
                cell.sortByLabel.text = sortByLabels[indexPath.row]
            } else {
                cell.sortByLabel.text = sortByLabels[sortBy]
            }
            cell.caretImage.hidden = sortTableView.expanded
            return cell
        } else if tableView == radiusTableView {
            var cell = radiusTableView.dequeueReusableCellWithIdentifier("radiusCell") as RadiusTableViewCell
            if radiusTableView.expanded {
                cell.radiusLabel.text = radiusLabels[indexPath.row]
            } else {
                cell.radiusLabel.text = radiusLabels[radiusFilter]
            }
            cell.caretImage.hidden = radiusTableView.expanded
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
            self.sortTableHeightConstraint.constant = self.sortTableView.contentSize.height
            self.view.layoutIfNeeded()
        } else if tableView == radiusTableView {
            if radiusTableView.expanded {
                //apply new sort method
                radiusFilter = indexPath.row
            }
            radiusTableView.expanded = !radiusTableView.expanded
            radiusTableView.reloadData()
            self.radiusTableHeightConstraint.constant = self.radiusTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func setFilterValue(name: String, value: Bool) {
        filterOptions[name] = value
    }
    
    func onBoolValueChange(value: Bool, labelText: String) {
        println("value \(value) \(labelText)")
        setFilterValue(labelText, value: value)
    }
}
