//
//  InfoClasses.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

@objc
public class Class {
    var name : String = ""
    var teacher : Teacher = Teacher()
    var id : Int = 0
    var longName : String = ""
    
    init (sName : String, lName : String) {
        name = sName
        longName = lName
    }
    init (id: Int, name: String, longName: String)
    {
        self.id = id
        self.name = name
        self.longName = longName
    }
    init() {
        
    }
    
    func toString() -> String {
        return name
    }
}

public class Teacher {
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
    init (id: Int, shortcut: String, foreName: String, lastName: String)
    {
        self.id = id
        self.shortcut = shortcut
        self.foreName = foreName
        self.lastName = lastName
        self.longName = "\(foreName) \(lastName)"
    }
    init() {
        
    }
    func toString() -> String {
        return shortcut
    }
}

public class Subject {
    var id = 0
    var longString = ""
    var shortString = ""
    
    init(lString : String, sString : String) {
        longString = lString
        shortString = sString
    }
    init(id: Int, name: String, longName: String)
    {
        self.id = id
        self.shortString = name
        self.longString = longName
    }
    
    func toString() -> String {
        return shortString
    }
}

public class Room {
    var id = 0
    var short = ""
    var long = ""
    
    init (short : String, long : String) {
        self.short = short
        self.long = long
    }
    init(id: Int, name: String, longName: String)
    {
        self.id = id
        self.short = name
        self.long = longName
    }
}

public class Department {
    var id = 0
    var name = ""
    var longName = ""
    
    init(id: Int, name: String, longName: String)
    {
        self.id = id
        self.name = name
        self.longName = longName
    }
}