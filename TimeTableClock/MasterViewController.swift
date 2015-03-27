//
//  MasterViewController.swift
//  TimeTableClock
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var timeTable : TimeTableData!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeTable = TimeTableData()
        test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let cl = timeTable.classes[indexPath.row]
            (segue.destinationViewController as DetailViewController).timeTableData = timeTable
            (segue.destinationViewController as DetailViewController).classItem = cl
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable.classes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = timeTable.classes[indexPath.row].toString()
        return cell
    }

}

