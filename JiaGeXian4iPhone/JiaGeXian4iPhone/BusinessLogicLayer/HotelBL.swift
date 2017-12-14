//
//  HotelBL.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/11/30.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit
import Alamofire

let BLQueryKeyFinishedNotification = "BLQueryKeyFinishedNotification"
let BLQueryKeyFailedNotification = "BLQueryKeyFailedNotification"

let BLQueryHotelFinishedNotification = "BLQueryHotelFinishedNotification"
let BLQueryHotelFailedNotification = "BLQueryHotelFailedNotification"


let HOST_NAME = "jiagexian.com"
let KEY_QUERY_URL = "http://jiagexian.com/ajaxplcheck.mobile?method=mobilesuggest&v=1&city=%@"
let HOTEL_QUERY_URL = "http://jiagexian.com/hotelListForMobile.mobile?newSearch=1"


class HotelBL: NSObject {
    static func shared()->HotelBL{
        struct singleton{
            static var single = HotelBL()
        }
        DispatchQueue.once("YouShaoduo") {
            singleton.single = shared()
        }
        return singleton.single
    }
    public func selectKey(city:String!){
        
        var strURL = String.init(format: KEY_QUERY_URL  as String, city)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var dict = NSDictionary()
        Alamofire.request(strURL).responseJSON {response in
            print("response: \(response)")
            if let json = response.result.value {
                do {
                    print("json: \(json)")
                    if JSONSerialization.isValidJSONObject(json) {
                        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
                        dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        print("dict: \(dict)")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryKeyFinishedNotification), object:dict)
                    }
                } catch {
                    NSLog("MKNetWork 请求错误")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryKeyFailedNotification), object:nil)
                }
            }
        }
    }
    public func queryHotel(keyInfo : [String:AnyObject]){
        var strURL = HOTEL_QUERY_URL
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var params = NSDictionary() as! Parameters
        params["f_plcityid"] = keyInfo["Plcityid"]
        params["currentPage"] = keyInfo["currentPage"]
        params["q"] = keyInfo["key"]
        
        let price:String = keyInfo["Price"] as! String
        
        if price == "价格不限" {
            params["priceSlider_minSdliderDisplay"] = "¥0" as AnyObject
            params["priceSlider_maxSdliderDisplay"] = "¥3000+" as AnyObject
        } else {
            let set = CharacterSet(charactersIn: "--> ")
            let tempArray = price.components(separatedBy: set)
            params["priceSlider_minSliderDisplay"] = tempArray[0]
            params["priceSlider_maxSliderDisplay"] = tempArray[3]
        }
        
        params["fromDate"] = keyInfo["Checkin"]
        params["toDate"] = keyInfo["Checkout"]
        Alamofire.request(strURL, method: .post, parameters: params).responseData(completionHandler: {response in
            if let data = response.result.value {
                do {
                    let str = String.init(data: data, encoding: .utf8)
                    NSLog("查询酒店 = %@", str!)
                    let tbxml = try? TBXML.newTBXML(withXMLData: data, error: ())
                    var list = [AnyObject]()
                    if let root = tbxml?.rootXMLElement {
                        let hotel_listElement = TBXML.childElementNamed("hotel_list", parentElement:root)
                        if hotel_listElement != nil {
                            var hotelElement = TBXML.childElementNamed("hotel", parentElement: hotel_listElement)
                            while hotelElement != nil {
                                var dict = [String:AnyObject]()
                                let idElement = TBXML.childElementNamed("id", parentElement: hotelElement)
                                if idElement != nil {
                                    dict["id"] = TBXML.text(for: idElement) as AnyObject
                                }
                                let descriptionElement = TBXML.childElementNamed("description", parentElement: hotelElement)
                                if descriptionElement != nil {
                                    dict["description"] = TBXML.text(for: descriptionElement) as AnyObject
                                }
                                let name = TBXML.childElementNamed("name", parentElement:hotelElement)
                                if name != nil {
                                    dict["name"] = TBXML.text(for: name) as  AnyObject
                                }
                                let address = TBXML.childElementNamed("address", parentElement:hotelElement)
                                if address != nil {
                                    dict["address"] = TBXML.text(for: address) as  AnyObject
                                }
                                let phone = TBXML.childElementNamed("phone", parentElement:hotelElement)
                                if phone != nil {
                                    dict["phone"] = TBXML.text(for: phone) as  AnyObject
                                }
                                let lowprice = TBXML.childElementNamed("lowprice", parentElement:hotelElement)
                                if lowprice != nil {
                                    dict["lowprice"] = TBXML.text(for: lowprice) as  AnyObject
                                }
                                let grade = TBXML.childElementNamed("grade", parentElement:hotelElement)
                                if grade != nil {
                                    dict["grade"] = TBXML.text(for: grade) as  AnyObject
                                }
                                let imgElement = TBXML.childElementNamed("img", parentElement: hotelElement)
                                if imgElement != nil {
                                    let src = TBXML.value(ofAttributeNamed: "src", for: imgElement)
                                    dict["img"] = src as AnyObject
                                }
                                hotelElement = TBXML.nextSiblingNamed("hotel", searchFrom: hotelElement)
                                list.append(dict as AnyObject)
                            }
                        }
                    }
                    NSLog("解析完成...")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryHotelFinishedNotification), object: list)
                }catch{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryHotelFailedNotification), object: nil)
                }
            }
        })
    }
}
