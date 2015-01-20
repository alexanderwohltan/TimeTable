//
//  Teacher.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class Teacher {
    var id = 0
    var shortcut : String = ""
    var foreName : String = ""
    var lastName : String = ""
    var longName : String = ""
    
    init (shortcut : String, foreName : String, lastName : String, longName : String) {
        self.shortcut = shortcut
        self.foreName = foreName
        self.lastName = lastName
        self.longName = longName
    }
    init() {
        
    }
    func toString() -> String {
        return shortcut
    }
}