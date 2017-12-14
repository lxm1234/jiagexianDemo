//
//  HotelTableViewCell.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/7.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
