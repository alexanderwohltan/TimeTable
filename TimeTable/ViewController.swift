//
//  ViewController.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 19.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timeTable : [TimeTableClass] = []
    
    var subjects : [Subject] = []

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
            println(x.0)
            
            switch x.0 {
                case "subjects":
                    break;
                case "classes":
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
        
    }
}

