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

public class Holiday {
    var id = 0
    var name = ""
    var longName = ""
    var startDate = NSDate()
    var endDate = NSDate()
    
    init(id: Int, name: String, longName: String, startDate: NSDate, endDate: NSDate)
    {
        self.id = id
        self.name = name
        self.longName = longName
        self.startDate = startDate
        self.endDate = endDate
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longName = json["longName"].stringValue
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HHmmss"
        var sDate = "startDate"
        var eDate = "endDate"
        self.startDate = dateFormatter.dateFromString("\(json[sDate].stringValue) 000000")!
        self.endDate = dateFormatter.dateFromString("\(json[eDate].stringValue) 235959")!
    }
    
    func toString() -> String {
        return name
    }
}

public class TimeGrid {
    var days: [TimeGridDay] = []
    
    init () { }
    init (days: [TimeGridDay])
    {
        self.days = days
    }
    init (json: JSON)
    {
        for day in json
        {
            days.append(TimeGridDay(json: day.1))
        }
    }
}
public class TimeGridDay {
    var day = Day.Monday
    var timeGridUnits: [TimeGridUnit] = []
    
    init (day: Day, timeGridUnits: [TimeGridUnit])
    {
        self.day = day
        self.timeGridUnits = timeGridUnits
    }
    init (json: JSON)
    {
        day = Day(rawValue: json["day"].intValue)!
        for timeUnit in json["timeUnits"]
        {
            timeGridUnits.append(TimeGridUnit(json: timeUnit.1))
        }
    }
}
public class TimeGridUnit {
    var startTime = NSDate()
    var endTime = NSDate()
    
    init(startTime: NSDate, endTime: NSDate)
    {
        self.startTime = startTime
        self.endTime = endTime
    }
    init (json: JSON)
    {
        var dateFormatter = NSDateFormatter()
        if countElements(json["startTime"].stringValue) == 3
        {
            dateFormatter.dateFormat = "Hmm"
        }
        else
        {
            dateFormatter.dateFormat = "HHmm"
        }
        self.startTime = dateFormatter.dateFromString(json["startTime"].stringValue)!
        if countElements(json["endTime"].stringValue) == 3
        {
            dateFormatter.dateFormat = "Hmm"
        }
        else
        {
            dateFormatter.dateFormat = "HHmm"
        }
        self.endTime = dateFormatter.dateFromString(json["endTime"].stringValue)!
    }
}

public class StatusData
{
    var lessonTypeData: [LessonType : StatusDataColors] = [:]
    var lessonCodeData: [LessonCode : StatusDataColors] = [:]
    
    init ()
    {
        
    }
    init (lessonTypeData: [LessonType : StatusDataColors], lessonCodeData: [LessonCode : StatusDataColors])
    {
        self.lessonTypeData = lessonTypeData
        self.lessonCodeData = lessonCodeData
    }
    init (json: JSON)
    {
        for lstype in json["lstypes"]
        {
            //println("\(lstype.1.): \(lstype.1)")
            for ltype in lstype.1
            {
                lessonTypeData[LessonType(rawValue: ltype.0)!] = StatusDataColors(json: ltype.1)
            }
        }
        for code in json["codes"]
        {
            for c in code.1
            {
                lessonCodeData[LessonCode(rawValue: c.0)!] = StatusDataColors(json: c.1)
            }
        }
    }
}
public class StatusDataColors
{
    var foreColor = "#000000"
    var backColor = "#FFFFFF"
    init (foreColor: String, backColor: String)
    {
        self.foreColor = foreColor
        self.backColor = backColor
    }
    init (json: JSON)
    {
        self.foreColor = "#".stringByAppendingString(json["foreColor"].stringValue)
        self.backColor = "#".stringByAppendingString(json["backColor"].stringValue)
    }
}

public class Schoolyear
{
    var id = 0
    var name = ""
    var startDate = NSDate()
    var endDate = NSDate()
    
    init ()
    {
        
    }
    init (id: Int, name: String, startDate: NSDate, endDate: NSDate)
    {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    init (json: JSON)
    {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HHmmss"
        var sDate = "startDate"
        var eDate = "endDate"
        self.startDate = dateFormatter.dateFromString("\(json[sDate].stringValue) 000000")!
        self.endDate = dateFormatter.dateFromString("\(json[eDate].stringValue) 235959")!
    }
}

public class Period
{
    var id = 0
    var startDate = NSDate()
    var endDate = NSDate()
    var tutorGroups: [TutorGroup] = []
    var teachers: [Teacher] = []
    var subjects: [Subject] = []
    var rooms: [Room] = []
    var lessonType: LessonType = .Lesson
    var lessonCode: LessonCode = .Normal
    var lessonText: String?
    
    init (json: JSON, tutorGroupList: [TutorGroup], teacherList: [Teacher], subjectList: [Subject], roomList: [Room])
    {
        self.id = json["id"].intValue
        
        if let type = json["lstype"].string
        {
            lessonType = LessonType(rawValue: type)!
        }
        else
        {
            lessonType = .Lesson
        }
        if let code = json["code"].string
        {
            lessonCode = LessonCode(rawValue: code)!
        }
        else
        {
            lessonCode = .Normal
        }
        
        if let text = json["lstext"].string
        {
            lessonText = text
        }
        
        for tutorGroup in json["kl"]
        {
            for t in tutorGroupList
            {
                if t.id == tutorGroup.1["id"].intValue
                {
                    tutorGroups.append(TutorGroup(json: tutorGroup.1))
                }
            }
        }
        for teacher in json["te"]
        {
            for t in teacherList
            {
                if t.id == teacher.1["id"].intValue
                {
                    teachers.append(Teacher(json: teacher.1))
                }
            }
        }
        for subject in json["su"]
        {
            for s in subjectList
            {
                if s.id == subject.1["id"].intValue
                {
                    subjects.append(Subject(json: subject.1))
                }
            }
        }
        for room in json["ro"]
        {
            for r in roomList
            {
                if r.id == room.1["id"].intValue
                {
                    rooms.append(Room(json: room.1))
                }
            }
        }
        
        var dateFormatter = NSDateFormatter()
        var date = "date"
        var sTime = "startTime"
        var eTime = "endTime"
        if countElements(json["startTime"].stringValue) == 3
        {
            dateFormatter.dateFormat = "yyyyMMdd Hmm"
        }
        else
        {
            dateFormatter.dateFormat = "yyyyMMdd HHmm"
        }
        self.startDate = dateFormatter.dateFromString("\(json[date].stringValue) \(json[sTime].stringValue)")!
        if countElements(json["endTime"].stringValue) == 3
        {
            dateFormatter.dateFormat = "yyyyMMdd Hmm"
        }
        else
        {
            dateFormatter.dateFormat = "yyyyMMdd HHmm"
        }
        self.endDate = dateFormatter.dateFromString("\(json[date].stringValue) \(json[eTime].stringValue)")!
    }
}

public enum Day : Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}
public enum LessonType : String {
    case Lesson = "ls"
    case OfficeHour = "oh"
    case StandBy = "sb"
    case BreakSupervision = "bs"
    case Examination = "ex"
}
public enum LessonCode : String {
    case Normal = "normal"
    case Canceled = "cancelled"
    case irregular = "irregular"
}
public enum ElementType : Int
{
    case Klasse = 1
    case Teacher = 2
    case Subject = 3
    case Room = 4
    case Student = 5
}
