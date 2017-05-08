//
//  ViewController.swift
//  LETimeIntervalPicker
//
//  Created by ludvigeriksson on 05/03/2017.
//  Copyright (c) 2017 ludvigeriksson. All rights reserved.
//

import UIKit
import LETimeIntervalPicker

class ViewController: UIViewController {

    @IBOutlet weak var timeIntervalPicker: LETimeIntervalPicker! {
        didSet {
            timeIntervalPicker.set(numberOfRows: 100, for: .hours)
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var animatedSwitch: UISwitch!

    @IBAction func random(_ sender: UIButton) {
        let random = TimeInterval(arc4random_uniform(86400))
        if animatedSwitch.isOn {
            timeIntervalPicker.setTimeIntervalAnimated(random)
        } else {
            timeIntervalPicker.timeInterval = random
        }
    }
    
    @IBAction func pickerChanged(_ sender: LETimeIntervalPicker) {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        var components = DateComponents()
        let timeInterval = sender.timeIntervalAsComponents()
        components.hour = timeInterval[.hours]
        components.minute = timeInterval[.minutes]
        components.second = timeInterval[.seconds]
        
        timeLabel.text = formatter.string(from: components)
    }

}

