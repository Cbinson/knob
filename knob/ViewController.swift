//
//  ViewController.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var knob: UIImageView!

    var nowAngle:CGFloat = 0

    @IBOutlet weak var stateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    func distanceBetweenPoints(_ point1:CGPoint, _ point2:CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y

        return sqrt((dx*dx)+(dy*dy))
    }

    func angleBetweenLines(_ lineABegin:CGPoint, _ lineAEnd:CGPoint, _ linBBegin:CGPoint, _ lineBEnd:CGPoint) -> CGFloat {
        let a = lineAEnd.x - lineABegin.x
        let b = lineAEnd.y - lineABegin.y
        let atanA = atan2(a, b)

        let c = lineBEnd.x - linBBegin.x
        let d = lineBEnd.y - linBBegin.y
        let atanB = atan2(c, d)

        return (atanA - atanB) * 180 / .pi

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nowPoint = touches.first?.location(in: self.view)
        let previousPoints = touches.first?.previousLocation(in: self.view)
        let midPoint = self.knob.center
        let distance = distanceBetweenPoints(midPoint, nowPoint!)

        if distance < self.knob.bounds.size.width/2 {
            let angle = self.angleBetweenLines(midPoint, previousPoints!, midPoint, nowPoint!)
            self.nowAngle += angle
            self.knob.transform = CGAffineTransform.init(rotationAngle: self.nowAngle * .pi / 180)

            switch self.nowAngle {
            case 0..<90:
                self.stateLabel.text = "1"
                break;
            case 90..<180:
                self.stateLabel.text = "2"
                break;
            case 180..<270:
                self.stateLabel.text = "4"
                break;
            case 270..<360:
                self.stateLabel.text = "8"
                break;
            default:
                self.stateLabel.text = "0"
            }
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

