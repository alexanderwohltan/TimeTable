//
//  InformationClasses.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 27.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import Foundation

public class TutorGroup {
    var id : Int = 0
    var name : String = ""
    var longName : String = ""
    
    init (id: Int, name: String, longName: String)
    {
        self.id = id
        self.name = name
        self.longName = longName
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longName = json["longName"].stringValue
    }
    
    func toString() -> String {
        return name
    }
}

public class Teacher {
    var id = 0
    var name : String = ""
    var foreName : String = ""
    var longName : String = ""
    
    init (id: Int, name: String, foreName: String, longName: String)
    {
        self.id = id
        self.name = name
        self.foreName = foreName
        self.longName = longName
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.foreName = json["foreName"].stringValue
        self.longName = json["longName"].stringValue
    }
    
    func toString() -> String {
        return name
    }
}

public class Subject {
    var id = 0
    var name = ""
    var longName = ""
    
    init(id: Int, name: String, longName: String)
    {
        self.id = id
        self.name = name
        self.longName = longName
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longName = json["longName"].stringValue
    }
    
    func toString() -> String {
        return name
    }
}

public class Room {
    var id = 0
    var name = ""
    var longName = ""
    
    init(id: Int, name: String, longName: String)
    {
        self.id = id
        self.name = name
        self.longName = longName
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longName = json["longName"].stringValue
    }
    
    func toString() -> String {
        return name
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
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longName = json["longName"].stringValue
    }
    
    func toString() -> String {
        return name
    }
}