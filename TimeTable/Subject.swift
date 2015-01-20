//
//  Subject.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

class Subject {
    var id = 0
    var longString = ""
    var shortString = ""
    
    init(lString : String, sString : String) {
        longString = lString
        shortString = sString
    }
    
    func toString() -> String {
        return "\(shortString): \(longString)"
    }
}