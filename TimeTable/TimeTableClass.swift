//
//  TimeTableClass.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class TimeTableClass {
    var members : Class = Class()
    var days : [Day] = []
    
    func toString() -> String {
        var x = ""
        for d in days {
            x += d.toString()
            x += "\n"
        }
        return x
    }
}