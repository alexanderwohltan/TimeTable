//
//  Unit.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class Unit {
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