# LIHLogManager

[![CI Status](http://img.shields.io/travis/Lasith Hettiarachchi/LIHLogManager.svg?style=flat)](https://travis-ci.org/Lasith Hettiarachchi/LIHLogManager)
[![Version](https://img.shields.io/cocoapods/v/LIHLogManager.svg?style=flat)](http://cocoapods.org/pods/LIHLogManager)
[![License](https://img.shields.io/cocoapods/l/LIHLogManager.svg?style=flat)](http://cocoapods.org/pods/LIHLogManager)
[![Platform](https://img.shields.io/cocoapods/p/LIHLogManager.svg?style=flat)](http://cocoapods.org/pods/LIHLogManager)

## Usage
```Swift
import LIHLogManager
```
####Add a record to log
```Swift
LIHLogManager.addToLog(message, title: title)
```
####Get all records
```Swift
LIHLogManager.addToLog(message, title: title)
```
####Clear log
This will delete all the records.
```Swift
LIHLogManager.clearLog()
```
####Get most recent 200 records
```Swift
LIHLogManager.getRecords(200)
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 7+

## Installation

LIHLogManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LIHLogManager"
```

## Author

Lasith Hettiarachchi, lasithih@yahoo.com

## License

LIHLogManager is available under the MIT license. See the LICENSE file for more info.
