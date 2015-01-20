//
//  ClassViewController.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 alphacode. All rights reserved.
//

import Foundation
import UIKit

class ClassViewController : UIViewController {
    @IBOutlet weak var classLabel: UILabel!
    
    var timeTable : TimeTableClass = TimeTableClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}