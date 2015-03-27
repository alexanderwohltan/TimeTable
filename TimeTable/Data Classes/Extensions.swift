//
//  Extensions.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 27.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import Foundation

extension String {
    var doubleValue : Double {
        return (self as NSString).doubleValue
    }
    var integerValue : Int {
        return (self as NSString).integerValue
    }
}
extension Double {
    func toString() -> String {
        return String(format: "%.1f", self)
    }
}
extension Int {
    func toString() -> String {
        return String(self)
    }
}