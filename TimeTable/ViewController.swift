//
//  ViewController.swift
//  TimeTable
//
//  Created by Alexander Wohltan on 27.03.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var timeTable: TimeTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timeTable = TimeTable(server: "https://melete.webuntis.com", school: "htl-donaustadt", user: APIUSERNAME, pass: APIUSERPASS)
        
        testAPI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var max = 0
        for day in timeTable.timeGrid.days
        {
            if day.timeGridUnits.count > max
            {
                max = day.timeGridUnits.count
            }
        }
        println(max)
        return max + 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeTable.timeGrid.days.count + 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCollectionViewCell", forIndexPath: indexPath) as CustomCollectionViewCell
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell.backgroundColor = UIColor.whiteColor()
                cell.cellLabel.text = ""
            }
            else
            {
                cell.backgroundColor = UIColor.whiteColor()
                cell.cellLabel.text = Day(rawValue: indexPath.row)?.description
            }
        }
        else
        {
            if indexPath.row == 0
            {
                
                var max: [TimeGridUnit] = []
                for day in timeTable.timeGrid.days
                {
                    if day.timeGridUnits.count > max.count
                    {
                        max = day.timeGridUnits
                    }
                }
                cell.backgroundColor = UIColor.whiteColor()
                // max[indexPath.row +1].startTime
                cell.cellLabel.text = (indexPath.section).toString()
            }
            else
            {
                cell.backgroundColor = UIColor.redColor()
                
                cell.cellLabel.text = "\(indexPath.section) \(indexPath.row)"
            }
        }
        
        return cell
    }
}

