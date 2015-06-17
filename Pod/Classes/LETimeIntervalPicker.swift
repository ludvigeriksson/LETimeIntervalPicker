//
//  LETimeIntervalPicker.swift
//  LETimeIntervalPickerExample
//
//  Created by Ludvig Eriksson on 2015-06-04.
//  Copyright (c) 2015 Ludvig Eriksson. All rights reserved.
//

import UIKit


public enum Components: Int {
    case None = -1
    case Hour
    case Minute
    case Second
    case Year
    case Month
    case Week
    case Day
}


public class LETimeIntervalPicker: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Public API
    
    
    
    //TODO: Need year/month/week/day timeInterval variable for storing/displaying the selected values.
    
    
    public var timeInterval: NSTimeInterval {
        get {
            
            if let numOfComponents = self.componentsArray?.count {
                
                switch numOfComponents {
                    
                case 1:
                    
                    let hours = pickerView.selectedRowInComponent(0) * 60 * 60
                    return NSTimeInterval(hours)
                    
                case 2:
                    
                    let hours = pickerView.selectedRowInComponent(0) * 60 * 60
                    let minutes = pickerView.selectedRowInComponent(1) * 60
                    return NSTimeInterval(hours + minutes)
                    
                case 3:
                    
                    let hours = pickerView.selectedRowInComponent(0) * 60 * 60
                    let minutes = pickerView.selectedRowInComponent(1) * 60
                    let seconds = pickerView.selectedRowInComponent(2)
                    return NSTimeInterval(hours + minutes + seconds)
                    
                    
                default:
                    return 0
                }
                
            } else {
                
                return 0
            }

            
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
    
    private let labelOne = UILabel()
    private let labelTwo = UILabel()
    private let labelThree = UILabel()
    
    // Component type for each picker column (defaults to hour, minute, second)
    public var componentOne: Components = .None
    public var componentTwo: Components = .None
    public var componentThree: Components = .None
    private var componentsArray: [Components]?
    
    // MARK: - Initialization
    
    required public init(coder aDecoder: NSCoder) {
        self.componentOne = .Hour
        self.componentTwo = .Minute
        self.componentThree = .Second
        super.init(coder: aDecoder)
        setup()
        
    }
    
    override public init(frame: CGRect) {
        self.componentOne = .Hour
        self.componentTwo = .Minute
        self.componentThree = .Second
        super.init(frame: frame)
        setup()
    }
    
    convenience public init(componentOne: Components) {
        
        self.init()
        self.componentOne = componentOne
        self.componentTwo = .None
        self.componentThree = .None
        setup()
    }
    
    convenience public init(componentOne: Components, componentTwo: Components) {
        
        self.init()
        self.componentOne = componentOne
        self.componentTwo = componentTwo
        self.componentThree = .None
        setup()
    }
    
    //Use this init() to define a custom component type for each picker column
    
    convenience public init(componentOne: Components, componentTwo: Components,
        componentThree: Components) {
            
            self.init()
            self.componentOne = componentOne
            self.componentTwo = componentTwo
            self.componentThree = componentThree
            setup()
    }
    
    public func setup() {
        createValidComponentsArray()
        setupLocalizations()
        setupLabels()
        calculateNumberWidth()
        calculateTotalPickerWidth()
        setupPickerView()
    }
    
    private func setupLabels() {
        
        if let safeComponents = self.componentsArray {
            
            switch safeComponents.count {
                
            case 1:
                labelOne.text = getLabelTextForComponent(safeComponents[0])
                addSubview(labelOne)
                break
                
            case 2:
                labelOne.text = getLabelTextForComponent(safeComponents[0])
                addSubview(labelOne)
                labelTwo.text = getLabelTextForComponent(safeComponents[1])
                addSubview(labelTwo)
                break
                
            case 3:
                labelOne.text = getLabelTextForComponent(safeComponents[0])
                addSubview(labelOne)
                labelTwo.text = getLabelTextForComponent(safeComponents[1])
                addSubview(labelTwo)
                labelThree.text = getLabelTextForComponent(safeComponents[2])
                addSubview(labelThree)
                break
                
            default:
                break
            }

            updateLabels()
        }

    }
    
    private func getLabelTextForComponent(component: Components) -> String? {
        switch component {
        case .Hour:
            return hoursString
        case .Minute:
            return minutesString
        case .Second:
            return secondsString
        case .Year:
            return yearsString
        case .Month:
            return monthsString
        case .Week:
            return weeksString
        case .Day:
            return daysString
        case .None:
            return nil
        }
    }
    
    private func updateLabels() {
        labelOne.font = font
        labelOne.sizeToFit()
        labelTwo.font = font
        labelTwo.sizeToFit()
        labelThree.font = font
        labelThree.sizeToFit()
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
    
    func calculateTotalPickerWidth() {
        // Used to position labels
        
        totalPickerWidth = 0
        totalPickerWidth += labelOne.bounds.width
        totalPickerWidth += labelTwo.bounds.width
        totalPickerWidth += labelThree.bounds.width
        totalPickerWidth += standardComponentSpacing * 2
        totalPickerWidth += extraComponentSpacing * 3
        totalPickerWidth += labelSpacing * 3
        totalPickerWidth += numberWidth * 3
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        
        if let numOfComponents = self.componentsArray?.count {

            switch (numOfComponents) {
            case 1:
                
                labelOne.center = CGPoint(x: CGRectGetMidX(pickerView.frame) + (labelSpacing * 2),
                    y: CGRectGetMidY(pickerView.frame))
                
                labelTwo.hidden = true
                labelThree.hidden = true
                
                break
                
            case 2:
                
                labelOne.center.y = CGRectGetMidY(pickerView.frame)
                labelTwo.center.y = CGRectGetMidY(pickerView.frame)
                
                let pickerMinX = CGRectGetMidX(bounds) - totalPickerWidth / 2
                labelOne.frame.origin.x = pickerMinX + (numberWidth * 3) + (labelSpacing * 2) + extraComponentSpacing
                
                let space = standardComponentSpacing + extraComponentSpacing + (labelSpacing * 5)
                labelTwo.frame.origin.x = CGRectGetMaxX(labelOne.frame) + space
                
                labelThree.hidden = true
                
                break
                
            case 3:
                
                labelOne.center.y = CGRectGetMidY(pickerView.frame)
                labelTwo.center.y = CGRectGetMidY(pickerView.frame)
                labelThree.center.y = CGRectGetMidY(pickerView.frame)
                
                let pickerMinX = CGRectGetMidX(bounds) - totalPickerWidth / 2
                labelOne.frame.origin.x = pickerMinX + numberWidth + labelSpacing
                let space = standardComponentSpacing + extraComponentSpacing + numberWidth + labelSpacing
                labelTwo.frame.origin.x = CGRectGetMaxX(labelOne.frame) + space
                labelThree.frame.origin.x = CGRectGetMaxX(labelTwo.frame) + space
                
                break
                
            default:
                break
            }
        }
        
    }
    
    // MARK: - Picker view data source
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if let numOfComponents = self.componentsArray?.count {
            return numOfComponents
        }
        
        return 0
        
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Components(rawValue: self.getComponentTypeForPickerComponentPosition(component))! {
        case .Hour:
            return 24
        case .Minute:
            return 60
        case .Second:
            return 60
        case .Year:
            return 100
        case .Month:
            return 12
        case .Week:
            return 52
        case .Day:
            return 365
        default:
            return -1
        }
    }
    
    // MARK: - Picker view delegate
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        let labelWidth: CGFloat
        
        switch (component) {
        case 0:
            labelWidth = labelOne.bounds.width
        case 1:
            labelWidth = labelTwo.bounds.width
        case 2:
            labelWidth = labelThree.bounds.width
        default:
            return 0.0
        }
        
        return numberWidth + labelWidth + labelSpacing + extraComponentSpacing
    }
    
    public func pickerView(pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusingView view: UIView!) -> UIView {
            
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
                newView.addSubview(label)
            }
            
            let label = newView.subviews.first as! UILabel
            label.text = "\(row)"
            
            return newView
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 1 {
            // Change label to singular
            
            switch (component) {
            case 0:
                labelOne.text = self.getSingularTextForPickerComponentPosition(component)
            case 1:
                labelTwo.text = self.getSingularTextForPickerComponentPosition(component)
            case 2:
                labelThree.text = self.getSingularTextForPickerComponentPosition(component)
            default:
                break
            }
            
        } else {
            // Change label to plural
            
            switch (component) {
            case 0:
                labelOne.text = self.getPluralTextForPickerComponentPosition(component)
            case 1:
                labelTwo.text = self.getPluralTextForPickerComponentPosition(component)
            case 2:
                labelThree.text = self.getPluralTextForPickerComponentPosition(component)
            default:
                break
            }
            
        }
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    // MARK: - Helpers
    
    private func getComponentTypeForPickerComponentPosition(componentPostiion: Int) -> Int {
        
        switch (componentPostiion) {
        case 0:
            return self.componentsArray![0].rawValue
        case 1:
            return self.componentsArray![1].rawValue
        case 2:
            return self.componentsArray![2].rawValue
        default:
            return -1
        }
        
    }
    
    private func createValidComponentsArray() {
        self.componentsArray = [Components]()
        
        if self.componentOne != .None {
            self.componentsArray?.append(self.componentOne)
        }
        
        if self.componentTwo != .None {
            self.componentsArray?.append(self.componentTwo)
        }
        
        if self.componentThree != .None {
            self.componentsArray?.append(self.componentThree)
        }

    }
    
    private func getPluralTextForPickerComponentPosition(componentPosition: Int) -> String {
        
        switch Components(rawValue: self.getComponentTypeForPickerComponentPosition(componentPosition))! {
        case .Hour:
            return hoursString
        case .Minute:
            return minutesString
        case .Second:
            return secondsString
        case .Year:
            return yearsString
        case .Month:
            return monthsString
        case .Week:
            return weeksString
        case .Day:
            return daysString
        case .None:
            return ""
        }
        
    }
    
    private func getSingularTextForPickerComponentPosition(componentPosition: Int) -> String {
        
        switch Components(rawValue: self.getComponentTypeForPickerComponentPosition(componentPosition))! {
        case .Hour:
            return hourString
        case .Minute:
            return minuteString
        case .Second:
            return secondString
        case .Year:
            return yearString
        case .Month:
            return monthString
        case .Week:
            return weekString
        case .Day:
            return dayString
        case .None:
            return ""
        }
        
    }
    
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
    
    // MARK: - Localization
    
    private var hoursString     = "hours"
    private var hourString      = "hour"
    private var minutesString   = "minutes"
    private var minuteString    = "minute"
    private var secondsString   = "seconds"
    private var secondString    = "second"
    private var yearsString     = "years"
    private var yearString      = "year"
    private var monthsString    = "months"
    private var monthString     = "month"
    private var weeksString     = "weeks"
    private var weekString      = "week"
    private var daysString      = "days"
    private var dayString       = "day"
    
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
        
        yearsString = NSLocalizedString("years", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the years component of the picker.")
        
        yearString = NSLocalizedString("year", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the years text.")
        
        monthsString = NSLocalizedString("months", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the months component of the picker.")
        
        monthString = NSLocalizedString("month", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the months text.")
        
        weeksString = NSLocalizedString("weeks", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the weeks component of the picker.")
        
        weekString = NSLocalizedString("week", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the weeks text.")
        
        daysString = NSLocalizedString("days", tableName: tableName, bundle: bundle,
            comment: "The text displayed next to the days component of the picker.")
        
        dayString = NSLocalizedString("day", tableName: tableName, bundle: bundle,
            comment: "A singular alternative for the days text.")
    }
}
