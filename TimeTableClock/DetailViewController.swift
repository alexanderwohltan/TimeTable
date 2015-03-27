//
//  DetailViewController.swift
//  TimeTableClock
//
//  Created by Alexander Wohltan on 20.01.15.
//  Copyright (c) 2015 Alexander Wohltan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!

    var classItem: Class? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var timeTableData : TimeTableData? {
        didSet {
            self.configureView()
        }
    }
    var timeTable : TimeTableClass?
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Class = self.classItem {
            if let label = self.nameLabel {
                label.text = detail.toString()
            }
        }
        if let table: TimeTableData = self.timeTableData {
            if let label = self.detailDescriptionLabel {
                if let cl : Class = self.classItem {
                    for x in table.timeTable {
                        if x.members.name == cl.name {
                            timeTable = x
                        }
                    }
                }
            }
        }
        
        if let label = self.detailDescriptionLabel {
            label.text = timeTable?.toString()
        }
        if let collView = self.collectionView {
            collView.reloadData()
        }
        //self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UnitCell")
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UnitCell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitCell", forIndexPath: indexPath) as UnitCell
        cell.subTeachLabel.text = "\(timeTable!.days[indexPath.section].units[indexPath.row].subjects[0].toString()) - \(timeTable!.days[indexPath.section].units[indexPath.row].teachers[0].toString() )"
        cell.timeLabel.text = "\(timeTable!.days[indexPath.section].units[indexPath.row].start) - \(timeTable!.days[indexPath.section].units[indexPath.row].end)"
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if let units = self.timeTable {
            return self.timeTable!.days[section].units.count
        /*}
        else {
            return 0
        }*/
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //if let time = self.timeTable {
            return self.timeTable!.days.count
        /*}
        else {
            return 0
        }*/
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //var unit = self.timeTable!.days[indexPath.section].units[indexPath.row]
        //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
        //retval.height += 35; retval.width += 35; return retval;
        return CGSizeMake(collectionView.bounds.size.width * 0.8, 75)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    }
}

