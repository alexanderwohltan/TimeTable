//
//  DetailViewController.swift
//  TimeTableClock
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var classItem: Class? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var timeTable : TimeTableData? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Class = self.classItem {
            if let label = self.nameLabel {
                label.text = detail.toString()
            }
        }
        if let table: TimeTableData = self.timeTable {
            if let label = self.detailDescriptionLabel {
                if let cl : Class = self.classItem {
                    for x in table.timeTable {
                        if x.members.name == cl.name {
                            label.text = x.toString()
                            println(x.toString())
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

