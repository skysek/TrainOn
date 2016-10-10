//
//  CellContactTableViewCell.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 27/11/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import UIKit

class CellContactTableViewCell: UITableViewCell {

    @IBOutlet var entrepriseName: UILabel!
    @IBOutlet var contactName: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var button2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
