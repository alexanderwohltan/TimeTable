//
//  Class.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation
class Class {
    var name : String = ""
    var teacher : Teacher = Teacher()
    var id : Int = 0
    var longName : String = ""
    
    init (sName : String, lName : String) {
        name = sName
        longName = lName
    }
    init() {
        
    }
    
    func toString() -> String {
        return name
    }
}