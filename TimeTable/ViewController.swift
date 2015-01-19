//
//  ViewController.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import UIKit

extension String {
    var doubleValue : Double {
        return (self as NSString).doubleValue
    }
    var integerValue : Int {
        return (self as NSString).integerValue
    }
}
extension Double {
    func toString() -> String {
        return String(format: "%.1f", self)
    }
}
extension Int {
    func toString() -> String {
        return String(self)
    }
}

class ViewController: UIViewController {
    var timeTable : [TimeTableClass] = []
    
    var subjects : [Subject] = []
    var classes : [Class] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fillData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    break;
                case "rooms":
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
    }
    
    func fillSubjects(json : JSON) {
        for x in json {
            var longString = x.1["long"].string
            var shortString = x.1["short"].string
            var sub = Subject(lString: longString!, sString: shortString!)
            subjects.append(sub)
        }
    }
    func fillClasses(json : JSON) {
        for x in json {
            var longString = x.1["long"].string
            var shortString = x.1["short"].string
            var cla = Class(sName: shortString!, lName: longString!)
            classes.append(cla)
        }
    }
}

