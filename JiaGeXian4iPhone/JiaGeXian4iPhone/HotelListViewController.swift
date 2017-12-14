//
//  HotelListViewController.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/7.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

class HotelListViewController: UITableViewController {
    var currentPage = 1
    var queryKey : [String:AnyObject]!
    var hotelList = [AnyObject]()
    
    @IBOutlet weak var loadCiewCell: UIView!
    var queryRoomKey:[String:AnyObject]!
    var roomList : [AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "酒店列表"
        let backgroundView = UIImageView(image:UIImage.init(named: "BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        if hotelList.count < 20 {
            loadCiewCell.isHidden = true
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedQueryRoom), name:NSNotification.Name(rawValue: BLQueryRoomFinishedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedQueryRoom), name:NSNotification.Name(rawValue: BLQueryRoomFailedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedQueryHotel), name:NSNotification.Name(rawValue: BLQueryHotelFinishedNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedQueryHotel), name:NSNotification.Name(rawValue: BLQueryHotelFailedNotification) , object: nil)
    }
    @objc func finishedQueryRoom(not:Notification) {
        self.roomList = not.object as! [AnyObject]
        if self.roomList.count == 0{
            print("没有房间数据")
        } else {
            self.performSegue(withIdentifier: "showRoomDetail", sender: nil)
        }
    }
    @objc func failedQueryRoom(not:Notification) {
        
    }
    @objc func finishedQueryHotel(not:Notification) {
        let resList = not.object as! [AnyObject]
        if resList.count < 20{
            self.loadCiewCell.isHidden = true
        } else {
            self.loadCiewCell.isHidden = false
        }
        if currentPage == 1{
            self.hotelList = [AnyObject]()
        }
        self.hotelList+=resList
        self.tableView.reloadData()
    }
    @objc func failedQueryHotel(not:Notification) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.hotelList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotelTableViewCell
        let dict = self.hotelList[indexPath.row] as! [String:String]
        cell.lblName.text = dict["name"]
        cell.lblAddress.text = dict["address"]
        cell.lblPrice.text = dict["lowprice"]
        cell.lblGrade.text = dict["grade"]
        cell.lblPhone.text = dict["phone"]
        let htmlPath = Bundle.main.path(forResource: "myIndex", ofType: "html")
        let bundleUrl = NSURL.init(fileURLWithPath: Bundle.main.bundlePath)
        var html = try? NSMutableString.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
        let subRange = html?.range(of: "####")
        if subRange?.location != NSNotFound {
            html?.replaceCharacters(in: subRange!, with: dict["img"]!)
        }
        cell.webview.loadHTMLString(html as String!, baseURL: bundleUrl as URL)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showRoomDetail" {
            var qkey = [String:AnyObject]()
            qkey["Checkin"] = self.queryKey["Checkin"]
            qkey["Checkout"] = self.queryKey["Checkout"]
            let indexPath = self.tableView.indexPathForSelectedRow
            let dict:AnyObject = self.hotelList[(indexPath?.row)!]
            qkey["hotelId"] = dict["id"] as AnyObject
            self.queryKey = qkey
            RoomBL.shared().queryRoom(keyInfo: self.queryKey)
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoomDetail" {
            let roomListViewController = segue.destination as! RoomListViewController
            roomListViewController.list = self.roomList
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.hotelList.count == indexPath.row + 1 && self.loadCiewCell.isHidden == false {
            NSLog("load data...")
            currentPage+=1
            let curStr = String(format:"%i",currentPage)
            self.queryKey["currentPage"]=curStr as AnyObject
            HotelBL.shared().queryHotel(keyInfo: self.queryKey)
        }
    }

}
