//
//  FilterBoolTableViewCell.swift
//  Yelp
//
//  Created by Hao Wang on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol filterDelegate {
    func onBoolValueChange(value: Bool, labelText: String)
}

class FilterBoolTableViewCell: UITableViewCell {
    
    var delegate:filterDelegate?

    @IBOutlet weak var filterValue: UISwitch!
    @IBOutlet weak var filterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didSwitchValueChange(sender: UISwitch) {
        delegate?.onBoolValueChange(self.filterValue.on, labelText: filterName.text!)
    }

}
