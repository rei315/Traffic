//
//  UserMapListCellTableViewCell.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 2..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit

class UserMapListCell: UITableViewCell {

   
    @IBOutlet weak var Myimage: UIImageView!
    @IBOutlet weak var MyRestaurant: UILabel!
    @IBOutlet weak var Mylocation: UILabel!
    @IBOutlet weak var resdistance: UILabel!
    @IBOutlet weak var reslike: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
