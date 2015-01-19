//
//  Subject.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class Subject {
    var ID = 0
    var longString = ""
    var shortString = ""
    
    init(id : Int, lString : String, sString : String) {
        ID = id
        longString = lString
        shortString = sString
    }
}