//
//  TimerCell.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {


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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func clickTimerSegment(_ sender: UISegmentedControl) {
        print("[timer] select_value:\(sender.selectedSegmentIndex)")
        let timerValueArry = Array.init(arrayLiteral: "0", "1", "2", "4")

    }
}
