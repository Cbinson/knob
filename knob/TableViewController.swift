//
//  TableViewController.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var mainTableView: UITableView!
    
    var isConnect:Bool?

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.mainTableView.estimatedRowHeight = 231
        self.mainTableView.rowHeight = UITableViewAutomaticDimension

        self.isConnect = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        var sectionNum:Int = 0

        if self.isConnect! {
            sectionNum = 3  //info, knob, tem
        }else{
            sectionNum = 1  //info
        }

        return  sectionNum
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows:Int = 0;

        switch section {
        case 0:
            rows = 1
            break;
        case 1:
            if self.isConnect! {
                rows = 1
            }else{
                rows = 0
            }
            break;
        case 2:
            if self.isConnect! {
                rows = 1
            }else{
                rows = 0
            }
            break;
        default:
            rows = 0;
        }


        return rows
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0

        if self.isConnect! {
            if section != 0 {
                height = 24.0
            }
        }

        return height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var headerView = UIView()

        if self.isConnect! {
            if section != 0 {
                //view
                headerView = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.tableView.frame.size.width, height: 24.0)))
                headerView.backgroundColor = UIColor.gray

                //label
                var headerFrame = headerView.frame
                headerFrame.origin.x += 10

                let titleLabel = UILabel.init(frame: headerFrame)
                titleLabel.font = UIFont.italicSystemFont(ofSize: 18.0)

                if section == 1 {
                    titleLabel.text = "定時"
                }else if section == 2 {
                    titleLabel.text = "溫度"
                }
                headerView.addSubview(titleLabel)
                
            }
        }


        return headerView
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var cell = UITableViewCell()

        // Configure the cell...
        switch indexPath.section {
        case 0:
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell

            infoCell.parentVCtrl = self
            
            cell = infoCell
            
            break;
        case 1:
            let timerCell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell

            cell = timerCell

            break;
        case 2:
            let temperatureCell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath) as! TemperatureCell

            cell = temperatureCell
            break;
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select:\(indexPath.section), \(indexPath.row) row")

        if indexPath.section == 0  {

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
