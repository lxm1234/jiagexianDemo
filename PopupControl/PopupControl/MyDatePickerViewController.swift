//
//  MyDatePickerViewController.swift
//  PopupControl
//
//  Created by lxm on 2017/11/30.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

public protocol MyDatePickerViewControllerDelegate{
    func myPickDateViewControllerDidFinish(controller:MyDatePickerViewController,andSelectedDate selected:NSDate)
}

public class MyDatePickerViewController: UIViewController {

    public var delegate:MyDatePickerViewControllerDelegate?
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(){
        let resourceBundle = Bundle.init(for: MyDatePickerViewController.self)
        super.init(nibName: "MyDatePickerViewController", bundle: resourceBundle)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.hideInView()
    }
    @IBAction func done(_ sender: UIButton) {
        self.hideInView()
        self.delegate?.myPickDateViewControllerDidFinish(controller: self, andSelectedDate: self.datePickerView.date as NSDate)
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func shwoInView(superview:UIView){
        
        if self.view.superview == nil {
            superview.addSubview(self.view)
        }
        self.view.center = CGPoint.init(x: self.view.center.x, y: 900)
        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: superview.frame.size.width, height: self.view.frame.size.height)
        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.center = CGPoint.init(x: superview.center.x, y: superview.frame.size.height - self.view.frame.size.height/2)
        }, completion: nil)
    }
    public func hideInView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.center = CGPoint.init(x:self.view.center.x,y:900)
        }, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
