//
//  LETimeIntervalPicker.swift
//  LETimeIntervalPickerExample
//
//  Created by Ludvig Eriksson on 2015-06-04.
//  Copyright (c) 2015 Ludvig Eriksson. All rights reserved.
//

import UIKit

public class LETimeIntervalPicker: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Public API
    
    public var timeInterval: NSTimeInterval {
        get {
            let hours = pickerView.selectedRowInComponent(0) * 60 * 60
            let minutes = pickerView.selectedRowInComponent(1) * 60
            let seconds = pickerView.selectedRowInComponent(2)
            return NSTimeInterval(hours + minutes + seconds)
        }
        set {
            setPickerToTimeInterval(newValue, animated: false)
        }
    }
    
    public var timeIntervalAsHoursMinutesSeconds: (hours: Int, minutes: Int, seconds: Int) {
        get {
            return secondsToHoursMinutesSeconds(Int(timeInterval))
        }
    }

    public func setTimeIntervalAnimated(interval: NSTimeInterval) {
        setPickerToTimeInterval(interval, animated: true)
    }
    
    // Note that setting a font that makes the picker wider
    // than this view can cause layout problems
    public var font = UIFont.systemFontOfSize(17) {
        didSet {
            updateLabels()
            calculateNumberWidth()
            calculateTotalPickerWidth()
            pickerView.reloadAllComponents()
        }
    }
    
    // MARK: - UI Components
    
    private let pickerView = UIPickerView()
    
    private let hourLabel = UILabel()
    private let minuteLabel = UILabel()
    private let secondLabel = UILabel()
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setupLocalizations()
        setupLabels()
        calculateNumberWidth()
        calculateTotalPickerWidth()
        setupPickerView()
    }
    
    private func setupLabels() {
        hourLabel.text = hoursString
        addSubview(hourLabel)
        minuteLabel.text = minutesString
        addSubview(minuteLabel)
        secondLabel.text = secondsString
        addSubview(secondLabel)
        updateLabels()
    }
    
    private func updateLabels() {
        hourLabel.font = font
        hourLabel.sizeToFit()
        minuteLabel.font = font
        minuteLabel.sizeToFit()
        secondLabel.font = font
        secondLabel.sizeToFit()
    }
    
    private func calculateNumberWidth() {
        let label = UILabel()
        label.font = font
        numberWidth = 0
        for i in 0...59 {
            label.text = "\(i)"
            label.sizeToFit()
            if label.frame.width > numberWidth {
                numberWidth = label.frame.width
            }
        }
    }
    
    private func calculateTotalPickerWidth() {
        // Used to position labels

        totalPickerWidth = 0
        totalPickerWidth += hourLabel.bounds.width
        totalPickerWidth += minuteLabel.bounds.width
        totalPickerWidth += secondLabel.bounds.width
        totalPickerWidth += standardComponentSpacing * 2
        totalPickerWidth += extraComponentSpacing * 3
        totalPickerWidth += labelSpacing * 3
        totalPickerWidth += numberWidth * 3
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        
        // Size picker view to fit self
        let top = NSLayoutConstraint(item: pickerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1,
            constant: 0)
        
        let bottom = NSLayoutConstraint(item: pickerView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        
        let leading = NSLayoutConstraint(item: pickerView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1,
            constant: 0)
        
        let trailing = NSLayoutConstraint(item: pickerView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0)
        
        addConstraints([top, bottom, leading, trailing])
    }
    
    // MARK: - Layout
    
    private var totalPickerWidth: CGFloat = 0
    private var numberWidth: CGFloat = 20               // Width of UILabel displaying a two digit number with standard font

    private let standardComponentSpacing: CGFloat = 5   // A UIPickerView has a 5 point space between components
    private let extraComponentSpacing: CGFloat = 10     // Add an additional 10 points between the components
    private let labelSpacing: CGFloat = 5               // Spacing between picker numbers and labels
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Reposition labels
        
        hourLabel.center.y = CGRectGetMidY(pickerView.frame)
        minuteLabel.center.y = CGRectGetMidY(pickerView.frame)
        secondLabel.center.y = CGRectGetMidY(pickerView.frame)
        
        let pickerMinX = CGRectGetMidX(bounds) - totalPickerWidth / 2
        hourLabel.frame.origin.x = pickerMinX + numberWidth + labelSpacing
        let space = standardComponentSpacing + extraComponentSpacing + numberWidth + labelSpacing
        minuteLabel.frame.origin.x = CGRectGetMaxX(hourLabel.frame) + space
        secondLabel.frame.origin.x = CGRectGetMaxX(minuteLabel.frame) + space
    }
    
    // MARK: - Picker view data source
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Components(rawValue: component)! {
        case .Hour:
            return 24
        case .Minute:
            return 60
        case .Second:
            return 60
        }
    }
    
    // MARK: - Picker view delegate
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let labelWidth: CGFloat
        switch Components(rawValue: component)! {
        case .Hour:
            labelWidth = hourLabel.bounds.width
        case .Minute:
            labelWidth = minuteLabel.bounds.width
        case .Second:
            labelWidth = secondLabel.bounds.width
        }
        return numberWidth + labelWidth + labelSpacing + extraComponentSpacing
    }
    
    public func pickerView(pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView?) -> UIView {
            
            // Check if view can be reused
            var newView = view
            
            if newView == nil {
                // Create new view
                let size = pickerView.rowSizeForComponent(component)
                newView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
                // Setup label and add as subview
                let label = UILabel()
                label.font = font
                label.textAlignment = .Right
                label.adjustsFontSizeToFitWidth = false
                label.frame.size = CGSize(width: numberWidth, height: size.height)
                newView!.addSubview(label)
            }
            
            let label = newView!.subviews.first as! UILabel
            label.text = "\(row)"
            
            return newView!
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 1 {
            // Change label to singular
            switch Components(rawValue: component)! {
            case .Hour:
                hourLabel.text = hourString
            case .Minute:
                minuteLabel.text = minuteString
            case .Second:
                secondLabel.text = secondString
            }
        } else {
            // Change label to plural
            switch Components(rawValue: component)! {
            case .Hour:
                hourLabel.text = hoursString
            case .Minute:
                minuteLabel.text = minutesString
            case .Second:
                secondLabel.text = secondsString
            }
        }
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    // MARK: - Helpers
    
    private func setPickerToTimeInterval(interval: NSTimeInterval, animated: Bool) {
        let time = secondsToHoursMinutesSeconds(Int(interval))
        pickerView.selectRow(time.hours, inComponent: 0, animated: animated)
        pickerView.selectRow(time.minutes, inComponent: 1, animated: animated)
        pickerView.selectRow(time.seconds, inComponent: 2, animated: animated)
        self.pickerView(pickerView, didSelectRow: time.hours, inComponent: 0)
        self.pickerView(pickerView, didSelectRow: time.minutes, inComponent: 1)
        self.pickerView(pickerView, didSelectRow: time.seconds, inComponent: 2)
    }
    
    private func secondsToHoursMinutesSeconds(seconds : Int) -> (hours: Int, minutes: Int, seconds: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private enum Components: Int {
        case Hour = 0
        case Minute
        case Second
    }
    
    // MARK: - Localization
    
    private var hoursString     = "hours"
    private var hourString      = "hour"
    private var minutesString   = "minutes"
    private var minuteString    = "minute"
    private var secondsString   = "seconds"
    private var secondString    = "second"
    
    private func setupLocalizations() {
        
        let bundle = NSBundle(forClass: LETimeIntervalPicker.self)
        let tableName = "LETimeIntervalPickerLocalizable"
        
        hoursString = NSLocalizedString("hours", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the hours component of the picker.")
        
        hourString = NSLocalizedString("hour", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the hours text.")
        
        minutesString = NSLocalizedString("minutes", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the minutes component of the picker.")
        
        minuteString = NSLocalizedString("minute", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the minutes text.")
        
        secondsString = NSLocalizedString("seconds", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the seconds component of the picker.")
        
        secondString = NSLocalizedString("second", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the seconds text.")
    }
}
