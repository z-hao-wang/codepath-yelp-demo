//
//  itemTableViewCell.swift
//  Yelp
//
//  Created by Hao Wang on 2/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var businessTitle: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBOutlet weak var ratingCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
