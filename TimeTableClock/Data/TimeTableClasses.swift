//
//  TimeTableClass.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
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

public class TimeTableClass {
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

public class Day {
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

public class Unit {
    var members : [Class] = []
    var teachers : [Teacher] = []
    var subjects : [Subject] = []
    var rooms : [Room] = []
    var start = ""
    var end = ""
    
    func toString() -> String {
        var x = ""
        if subjects.count == 0 {
            x += "SUBJECT"
        }
        else {
            x += subjects[0].toString()
        }
        x += ": "
        
        if members.count == 0 {
            x += "CLASS"
        }
        else {
            x += members[0].toString()
        }
        x += " "
        
        if teachers.count == 0 {
            x += "TEACHER"
        }
        else {
            x += teachers[0].toString()
        }
        x += " ("
        
        if start == "" {
            x += "START"
        }
        else {
            x += start
        }
        x += "-"
        if end == "" {
            x += "END"
        }
        else {
            x += end
        }
        x += ")"
        return x
    }
}
