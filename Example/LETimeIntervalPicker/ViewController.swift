//
//  ViewController.swift
//  LETimeIntervalPickerExample
//
//  Created by Ludvig Eriksson on 2015-06-04.
//  Copyright (c) 2015 Ludvig Eriksson. All rights reserved.
//

import UIKit
import LETimeIntervalPicker

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picker: LETimeIntervalPicker!
    @IBOutlet weak var animated: UISwitch!
    
    let formatter = NSDateComponentsFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.componentOne = Components.Year
        self.picker.componentTwo = .Month
        self.picker.componentThree = .Week
        self.picker.setup()
        formatter.unitsStyle = .Abbreviated
    }
    
    @IBAction func updateLabel(sender: LETimeIntervalPicker) {
        label.text = formatter.stringFromTimeInterval(sender.timeInterval)
        
//        label.text = "\(sender.timeIntervalAsHoursMinutesSeconds.hours) \(sender.timeIntervalAsHoursMinutesSeconds.minutes) \(sender.timeIntervalAsHoursMinutesSeconds.seconds)"
    }
    
    @IBAction func setRandomTimeInterval() {
        let random = NSTimeInterval(arc4random_uniform(60*60*24)) // Random time under 24 hours
        if animated.on {
            picker.setTimeIntervalAnimated(random)
        } else {
            picker.timeInterval = random
        }
    }
}