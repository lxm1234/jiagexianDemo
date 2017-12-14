//
//  KeyViewViewController.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/6.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

protocol KeyViewControllerDelegate {
    func closeKeyView(selectKey:String)
}

class KeyViewViewController: UITableViewController {

    var keyTypeList : [AnyObject]!
    var keyDict : [String : AnyObject] = [:]
    var delegate:KeyViewControllerDelegate?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.keyTypeList = Array.init(self.keyDict.keys) as [AnyObject]
        let backgroundView = UIImageView.init(image:
            UIImage.init(named:"BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red:48.0/255,green:89.0/255,blue:181.0/255,alpha:1.0)
        navigationBar?.tintColor = UIColor(red:112.0/255,green:180.0/255,blue:255.0/255,alpha:1.0)
        let navbarTitleTextAttributes = [kCTForegroundColorAttributeName:UIColor.white]
        navigationBar?.titleTextAttributes = navbarTitleTextAttributes as [NSAttributedStringKey : Any]
        
        UITableViewHeaderFooterView.appearance().tintColor
            = UIColor(red:112.0/255,green:180.0/255,blue:255.0/255,alpha:1.0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.keyTypeList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let keyName = self.keyTypeList[section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        return keyList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! NSArray
        let valueArray = keyList.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = valueArray.value(forKey: "key") as? String
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keyName = self.keyTypeList[section] as! String
        return keyName
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        let dict = keyList[indexPath.row] as! [String:String]
        self.delegate?.closeKeyView(selectKey: dict["key"]!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(self.keyDict.keys)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
