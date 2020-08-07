//
//  InvertedTableViewCell.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import UIKit
import Kingfisher

class InvertedTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        self.imgAvatar.makeRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
