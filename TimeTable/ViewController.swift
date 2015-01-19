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
        var resultDir = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: nil) as NSDictionary
        println(resultDir)
    }
}

