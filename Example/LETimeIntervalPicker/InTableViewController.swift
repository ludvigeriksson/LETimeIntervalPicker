//
//  TableViewController.swift
//  LETimeIntervalPicker
//
//  Created by Ludvig Eriksson on 2015-06-05.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import LETimeIntervalPicker

class TableViewController: UITableViewController {

    // MARK: - Outlets & properties
    
    @IBOutlet weak var detailLabel: UILabel!

    var pickerIsVisible = false
    let formatter = NSDateComponentsFormatter()
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.unitsStyle = .Abbreviated
        detailLabel.text = formatter.stringFromTimeInterval(0)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.beginUpdates()
        pickerIsVisible = !pickerIsVisible
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            if pickerIsVisible {
                return 216
            } else {
                return 0
            }
        }
        return tableView.rowHeight
    }
    
    // MARK: - Actions
    
    @IBAction func pickerChanged(sender: LETimeIntervalPicker) {
        detailLabel.text = formatter.stringFromTimeInterval(sender.timeInterval)
    }
    
}
