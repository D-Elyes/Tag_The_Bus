//
//  StationImageTableViewCell.swift
//  Tag_The_Bus
//
//  Created by Elyes DOUDECH on 15/04/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//

import UIKit

class StationImageTableViewCell: UITableViewCell {

    @IBOutlet weak var stationImage: UIImageView!
    
    @IBOutlet weak var imageTitleLabel: UILabel!
   
    @IBOutlet weak var imageDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    


}
