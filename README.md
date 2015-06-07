# LETimeIntervalPicker

[![CI Status](http://img.shields.io/travis/Ludvig Eriksson/LETimeIntervalPicker.svg?style=flat)](https://travis-ci.org/Ludvig Eriksson/LETimeIntervalPicker)
[![Version](https://img.shields.io/cocoapods/v/LETimeIntervalPicker.svg?style=flat)](http://cocoapods.org/pods/LETimeIntervalPicker)
[![License](https://img.shields.io/cocoapods/l/LETimeIntervalPicker.svg?style=flat)](http://cocoapods.org/pods/LETimeIntervalPicker)
[![Platform](https://img.shields.io/cocoapods/p/LETimeIntervalPicker.svg?style=flat)](http://cocoapods.org/pods/LETimeIntervalPicker)

![Screenshot 1](/Screenshots/1.png?raw=true "Screenshot")

## Usage

LETimeIntervalPicker sends a UIControlEvents.ValueChanged event when the user picks a time interval. Listen for this event (also connectable via storyboards).

To get the time interval, simply use the property timeInterval. If you want the time interval as hours, minutes and seconds, use the property timeIntervalAsHoursMinutesSeconds instead. This is a tuple of (Int, Int, Int).

To set the time interval, also use the property timeInterval. If you want to set the picker's time animated, use the function setTimeIntervalAnimated(timeInterval) instead.

## Customization

You can change the font (both the numbers and labels are changed). Default is a system font of size 17. Note that if the font makes the picker bigger than its containing view it can cause layout problems.

## Localization

Assuming you have added the languages to your project, LETimeIntervalPicker is localized into these languages:

* en (English)
* sv (Swedish)

## Installation

LETimeIntervalPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod "LETimeIntervalPicker"

## Author

Ludvig Eriksson, ludvigeriksson@icloud.com

## License

LETimeIntervalPicker is available under the MIT license. See the LICENSE file for more info.