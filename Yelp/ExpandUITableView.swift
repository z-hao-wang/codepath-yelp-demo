//
//  expandUITableView.swift
//  Yelp
//
//  Created by Hao Wang on 2/13/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandUITableView: UITableView {

    var expanded = false
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.separatorStyle = .None
        self.rowHeight = 44
    }
}
