//
//  MyPickerViewController.swift
//  PopupControl
//
//  Created by lxm on 2017/11/30.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit

public protocol MyPickerViewControllerDelegat{
    func myPickViewClose(selected:String)
}

public class MyPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row] as! String
    }
    
    var pickerData:NSArray!
    public var delegate:MyPickerViewControllerDelegat?
    
    @IBOutlet weak var picker: UIPickerView!
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(){
        let resourcesBundle = Bundle.init(for: MyPickerViewController.self)
        super.init(nibName: "MyPickerViewController", bundle: resourcesBundle)
        self.pickerData = ["价格不限","¥0-->¥1000元/天","¥1000-->¥2000元/天","¥2000-->¥3000元/天","¥3000-->¥5000元/天"]
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.hideInView()
    }
    @IBAction func done(_ sender: UIButton) {
        self.hideInView()
        let selectedIndex = self.picker.selectedRow(inComponent: 0)
        self.delegate?.myPickViewClose(selected: self.pickerData[selectedIndex] as! String)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
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
