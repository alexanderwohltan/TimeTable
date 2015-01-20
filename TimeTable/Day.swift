//
//  Day.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class Day {
    var date = ""
    var units : [Unit] = []
    
    func toString() -> String {
        var x = ""
        for u in units {
            x += u.toString()
            x += "\n"
        }
        return x
    }
}
