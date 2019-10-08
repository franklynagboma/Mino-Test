//
//  MusicTableViewCell.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 08/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var playCountButton: CustomButton!
    @IBOutlet weak var downloadedCountButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
