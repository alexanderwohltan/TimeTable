//
//  TimeTableData.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation

public class TimeTableData {
    public var timeTable : [TimeTableClass] = []
    
    public var subjects : [Subject] = []
    public var classes : [Class] = []
    public var teachers : [Teacher] = []
    public var rooms : [Room] = []
    
    init() {
        //fillData()
    }
    
    func fillData() {
        var jsonData = NSData(contentsOfURL: NSURL(string: "http://alex.alphacode.at/TimeTable/nino.html")!)
        //var jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("index", ofType: "json")!)
        var json = JSON(data: jsonData!)
        for x in json {
            switch x.0 {
            case "subjects":
                fillSubjects(x.1)
                break;
            case "classes":
                fillClasses(x.1)
                break;
            case "teachers":
                fillTeachers(x.1)
                break;
            case "rooms":
                fillRooms(x.1)
                break;
            case "departments":
                break;
            case "schoolyears":
                break;
            case "holidays":
                break;
            default:
                break;
            }
        }
        jsonData = NSData(contentsOfURL: NSURL(string: "http://alex.alphacode.at/TimeTable/Classes/1AHET.html")!)
        json = JSON(data: jsonData!)
        addClass(json)
    }
    
    func fillSubjects(json : JSON) {
        for x in json {
            var longString = x.1["long"].string
            var shortString = x.1["short"].string
            var sub = Subject(lString: longString!, sString: shortString!)
            sub.id = x.1["id"].stringValue.integerValue
            subjects.append(sub)
        }
    }
    func fillClasses(json : JSON) {
        
        for x in json {
            var longString = x.1["long"].string
            var shortString = x.1["short"].string
            var cla = Class(sName: shortString!, lName: longString!)
            cla.id = x.1["id"].stringValue.integerValue
            classes.append(cla)
        }
    }
    func fillTeachers(json : JSON) {
        for x in json {
            var shortc = x.1["name"].stringValue
            var fore = x.1["fore"].stringValue
            var sur = x.1["surname"].stringValue
            var long = x.1["long"].stringValue
            var teach = Teacher(shortcut: shortc, foreName: fore, lastName: sur, longName: long)
            teach.id = x.1["id"].stringValue.integerValue
            teachers.append(teach)
        }
    }
    func fillRooms(json : JSON) {
        for x in json {
            var short = x.1["short"].stringValue
            var long = x.1["long"].stringValue
            var room = Room(short : short, long : long)
            rooms.append(room)
        }
    }
    
    func addClass(json : JSON) {
        var long = json["long"]
        var short = json["short"]
        var clas = Class()
        for cl in classes {
            if cl.name == short.stringValue {
                clas = cl
            }
        }
        var days : [Day] = []
        var periods = json["periods"]
        for var i = 0; i < json["count"].stringValue.integerValue; i++ {
            var day = Day()
            day.date = periods[i]["date"].stringValue
            var count = periods[i]["count"].stringValue.integerValue
            for var j = 0; j < count; j++ {
                var dayJson = periods[i]["table"]
                var unit = Unit()
                unit.start = dayJson[j]["start"].stringValue
                unit.end = dayJson[j]["end"].stringValue
                for d in dayJson[i]["classes"] {
                    for c in classes {
                        if d.1.stringValue.integerValue == c.id {
                            unit.members.append(c)
                        }
                    }
                }
                for d in dayJson[j]["teachers"] {
                    for t in teachers {
                        if d.1.stringValue.integerValue == t.id {
                            unit.teachers.append(t)
                        }
                    }
                }
                for d in dayJson[j]["subjects"] {
                    for s in subjects {
                        if d.1.stringValue.integerValue == s.id {
                            unit.subjects.append(s)
                        }
                    }
                }
                for d in dayJson[j]["rooms"] {
                    for r in rooms {
                        if d.1.stringValue == r.short {
                            unit.rooms.append(r)
                        }
                    }
                }
                
                day.units.append(unit)
            }
            days.append(day)
        }
        
        var tTable = TimeTableClass()
        tTable.members = clas
        tTable.days = days
        timeTable.append(tTable)
    }

}