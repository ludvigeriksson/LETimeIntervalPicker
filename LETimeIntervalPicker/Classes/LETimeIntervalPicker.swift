//
//  LETimeIntervalPicker.swift
//  LETimeIntervalPicker
//
//  Created by Ludvig Eriksson on 2017-05-03.
//  Copyright (c) 2017 Ludvig Eriksson. All rights reserved.
//

import UIKit

@IBDesignable public class LETimeIntervalPicker: UIControl {
    
    // MARK: - Enums & constants
    
    /// LETimeIntervalPicker.Component represent the different types of
    /// components that can be displayed in the picker.
    ///
    /// - days: 86400 seconds
    /// - hours: 3600 seconds
    /// - minutes: 60 seconds
    /// - seconds: 1 second
    public enum Component: String {
        case days
        case hours
        case minutes
        case seconds
    }
    
    public enum UnitsStyle: String {
        case full
        case short
        case abbreviated
    }
    
    fileprivate struct Constants {
        static let standardComponentSpacing: CGFloat = 5   // UIPickerView has a 5 point space between components
        static let labelSpacing: CGFloat = 5               // Spacing between picker numbers and labels
        
        static let componentValues: [Component: TimeInterval] = [
            .days: 86_400,
            .hours: 3_600,
            .minutes: 60,
            .seconds: 1
        ]
    }
    
    // MARK: - UI Elements
    
    fileprivate var pickerView = UIPickerView()
    fileprivate var labels: [UILabel] = []
    
    // MARK: - Public API -
    
    // MARK: Getting & setting the time interval
    
    public var timeInterval: TimeInterval {
        get {
            return getTimeInterval()
        }
        set {
            setTimeInterval(timeInterval: newValue, animated: false)
        }
    }
    
    public func setTimeIntervalAnimated(_ timeInterval: TimeInterval) {
        setTimeInterval(timeInterval: timeInterval, animated: true)
    }
    
    public func timeIntervalAsComponents() -> [Component: Int] {
        var timeInterval: [Component: Int] = [:]
        for (index, component) in components.enumerated() {
            timeInterval[component] = pickerView.selectedRow(inComponent: index)
        }
        return timeInterval
    }
    
    // MARK: Customizing functionality & appearance
    
    public var components: [Component] = [.hours, .minutes, .seconds] {
        didSet {
            reloadData()
        }
    }
    
    public func set(numberOfRows: Int, for component: Component) {
        self.numberOfRows[component] = numberOfRows
        reloadData()
    }

    public var numberFont = UIFont.systemFont(ofSize: 17) { didSet { reloadData() } }
    
    public var textFont = UIFont.systemFont(ofSize: 17) { didSet { reloadData() } }
    
    public var unitsStyle = UnitsStyle.full

    // MARK: Reloading
    
    public func reloadData() {
        calculateNumberWidths()
        pickerView.reloadAllComponents()
        updateTextLabels()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Helpers
    
    private func getTimeInterval() -> TimeInterval {
        var total: TimeInterval = 0
        for (index, component) in components.enumerated() {
            let selected = pickerView.selectedRow(inComponent: index)
            total += Constants.componentValues[component]! * TimeInterval(selected)
        }
        return total
    }
    
    private func setTimeInterval(timeInterval: TimeInterval, animated: Bool) {
        let sortedComponents = components.sorted {
            Constants.componentValues[$0]! > Constants.componentValues[$1]!
        }
        var timeLeft = timeInterval
        for component in sortedComponents {
            var componentCount = 0
            while timeLeft >= Constants.componentValues[component]! {
                componentCount += 1
                timeLeft -= Constants.componentValues[component]!
            }
            if componentCount > numberOfRows[component]! {
                print("LETimeIntervalPicker WARNING: " +
                    "Not enough rows to display the specified time interval " +
                    "(requires \(componentCount) rows for component '\(component.rawValue)', " +
                    "but specified maximum is \(numberOfRows[component]!))"
                )
            }
            let index = components.index(of: component)!
            pickerView.selectRow(componentCount, inComponent: index, animated: animated)
        }
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Layout calculations
    
    fileprivate var numberOfRows: [Component: Int] = [
        .days: 365,
        .hours: 24,
        .minutes: 60,
        .seconds: 60
    ]
    
    fileprivate var numberWidths: [Component: CGFloat] = [:]
    
    /// Calculates the widest label width for all number labels
    /// and stores it in numberWidths
    fileprivate func calculateNumberWidths() {
        for component in components {
            let label = UILabel()
            label.font = numberFont
            for i in 0..<numberOfRows[component]! {
                label.text = "\(i)"
                label.sizeToFit()
                if label.bounds.width > numberWidths[component] ?? 0 {
                    numberWidths[component] = label.bounds.width
                }
            }
        }
    }
    
    
    /// Calculates the total width of the contents of the picker,
    /// including numbers, component labels and spacing in between
    ///
    /// - Returns: The calculated width
    fileprivate func calculateTotalWidth() -> CGFloat {
        var totalWidth: CGFloat = 0
        for (index, component) in components.enumerated() {
            totalWidth += numberWidths[component]!
            let label = labels[index]
            totalWidth += label.bounds.width
        }
        totalWidth += Constants.standardComponentSpacing * CGFloat(components.count - 1)
        totalWidth += Constants.labelSpacing * CGFloat(components.count)
        return totalWidth
    }
    
    
    /// Positions the labels in the correct position
    fileprivate func positionLabels() {
        let totalWidth = calculateTotalWidth()
        
        var current = bounds.midX - totalWidth / 2
        for (index, component) in components.enumerated() {
            current += numberWidths[component]!
            current += Constants.labelSpacing
            let label = labels[index]
            label.frame.origin.x = current
            label.frame.origin.y = bounds.midY - label.bounds.midY
            current += label.bounds.width
            current += Constants.standardComponentSpacing
        }
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        positionLabels()
    }
    
    // MARK: - Localization
    
    fileprivate func title(for component: Component, count: Int) -> String {
        var key = component.rawValue + "-" + unitsStyle.rawValue
        switch count {
        case 1:
            key += "-singular"
        default:
            key += "-plural"
        }
        let bundle = Bundle(for: LETimeIntervalPicker.self)
        let tableName = "LETimeIntervalPickerLocalizable"
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
    }
    
    fileprivate func updateTextLabels() {
        labels.forEach { $0.removeFromSuperview() }
        for (index, component) in components.enumerated() {
            
            // Get an unused label or create a new one
            var label: UILabel
            if index < labels.count {
                label = labels[index]
            } else {
                label = UILabel()
                labels.append(label)
            }
            addSubview(label)
            
            // Update the label
            #if TARGET_INTERFACE_BUILDER
                // Interface builder will crash otherwise
                let count = 0
            #else
                let count = pickerView.selectedRow(inComponent: index)
            #endif
            label.text = title(for: component, count: count)
            label.font = textFont
            label.sizeToFit()
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        updateTextLabels()
        setupPickerView()
        reloadData()
    }
    
    fileprivate func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        pickerView.fillSuperview()
    }
    
}

extension LETimeIntervalPicker: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRows[components[component]]!
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let size = pickerView.rowSize(forComponent: component)
        
        var newView = view
        if newView == nil {
            newView = UIView(frame: CGRect(origin: .zero, size: size))
            let label = UILabel()
            newView!.addSubview(label)
            label.textAlignment = .right
        }
        let label = newView!.subviews.first as! UILabel
        label.font = numberFont
        label.frame.size.height = size.height
        label.frame.size.width = numberWidths[components[component]]!
        label.text = "\(row)"
        
        return newView!
    }
}

extension LETimeIntervalPicker: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let label = labels[component]
        let component = components[component]
        let numberWidth = numberWidths[component]!
        let totalWidth = numberWidth + label.bounds.width + Constants.labelSpacing
        return totalWidth
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendActions(for: .valueChanged)
    }
}

extension UIView {
    func fillSuperview() {
        let attributes: [NSLayoutAttribute] = [.top, .bottom, .leading, .trailing]
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
            superview?.addConstraint(constraint)
        }
    }
}
