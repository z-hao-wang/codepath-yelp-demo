//
//  SortTableViewCell.swift
//  Yelp
//
//  Created by Hao Wang on 2/13/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caretImage: UIImageView!
    @IBOutlet weak var sortByLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
