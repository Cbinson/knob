//
//  TableViewController.swift
//  knob
//
//  Created by binsonchang on 2017/6/15.
//  Copyright © 2017年 tw.com.binson. All rights reserved.
//

import UIKit
import CoreBluetooth

class TableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    let kCFUID = "FFE0"
    let kUUID = "DBFC83AF-D534-459D-B040-D189A80E1BF7"
    let kName = "BLE"

    
    @IBOutlet var mainTableView: UITableView!

    var isConnect:Bool?
    var isPownOn:Bool?


    var currentPeripheral:CBPeripheral?
    var manager:CBCentralManager?
    var mainCharacteristic:CBCharacteristic? = nil

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.mainTableView.estimatedRowHeight = 231
        self.mainTableView.rowHeight = UITableViewAutomaticDimension

        self.isConnect = false
        self.isPownOn = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK - method
    func startManagerBle() {
        self.manager = CBCentralManager.init(delegate: self, queue: nil)
    }

    func disConnectBle() {
        self.isConnect = false
        self.isPownOn = false
        
        self.manager?.cancelPeripheralConnection(self.currentPeripheral!)

        self.manager = nil
        self.currentPeripheral = nil
        self.mainCharacteristic = nil

        self.mainTableView.reloadData()
    }

    func sendData(_ sendData:String) {
        let data = sendData.data(using: .utf8)
        self.currentPeripheral?.writeValue(data!, for: self.mainCharacteristic!, type: CBCharacteristicWriteType.withResponse)
    }

    
    // MARK: - cbcentermanager delegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        
        switch central.state {
        case .poweredOn:
            msg = "Bluetooth is powered on"
            
            if self.currentPeripheral != nil {
                self.currentPeripheral = nil
            }
            
            //藍芽on,才進行偵測
            let uuidArry = [CBUUID.init(string: kCFUID)]
            
            self.manager?.scanForPeripherals(withServices: uuidArry, options: nil)
            
            
            break;
        case .poweredOff:
            msg = "Bluetooth is power off"
            break;
        case .unauthorized:
            msg = "Application not use BLE role"
            break;
        case .unsupported:
            msg = "Not support BLE role"
            break;
        case .resetting:
            msg = "Connection with the system service was momentarily lost, update imminent"
            break;
        case .unknown:
            msg = "state unknown, update imminent"
            break;
        }
        
        print("[manager] state:\(msg)")
    }
    
    //如果有發現可連線的BLE週邊，它就會不斷的執行didDiscoverPeripheral，並將資訊傳入
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
        print("find device")
        
        if peripheral.name == kName {

            self.printInfo(peripheral)

            let connectState = self.checkIsConnected(peripheral)
            if connectState {
                self.manager?.stopScan()
            }else{
                if self.currentPeripheral == nil {
                    self.manager?.connect(peripheral, options: nil)
                    self.currentPeripheral = peripheral
                }
            }

        }
    }
    
    func printInfo(_ peripheral:CBPeripheral)  {
        print("name:\(peripheral.name!)")
        print("uuid:\(peripheral.identifier.uuidString)")
        
        var connectState = ""

        if self.checkIsConnected(peripheral) {
            connectState = "connected"
        }else{
            connectState = "disconnected"
        }
        print("connect_state:\(connectState)")


    }

    func checkIsConnected(_ peripheral:CBPeripheral) -> Bool {
        var connectState:Bool!
        if peripheral.state == .disconnected || peripheral.state == .disconnecting {
            connectState = false
        }else{
            connectState = true
        }

        return connectState
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("[connect] name:\(peripheral.name!)")
        print("[connect] uuid:\(peripheral.identifier.uuidString)")


        if peripheral.identifier.uuidString == "" {
            return
        }

        if peripheral.name == kName {
            self.currentPeripheral = peripheral
            self.isConnect = true
            
            peripheral.delegate = self
            peripheral.discoverServices(nil)
            
            self.mainTableView.reloadData()
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        for services in peripheral.services! {
//            print("service:\(services as CBService)")
            peripheral.discoverCharacteristics(nil, for: services)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for character in service.characteristics! {
//            print("charscter:\(character.uuid.uuidString)")
            peripheral.discoverDescriptors(for: character)
            
            if character.uuid.uuidString == "FFE1" {
                self.mainCharacteristic = character
                self.yf_Per(peripheral: peripheral, setNotifyValueForCharacteristic: character)
            }
            
            // 7.5 外设读取特征的值
            guard character.properties.contains(.read) else
            {
                print("character.properties must contains read")
                // 如果是只读的特征,那就跳过本条进行下一个遍历
                continue
            }
            print("note guard")
            // peripheral:didUpdateValueForCharacteristic:error:
            peripheral.readValue(for: character)
        }
    }
    
    // 7.6 外设发现了特征中的描述
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        //
        guard error == nil else
        {
            print("didDiscoverDescriptorsForCharacteristic : \(error)")
            return
        }
        
        for des in characteristic.descriptors! {
            print("characteristic: \(characteristic) .des  :\(des)")
            // peripheral:didUpdateValueForDescriptor:error: method
            peripheral.readValue(for: des)
        }
    }
    
    // 7.7 更新特征value
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        guard error == nil else
        {
            print("didUpdateValueForCharacteristic : \(error)")
            return
        }
        
        print("\(characteristic.description) didUpdateValueForCharacteristic")
    }
    
    func yfPer(peripheral: CBPeripheral, writeData data: NSData, forCharacteristic characteristic: CBCharacteristic) -> () {
        //外设写输入进特征
        guard characteristic.properties.contains(.write) else
        {
            print("characteristic.properties must contains Write")
            return
        }
        // 会触发peripheral:didWriteValueForCharacteristic:error:
        peripheral.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
        
    }
    
    // 订阅与取消订阅
    func yf_Per(peripheral: CBPeripheral, setNotifyValueForCharacteristic characteristic: CBCharacteristic) -> () {
        guard characteristic.properties.contains(.notify) else
        {
            print("characteristic.properties must contains notify")
            return
        }
        // peripheral:didUpdateNotificationStateForCharacteristic:error:
        peripheral.setNotifyValue(true, for: characteristic)
    }
    func yf_Per(peripheral: CBPeripheral, canleNotifyValueForCharacteristic characteristic: CBCharacteristic) -> () {
        guard characteristic.properties.contains(.notify) else
        {
            print("characteristic.properties must contains notify")
            return
        }
        peripheral.setNotifyValue(false, for: characteristic)
    }

    
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        var sectionNum:Int = 0

        if self.isConnect! && self.isPownOn! {
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
            if self.isConnect! && self.isPownOn! {
                rows = 1
            }else{
                rows = 0
            }
            break;
        case 2:
            if self.isConnect! && self.isPownOn! {
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

        if self.isConnect! && self.isPownOn! {
            if section != 0 {
                height = 24.0
            }
        }

        return height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var headerView = UIView()

        if self.isConnect! && self.isPownOn! {
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
            
            if self.currentPeripheral != nil {
                infoCell.nameLabel.text = self.currentPeripheral?.name
                infoCell.uuidLabel.text = self.currentPeripheral?.identifier.uuidString
                infoCell.onoffSwitch.isEnabled = true
            }else{
                infoCell.nameLabel.text = "連接藍芽失敗"
                infoCell.uuidLabel.text = "連接藍芽失敗"
                infoCell.onoffSwitch.isEnabled = false
            }
            
            cell = infoCell
            
            break;
        case 1:
            let timerCell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell

            timerCell.parentVCtrl = self

            timerCell.segmentBtn.selectedSegmentIndex = 0
            
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
