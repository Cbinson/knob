//
//  InfoCell.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var onoffSwitch: UISwitch!

    var parentVCtrl:TableViewController?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    //switch On/Off
    @IBAction func switchOnOff(_ sender: UISwitch) {
//        print("switch_value:\(sender.isOn)")
        self.parentVCtrl?.isConnect = sender.isOn
        self.parentVCtrl?.mainTableView.reloadData()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
