//
//  CitiesTableViewController.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/6.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit
protocol CitiesViewControllerDelegate {
    func closeCitiesView(info:[String:String])
}

class CitiesTableViewController: UITableViewController {
    
    var cities:[AnyObject]!
    var delegate:CitiesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cityPlistPath = Bundle.main.path(forResource: "cities", ofType: "plist")
        let bySpell = NSSortDescriptor.init(key: "spell", ascending: true)
        self.cities = NSArray.init(contentsOfFile: cityPlistPath!)?.sortedArray(using: [bySpell]) as! [AnyObject]
        let backgroundView = UIImageView.init(image:
            UIImage.init(named:"BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red:48.0/255,green:89.0/255,blue:181.0/255,alpha:1.0)
        navigationBar?.tintColor = UIColor(red:112.0/255,green:180.0/255,blue:255.0/255,alpha:1.0)
        let navbarTitleTextAttributes = [kCTForegroundColorAttributeName:UIColor.white]
        navigationBar?.titleTextAttributes = navbarTitleTextAttributes as [NSAttributedStringKey : Any]
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        let dict = self.cities[indexPath.row] as! [String:String]
        cell.textLabel?.text = dict["name"]
        cell.detailTextLabel?.text = dict["spell"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.cities[indexPath.row] as! [String:String]
        self.delegate?.closeCitiesView(info: dict)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
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
