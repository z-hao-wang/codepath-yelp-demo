//
//  RadiusTableViewCell.swift
//  Yelp
//
//  Created by Hao Wang on 2/14/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class RadiusTableViewCell: UITableViewCell {

    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var caretImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
