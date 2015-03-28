//
//  WebuntisAPI.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 23.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import Foundation

let APIUSERNAME = "api"
let APIUSERPASS = "a9067b34"

public class WebUntisSession {
    var sessionID = ""
    var personType = 0
    var personID = 0
    var klasseID = 0
    
    let jsonrpcURL : String = "/WebUntis/jsonrpc.do"
    var serverURL : String = ""
    var school : String = ""
    
    var isAuthenticating = false
    var isLoggedOut = true
    
    private var isRequestingTeachers = false
    private var isRequestingTutorGroups = false
    private var isRequestingSubjects = false
    private var isRequestingRooms = false
    private var isRequestingDepartments = false
    private var isRequestingHolidays = false
    private var isRequestingTimeGrid = false
    private var isRequestingStatusData = false
    private var isRequestingCurrentSchoolyear = false
    private var isRequestingSchoolyears = false
    private var isRequestingTimeTable = false
    
    private var operatingTasks: [Byte] = []
    
    private var teachers: [Teacher] = []
    private var tutorGroups: [TutorGroup] = []
    private var subjects: [Subject] = []
    private var rooms: [Room] = []
    private var departments: [Department] = []
    private var holidays: [Holiday] = []
    private var timeGrid: TimeGrid = TimeGrid()
    private var statusData: StatusData = StatusData()
    private var currentSchoolyear: Schoolyear = Schoolyear()
    private var schoolyears: [Schoolyear] = []
    private var timeTable: [Period] = []
    
    init(user:String, pass:String, serverURL:String, school:String)
    {
        self.serverURL = serverURL
        self.school = school
        self.authenticate(user, pass: pass)
    }
    
    func sendAuthPOSTRequestToServer(requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
    {
        if isLoggedOut
        {
            var requestURL = "\(serverURL)\(jsonrpcURL)?school=\(school)"
            
            operatingTasks.append(1)
            
            sendPOSTRequest(requestURL, requestBody, completionHandler)
        }
        else
        {
            println("Cannot Authenticate - Already logged in. Log out first")
        }
    }
    func sendPOSTRequestToServer(requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
    {
        while self.isAuthenticating
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        if !isLoggedOut
        {
            while(self.sessionID == "")
            {
                NSThread.sleepForTimeInterval(0.1)
            }
            
            var requestURL = "\(serverURL)\(jsonrpcURL)?jsessionid=\(sessionID)&school=\(school)"
            
            operatingTasks.append(1)
            
            var cookies: [String: String] = ["jsessionid": "\(sessionID)"]
            
            sendPOSTRequest(requestURL, requestBody, completionHandler)
        }
        else
        {
            println("Cannot send POST Request. Not logged in. Authenticate first")
        }
    }
    func sendDeAuthPOSTRequestToServer(requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
    {
        while operatingTasks.count != 0
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        sendPOSTRequestToServer(requestBody, completionHandler: completionHandler)
    }
    
    func authenticate(user:String, pass:String)
    {
        while isAuthenticating
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        isAuthenticating = true
        
        let authID = 000001
        
        var postBodyJSON : JSON = ["id":authID.toString(), "method":"authenticate", "params":["user":user,"password":pass,"client":"BESTSWIFTCLIENTEVER"], "jsonrpc":"2.0"]
        
        sendAuthPOSTRequestToServer(postBodyJSON.description, completionHandler: authenticationHandler)
    }
    func logout()
    {
        let logoutID = 000000
        
        var postBodyJSON : JSON = ["id":"00000", "method":"logout", "params":[], "jsonrpc":"2.0"]
        
        sendDeAuthPOSTRequestToServer(postBodyJSON.description, completionHandler: logoutHandler)
    }
    func requestTeachers()
    {
        while isRequestingTeachers
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingTeachers = true
        
        let requestID = 001001
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getTeachers", "params":[], "jsonrpc":"2.0"]
        
        teachers.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTeachersHandler)
    }
    func requestTutorGroups()
    {
        while isRequestingTutorGroups
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingTutorGroups = true
        
        let requestID = 001002
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getKlassen", "params":[], "jsonrpc":"2.0"]
        
        tutorGroups.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTutorGroupsHandler)
    }
    func requestSubjects()
    {
        while isRequestingSubjects
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingSubjects = true
        
        let requestID = 001003
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getSubjects", "params":[], "jsonrpc":"2.0"]
        
        subjects.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestSubjectsHandler)
        
    }
    func requestRooms()
    {
        while isRequestingRooms
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingRooms = true
        
        let requestID = 001004
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getRooms", "params":[], "jsonrpc":"2.0"]
        
        rooms.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestRoomsHandler)
    }
    func requestDepartments()
    {
        while isRequestingDepartments
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingDepartments = true
        
        let requestID = 001005
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getDepartments", "params":[], "jsonrpc":"2.0"]
        
        departments.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestDepartmentsHandler)
    }
    func requestHolidays()
    {
        while isRequestingHolidays
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingHolidays = true
        
        let requestID = 001006
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getHolidays", "params":[], "jsonrpc":"2.0"]
        
        holidays.removeAll(keepCapacity: false)
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestHolidaysHandler)
    }
    func requestTimeGrid()
    {
        while isRequestingTimeGrid
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingTimeGrid = true
        
        let requestID = 001007
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getTimegridUnits", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTimeGridHandler)
    }
    func requestStatusData()
    {
        while isRequestingStatusData
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingStatusData = true
        
        let requestID = 001008
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getStatusData", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestStatusDataHandler)
    }
    func requestCurrentSchoolyear()
    {
        while isRequestingCurrentSchoolyear
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingCurrentSchoolyear = true
        
        let requestID = 001009
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getCurrentSchoolyear", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestCurrentSchoolyearHandler)
    }
    func requestSchoolyears()
    {
        while isRequestingSchoolyears
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        self.isRequestingStatusData = true
        
        let requestID = 001010
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getSchoolyears", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestSchoolyearsHandler)
    }
    func requestTimeTable(id: Int, type: Int, startDate: String, endDate: String)
    {
        while isRequestingTimeTable
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        if tutorGroups.count == 0 || subjects.count == 0 || rooms.count == 0 || teachers.count == 0
        {
            println("Cannot request Time Table. Request tutorGroups, subjects, rooms and teachers first.")
            return
        }
        
        self.isRequestingTimeTable = true
        
        let requestID = 0010111
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getTimetable", "params":["id":id, "type":type, "startDate":startDate, "endDate":endDate], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTimeTableHandler)
    }
    func requestTimeTable(id: Int, type: Int)
    {
        while isRequestingTimeTable
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        
        if tutorGroups.count == 0 || subjects.count == 0 || rooms.count == 0 || teachers.count == 0
        {
            println("Cannot request Time Table. Request tutorGroups, subjects, rooms and teachers first.")
            return
        }
        
        self.isRequestingTimeTable = true
        
        let requestID = 0010110
        
        var requestBodyJSON : JSON = ["id":requestID.toString(), "method":"getTimetable", "params":["id":id, "type":type], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTimeTableHandler)
    }
    
    func authenticationHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        //let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("responseString (Authentication) = \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        self.sessionID = (responseJSON["result"]["sessionId"] as JSON).stringValue
        self.personType = (responseJSON["result"]["personType"] as JSON).intValue
        self.personID = (responseJSON["resudddlt"]["personId"] as JSON).intValue
        self.klasseID = (responseJSON["result"]["klasseId"] as JSON).intValue
        
        println("Authenticated with Session ID \(self.sessionID) at school \(school)")
        
        self.isAuthenticating = false
        self.isLoggedOut = false
        
        endHandler()
    }
    func logoutHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error while logging out = \(error)")
            return
        }
        
        for cookie : NSHTTPCookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! as [NSHTTPCookie]
        {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
        }
        
        //println("response = \(response)")
        
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        self.isLoggedOut = true
        
        println("Logged out (Session ID: \(self.sessionID))")
        
        endHandler()
    }
    func requestTeachersHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Teachers = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for teacher in responseJSON["result"] {
            teachers.append(Teacher(json: teacher.1))
        }
        
        self.isRequestingTeachers = false
        
        println("Requested Teachers from school \(school). Got \(teachers.count) teachers")
        
        endHandler()
    }
    func requestTutorGroupsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Tutor Groups = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for tutorGroup in responseJSON["result"] {
            tutorGroups.append(TutorGroup(json: tutorGroup.1))
        }
        
        self.isRequestingTutorGroups = false
        
        println("Requested Tutor Groups from school \(school). Got \(tutorGroups.count) Tutor Groups")
        
        endHandler()
    }
    func requestSubjectsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Subjects = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for subject in responseJSON["result"] {
            subjects.append(Subject(json: subject.1))
        }
        
        self.isRequestingSubjects = false
        
        println("Requested Subjects from school \(school). Got \(subjects.count) Subjects")
        
        endHandler()
    }
    func requestRoomsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Rooms = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for room in responseJSON["result"] {
            rooms.append(Room(json: room.1))
        }
        
        self.isRequestingRooms = false
        
        println("Requested Rooms from school \(school). Got \(rooms.count) Rooms")
        
        endHandler()
    }
    func requestDepartmentsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Departments = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting Departments): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        for department in responseJSON["result"] {
            departments.append(Department(json: department.1))
        }
        
        self.isRequestingDepartments = false
        
        println("Requested Departments from school \(school). Got \(departments.count) Department")
        
        endHandler()
    }
    func requestHolidaysHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Holidays = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting Holidays): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        for holiday in responseJSON["result"] {
            holidays.append(Holiday(json: holiday.1))
        }
        
        self.isRequestingHolidays = false
        
        println("Requested Holidays from school \(school). Got \(holidays.count) Holidays")
        
        endHandler()
    }
    func requestTimeGridHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching the Time Grid = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting TimeGrid): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        timeGrid = TimeGrid(json: responseJSON["result"])
        
        self.isRequestingTimeGrid = false
        
        println("Requested the Time Grid from school \(school). Got \(timeGrid.days.count) Days")
        
        endHandler()
    }
    func requestStatusDataHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Fetching Status Data = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting StatusData): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        statusData = StatusData(json: responseJSON["result"])
        
        self.isRequestingStatusData = false
        
        println("Requested Status Data from school \(school). The backcolor of a normal lesson is \(statusData.lessonTypeData[LessonType.Lesson]?.backColor)")
        
        endHandler()
    }
    func requestCurrentSchoolyearHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error while fetching current schoolyear = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting Current Schoolyear): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        currentSchoolyear = Schoolyear(json: responseJSON["result"])
        
        self.isRequestingCurrentSchoolyear = false
        
        println("Requested the current schoolyear from school \(school). The current schoolyear is \(currentSchoolyear.name)")
        
        endHandler()
    }
    func requestSchoolyearsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error while fetching schoolyears = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting Schoolyears): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        for year in responseJSON["result"]
        {
            schoolyears.append(Schoolyear(json: year.1))
        }
        
        self.isRequestingSchoolyears = false
        
        println("Requested Status Data from school \(school). Got \(schoolyears.count) schoolyears")
        
        endHandler()
    }
    func requestTimeTableHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error while fetching timeTable = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        println("Response (Requesting timetable): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        for period in responseJSON["result"]
        {
            timeTable.append(Period(json: period.1, tutorGroupList: tutorGroups, teacherList: teachers, subjectList: subjects, roomList: rooms))
        }
        
        self.isRequestingTimeTable = false
        
        println("Requested the time table from school \(school). The time table has \(timeTable.count) entries.")
        
        endHandler()
    }
    
    func getTeachers() -> [Teacher]
    {
        requestTeachers()
        while isRequestingTeachers
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return teachers
    }
    func getTutorGroups() -> [TutorGroup]
    {
        requestTutorGroups()
        while isRequestingTutorGroups
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return tutorGroups
    }
    func getSubjects() -> [Subject]
    {
        requestSubjects()
        while isRequestingSubjects
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return subjects
    }
    func getRooms() -> [Room]
    {
        requestRooms()
        while isRequestingRooms
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return rooms
    }
    func getDepartments() -> [Department]
    {
        requestDepartments()
        while isRequestingDepartments
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return departments
    }
    func getHolidays() -> [Holiday]
    {
        requestHolidays()
        while isRequestingHolidays
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return holidays
    }
    func getTimeGrid() -> TimeGrid
    {
        requestTimeGrid()
        while isRequestingTimeGrid
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return timeGrid
    }
    func getStatusData() -> StatusData
    {
        requestStatusData()
        while isRequestingStatusData
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return statusData
    }
    func getCurrentSchoolyear() -> Schoolyear
    {
        requestCurrentSchoolyear()
        while isRequestingCurrentSchoolyear
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return currentSchoolyear
    }
    func getSchoolyears() -> [Schoolyear]
    {
        requestSchoolyears()
        while isRequestingSchoolyears
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return schoolyears
    }
    func getTimeTable(id: Int, type: Int, startDate: String, endDate: String) -> [Period]
    {
        requestTimeTable(id, type: type, startDate: startDate, endDate: endDate)
        while isRequestingTimeTable
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return timeTable
    }
    func getTimeTable(id: Int, type: Int) -> [Period]
    {
        requestTimeTable(id, type: type)
        while isRequestingTimeTable
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return timeTable
    }
    
    func endHandler()
    {
        operatingTasks.removeLast()
    }
    
    func toString() -> String
    {
        return "SessionID: \(sessionID)"
    }
}

func testAPI()
{
    var x = WebUntisSession(user: APIUSERNAME, pass: APIUSERPASS, serverURL: "https://melete.webuntis.com", school: "htl-donaustadt")
    x.getTeachers()
    var tg = x.getTutorGroups()
    x.getSubjects()
    x.getRooms()
    x.getDepartments()
    x.getHolidays()
    x.getTimeGrid()
    x.getStatusData()
    x.getCurrentSchoolyear()
    x.getSchoolyears()
    for tutorGroup in tg
    {
        if tutorGroup.id == x.klasseID
        {
            println(tutorGroup.name)
        }
    }
    x.getTimeTable(x.getTeachers()[26].id, type: ElementType.Teacher.rawValue, startDate: "20150324", endDate: "20150324")
    x.logout()
}

func sendPOSTRequest(requestURL: String, requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?, cookies: [String : String])
{
    let request = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    for (title, value) in cookies
    {
        request.addValue(value, forHTTPHeaderField: title)
    }
    
    request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
    
    //request.HTTPShouldHandleCookies = false
    
    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
}
func sendPOSTRequest(requestURL: String, requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
{
    sendPOSTRequest(requestURL, requestBody, completionHandler, [:])
}