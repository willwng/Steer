//
//  HomeTableViewCell.swift
//  Steer
//
//  Created by Mac Sierra on 12/24/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var taskLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
