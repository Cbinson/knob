//
//  InfoCell.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    let kPowerOnCommend = " powerOn"
    let kPowerOffCommend = " powerOff"
    let kDelayTime = 2.0



    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var onoffSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!

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


        var commendStr = ""

        if sender.isOn {
            commendStr = self.kPowerOnCommend
        }else{
            commendStr = self.kPowerOffCommend
        }
        self.parentVCtrl?.sendData(commendStr)

        self.parentVCtrl?.isPownOn = sender.isOn

        self.parentVCtrl?.mainTableView.reloadData()
    }


    @IBAction func clickConnectBtn(_ sender: UIButton) {
        if (self.parentVCtrl?.isConnect)! {

            self.connectBtn.setTitle("Connect", for: .normal)

            if self.onoffSwitch.isOn {
                self.onoffSwitch.setOn(false, animated: true)

                self.parentVCtrl?.sendData(self.kPowerOffCommend)
            }

            self.onoffSwitch.isEnabled = false

            //延遲2秒在做藍芽斷線
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kDelayTime, execute: { 
                self.parentVCtrl?.disConnectBle()
            })


        }else{
            self.connectBtn.setTitle("Disconnect", for: .normal)
            self.parentVCtrl?.startManagerBle()

            self.onoffSwitch.isEnabled = true
        }

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
