//
//  RoomTableViewCell.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/7.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBreakfast: UILabel!
    @IBOutlet weak var lblBroadband: UILabel!
    @IBOutlet weak var lblFrontprice: UILabel!
    @IBOutlet weak var lblPaymode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
