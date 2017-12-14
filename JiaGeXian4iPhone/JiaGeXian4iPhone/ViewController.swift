//
//  ViewController.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/6.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit
import PopupControl

class ViewController: UIViewController,MyPickerViewControllerDelegat,MyDatePickerViewControllerDelegate,CitiesViewControllerDelegate,KeyViewControllerDelegate{
    
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var keyBtn: UIButton!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var InBtn: UIButton!
    @IBOutlet weak var outBtn: UIButton!
    
    var cityName:String?
    var key:String?
    var price:String?
    var inDate:String?
    var outDate:String?
    var keyDict:[String:AnyObject]?
    var dateType = 0
    var cityInfo:[String:String]?
    var hotelList:[AnyObject]!
    var hotelQueryKey : [String:AnyObject]?
    func myPickDateViewControllerDidFinish(controller: MyDatePickerViewController, andSelectedDate selected: NSDate) {
        NSLog("selected %@", selected)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "zh_CN")
        let strData = formatter.string(from: selected as Date)
        if dateType == 0 {
            inDate = strData
            self.InBtn.setTitle(self.inDate, for: UIControlState.normal)
        } else {
            outDate = strData
            self.outBtn.setTitle(self.outDate, for: UIControlState.normal)
        }
    }
    
    func myPickViewClose(selected: String) {
        NSLog("selected %@", selected)
        self.price = selected
        self.priceBtn.setTitle(selected, for: UIControlState.normal)
    }
    func closeCitiesView(info: [String : String]) {
        cityInfo = info
        self.cityName = info["name"]
        self.cityBtn.setTitle(self.cityName, for: UIControlState.normal)
    }
    func closeKeyView(selectKey: String) {
        self.key = selectKey
        self.keyBtn.setTitle(self.key, for: UIControlState.normal)
    }
    

    var pickerViewController = MyPickerViewController()
    var datePickerViewConroller = MyDatePickerViewController();
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewController.delegate = self
        datePickerViewConroller.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(finishedQueryKey), name:NSNotification.Name(rawValue: BLQueryKeyFinishedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedQueryKey), name:NSNotification.Name(rawValue: BLQueryKeyFailedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedQueryHotel), name:NSNotification.Name(rawValue: BLQueryHotelFinishedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedQueryHotel), name:NSNotification.Name(rawValue: BLQueryHotelFailedNotification) , object: nil)
    }
    
    @objc func finishedQueryKey(notification:Notification) {
        NSLog("查询成功")
        keyDict = notification.object as! [String:AnyObject]
        performSegue(withIdentifier: "showKey", sender: nil)
        
    }
    @objc func failedQueryHotel(notification:Notification) {
        NSLog("查询失败")
    }
    @objc func finishedQueryHotel(notification:Notification) {
        NSLog("查询成功")
        hotelList = notification.object as! [AnyObject]
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        var vc = storyboard.instantiateViewController(withIdentifier: "hotelListController") as! HotelListViewController
        vc.hotelList = self.hotelList
        vc.queryKey = self.hotelQueryKey
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func failedQueryKey(notification:Notification) {
        NSLog("查询失败")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func choseKey(_ sender: Any) {
        if self.cityName == nil {
            return
        }
        HotelBL.shared().selectKey(city: cityName)
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showKey" {
            if self.cityName == nil {
                return false
            }
            HotelBL.shared().selectKey(city: cityName)
            return false
        }
        return true
    }
    
    @IBAction func chosePrice(_ sender: Any) {
        self.pickerViewController.shwoInView(superview: self.view)
    }
    @IBAction func choseIn(_ sender: Any) {
        dateType = 0
        self.datePickerViewConroller.shwoInView(superview: self.view)
    }
    @IBAction func choseOut(_ sender: Any) {
        dateType = 1
        self.datePickerViewConroller.shwoInView(superview: self.view)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "choseCity" {
            let vc = segue.destination as! UINavigationController
            let city_vc = vc.topViewController as! CitiesTableViewController
            city_vc.delegate = self
        } else if segue.identifier == "showKey" {
            let vc = segue.destination as! UINavigationController
            let key_vc = vc.topViewController as! KeyViewViewController
            key_vc.keyDict = self.keyDict!
            key_vc.delegate = self
        }
    }
 
    @IBAction func search(_ sender: Any) {
        var errMsg: String? = nil
        if self.cityName == nil {
            errMsg = "请选择城市"
        } else if self.key == nil{
            errMsg = "请选择关键字"
        } else if self.inDate == nil {
            errMsg = "请选择入住日期"
        } else if self.outDate == nil {
            errMsg = "请选择退房日期"
        }
        
        if errMsg != nil {
            let alert = UIAlertController(title: "提示信息", message: errMsg, preferredStyle: .alert)
            let alertButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertButton)
            self.present(alert, animated: true, completion: nil)
        }
        hotelQueryKey = [String:AnyObject]()
        hotelQueryKey!["Plcityid"] = self.cityInfo!["Plcityid"] as AnyObject
        hotelQueryKey!["currentPage"] = "1" as AnyObject
        hotelQueryKey!["key"] = self.key as AnyObject
        hotelQueryKey!["Price"] = self.price as AnyObject
        hotelQueryKey!["Checkin"] = self.inDate as AnyObject
        hotelQueryKey!["Checkout"] = self.outDate as AnyObject
        
        HotelBL.shared().queryHotel(keyInfo: hotelQueryKey!)
    }
    
}
