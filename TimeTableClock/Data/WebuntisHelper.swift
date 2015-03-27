//
//  WebuntisHelper.swift
//  TimeTableClock
//
//  Created by Alexander Wohltan on 23.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import Foundation

let APIUSERNAME = "api"
let APIUSERPASS = "a9067b34"

class WebUntisSession {
    var sessionID = ""
    var personType = 0
    var personID = 0
    var klasseID = 0
    
    let jsonrpcURL : String = "/WebUntis/jsonrpc.do"
    var serverURL : String = ""
    var school : String = ""
    
    var isAuthenticating = false
    var isLoggedOut = true
    
    var isRequestingTeachers = false
    var isRequestingClasses = false
    var isRequestingSubjects = false
    var isRequestingRooms = false
    var isRequestingDepartments = false
    
    var operatingTasks: [Byte] = []
    
    private var teachers: [Teacher] = []
    private var classes: [Class] = []
    private var subjects: [Subject] = []
    private var rooms: [Room] = []
    private var departments: [Department] = []
    
    init(user:String, pass:String, serverURL:String, school:String)
    {
        self.serverURL = serverURL
        self.school = school
        //dispatch_async(dispatch_get_main_queue(), { self.authenticate(user, pass: pass, serverURL: serverURL, school: school)})
        authenticate(user, pass: pass)
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
        self.isRequestingTeachers = true
        
        let requestTeacherID = 001001
        
        var requestBodyJSON : JSON = ["id":requestTeacherID.toString(), "method":"getTeachers", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestTeachersHandler)
    }
    func requestClasses()
    {
        self.isRequestingClasses = true
        
        let requestTeacherID = 001002
        
        var requestBodyJSON : JSON = ["id":requestTeacherID.toString(), "method":"getKlassen", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestClassesHandler)
    }
    func requestSubjects()
    {
        self.isRequestingSubjects = true
        
        let requestTeacherID = 001003
        
        var requestBodyJSON : JSON = ["id":requestTeacherID.toString(), "method":"getSubjects", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestSubjectsHandler)

    }
    func requestRooms()
    {
        self.isRequestingRooms = true
        
        let requestTeacherID = 001004
        
        var requestBodyJSON : JSON = ["id":requestTeacherID.toString(), "method":"getRooms", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestRoomsHandler)
    }
    func requestDepartments()
    {
        self.isRequestingDepartments = true
        
        let requestTeacherID = 001005
        
        var requestBodyJSON : JSON = ["id":requestTeacherID.toString(), "method":"getDepartments", "params":[], "jsonrpc":"2.0"]
        
        sendPOSTRequestToServer(requestBodyJSON.description, completionHandler: requestDepartmentsHandler)
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
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
            
        for teacher in responseJSON["result"] {
            var id = teacher.1["id"].intValue
            var name = teacher.1["name"].stringValue
            var foreName = teacher.1["foreName"].stringValue
            var longName = teacher.1["longName"].stringValue
            teachers.append(Teacher(id: id, shortcut: name, foreName: foreName, lastName: longName))
        }
        
        self.isRequestingTeachers = false
            
        println("Requested Teachers from school \(school). Got \(teachers.count) teachers")
        
        endHandler()
    }
    func requestClassesHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for clas in responseJSON["result"] {
            var id = clas.1["id"].intValue
            var name = clas.1["name"].stringValue
            var longName = clas.1["longName"].stringValue
            classes.append(Class(id: id, name: name, longName: longName))
        }
        
        self.isRequestingClasses = false
        
        println("Requested Classes from school \(school). Got \(classes.count) Classes")
        
        endHandler()
    }
    func requestSubjectsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for subject in responseJSON["result"] {
            var id = subject.1["id"].intValue
            var name = subject.1["name"].stringValue
            var longName = subject.1["longName"].stringValue
            subjects.append(Subject(id: id, name: name, longName: longName))
        }
        
        self.isRequestingSubjects = false
        
        println("Requested Subjects from school \(school). Got \(subjects.count) Subjects")
        
        endHandler()
    }
    func requestRoomsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let responseJSON = JSON(data: data!)
        
        for room in responseJSON["result"] {
            var id = room.1["id"].intValue
            var name = room.1["name"].stringValue
            var longName = room.1["longName"].stringValue
            rooms.append(Room(id: id, name: name, longName: longName))
        }
        
        self.isRequestingRooms = false
        
        println("Requested Rooms from school \(school). Got \(rooms.count) Rooms")
        
        endHandler()
    }
    func requestDepartmentsHandler(data: NSData!, response: NSURLResponse!, error: NSError!)
    {
        if error != nil {
            println("Error While Authenticating = \(error)")
            return
        }
        
        //println("response = \(response)")
        
        let responseString : String = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //println("Response (Requesting Departments): \(responseString)")
        
        let responseJSON = JSON(data: data!)
        
        for room in responseJSON["result"] {
            var id = room.1["id"].intValue
            var name = room.1["name"].stringValue
            var longName = room.1["longName"].stringValue
            departments.append(Department(id: id, name: name, longName: longName))
        }
        
        self.isRequestingDepartments = false
        
        println("Requested Departments from school \(school). Got \(departments.count) Department")
        
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
    func getClasses() -> [Class]
    {
        requestClasses()
        while isRequestingClasses
        {
            NSThread.sleepForTimeInterval(0.1)
        }
        return classes
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
    
    func endHandler()
    {
        operatingTasks.removeLast()
    }
    
    func toString() -> String
    {
        return "SessionID: \(sessionID)"
    }
}

func test()
{
    var x = WebUntisSession(user: APIUSERNAME, pass: APIUSERPASS, serverURL: "https://melete.webuntis.com", school: "htl-donaustadt")
    x.getTeachers()
    x.getClasses()
    x.getSubjects()
    x.getRooms()
    x.getDepartments()
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
    
    var jsessionid = "JSESSIONID"
    //println("Request: \(request.)")
    
    request.HTTPBody = requestBody.dataUsingEncoding(NSUTF8StringEncoding)
    
    //request.HTTPShouldHandleCookies = false
    
    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler).resume()
}
func sendPOSTRequest(requestURL: String, requestBody: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
{
    sendPOSTRequest(requestURL, requestBody, completionHandler, [:])
}