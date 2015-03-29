//
//  TimeTable.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 28.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import Foundation

public class TimeTable {
    var session: WebUntisSession
    
    var tutorGroups: [TutorGroup]
    var subjects: [Subject]
    var rooms: [Room]
    var departments: [Department]
    var holidays: [Holiday]
    var timeGrid: TimeGrid
    var statusData: StatusData
    
    var school: String {
        return session.school
    }
    
    init (server: String, school: String, user: String, pass: String)
    {
        session = WebUntisSession(user: user, pass: pass, serverURL: server, school: school)
        
        self.tutorGroups = session.getTutorGroups()
        self.subjects = session.getSubjects()
        self.rooms = session.getRooms()
        self.departments = session.getDepartments()
        self.holidays = session.getHolidays()
        self.timeGrid = session.getTimeGrid()
        self.statusData = session.getStatusData()
    }
    
    func getTimeTable(tutorGroupID: Int, startDate: NSDate, endDate: NSDate) -> [Period]
    {
        return session.getTimeTable(tutorGroupID, type: ElementType.Klasse.rawValue, startDate: startDate, endDate: endDate)
    }
    func getTimeTable(tutorGroup: TutorGroup, startDate: NSDate, endDate: NSDate) -> [Period]
    {
        return session.getTimeTable(tutorGroup.id, type: ElementType.Klasse.rawValue, startDate: startDate, endDate: endDate)
    }
    
    func toString() -> String
    {
        return school
    }
}