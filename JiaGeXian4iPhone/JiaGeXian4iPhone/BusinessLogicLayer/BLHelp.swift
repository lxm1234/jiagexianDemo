//
//  File.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/12/6.
//  Copyright © 2017年 lxm. All rights reserved.
//

import Foundation

struct BLHelp {
    
    static func prePrice(price:String)->String{
        if price == "" || Int(price) == 0 {
            return "无房"
        }
        return "¥\(price)/天起"
    }
    
    static func preGrade(grade:String)->String {
        return "¥\(grade)/星级"
    }
    
    static func preBreakfast(breakfase:String)->String {
        let bf = Int(breakfase)
        if bf == -1 {
            return "含早餐"
        } else if bf == 0 {
            return "无早餐"
        } else {
            return "含\(breakfase)早餐"
        }
    }
    
    static func preBed(bed:String)->String {
        let intBed = Int(bed)
        if  intBed == 0 {
            return "大床"
        } else if intBed == 1 {
            return "intBed床"
        } else if intBed == 2 {
            return "大／双床"
        } else if intBed == 3 {
            return "三床"
        } else if intBed == 4 {
            return "一单一双"
        } else if intBed == 5 {
            return "单人床"
        } else if intBed == 6 {
            return "上下铺"
        } else if intBed == 7 {
            return "通铺"
        } else if intBed == 8 {
            return "榻榻米"
        } else if intBed == 9 {
            return "水床"
        } else if intBed == 10 {
            return "圆床"
        } else {
            return "拼床　"
        }
    }
    static func preBroadband(broadband:String)->String{
        let intbroadband = Int(broadband)
        if  intbroadband == 0 {
            return "无宽带"
        } else if intbroadband == 1{
            return "有宽带"
        } else if intbroadband == 2{
            return "宽带免费"
        } else if intbroadband == 3{
            return "宽带收费"
        } else if intbroadband == 4{
            return "宽带部分收费"
        } else if intbroadband == 5{
            return "宽带部分收费"
        } else if intbroadband == 6{
            return "宽带部分收费"
        } else if intbroadband == 7{
            return "宽带部分收费"
        } else {
            return "宽带部分收费"
        }
    }
    static func prePaymode(prepay:String)->String {
        let intprepay = Int(prepay)
        if intprepay == 0 {
            return "需预付"
        } else {
            return "前台现付"
        }
    }
}
