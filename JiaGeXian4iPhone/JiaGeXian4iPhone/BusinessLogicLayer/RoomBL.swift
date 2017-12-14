//
//  RoomBL.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/6.
//  Copyright © 2017年 lxm. All rights reserved.
//

import UIKit
import Alamofire

let BLQueryRoomFinishedNotification = "BLQueryRoomFinishedNotification"
let BLQueryRoomFailedNotification = "BLQueryRoomFailedNotification"
let ROOM_QUERY_URL = "http://jiagexian.com/priceline/hotelroom/hotelroomcache.mobile"
//"/priceline/hotelroom/hotelroomqunar.mobile"


class RoomBL: NSObject {
    static func shared()->RoomBL{
        struct singleton{
            static var single = RoomBL()
        }
        DispatchQueue.once("YouShaoduo") {
            singleton.single = shared()
        }
        return singleton.single
    }
    
    public func queryRoom(keyInfo:[String:AnyObject]){
        var strURL = KEY_QUERY_URL
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var params = NSDictionary()  as! Parameters
        params["supplierid"] = keyInfo["hotelId"] as AnyObject
        params["fromDate"] = keyInfo["Checkin"] as AnyObject
        params["toDate"] = keyInfo["Checkout"] as AnyObject
        Alamofire.request(strURL, method: .post, parameters: params).responseData(completionHandler: {response in
            if let data = response.result.value {
                do {
                    let str = String.init(data: data, encoding: .utf8)
                    NSLog("查询酒店 = %@", str!)
                    let tbxml = try? TBXML.newTBXML(withXMLData: data, error: ())
                    var list = [AnyObject]()
                    if let root = tbxml?.rootXMLElement {
                        var roomsElement = TBXML.childElementNamed("room", parentElement: root)
                        while roomsElement != nil {
                            var dict = [String:AnyObject]()
                            let name = TBXML.value(ofAttributeNamed: "room", for: roomsElement)
                            let frontprice = TBXML.value(ofAttributeNamed: "frontprice", for: roomsElement)
                            dict["name"] = name as AnyObject
                            dict["frontprice"] = BLHelp.prePrice(price: frontprice!) as AnyObject
                            roomsElement = TBXML.nextSiblingNamed("room", searchFrom: roomsElement)
                            list.append(dict as AnyObject)
                            
                        }
                    }
                    NSLog("解析完成...")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryRoomFinishedNotification), object: list)
                }catch{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryRoomFailedNotification), object: nil)
                }
            }
        })
    }
}
