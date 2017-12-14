//
//  DispatchQueueExtension.swift
//  JiaGeXian4iPhone
//
//  Created by lxm on 2017/11/30.
//  Copyright © 2017年 lxm. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var onceToken = [String]()
    public class func once(_ token: String, _ block:@escaping () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceToken.contains(token) {
            return
        }
        onceToken.append(token)
        block()
    }
}
