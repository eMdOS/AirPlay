# AirPlay

[![CI Status](http://img.shields.io/travis/eMdOS/AirPlay.svg?style=flat)](https://travis-ci.org/eMdOS/AirPlay)
[![Version](https://img.shields.io/cocoapods/v/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)
[![License](https://img.shields.io/cocoapods/l/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)
[![Platform](https://img.shields.io/cocoapods/p/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)

AirPlay lets users track iOS AirPlay availability.

## Requirements

+ Xcode 7+
+ iOS 8+
+ CocoaPods 0.39.0

![XcodeVersion](https://img.shields.io/badge/Xcode-v7.2-0b8bf7.svg)
![Swift](https://img.shields.io/badge/Swift-2.1-fd9e39.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-0.39.0-e74c3c.svg)

## Support

![iOSSupport](https://img.shields.io/badge/iOS-8.0+-8e8e93.svg)

Currently, this library is a kind of workaround to be able to track **AirPlay availability** observing changes on [`MPVolumeView`](https://developer.apple.com/library/ios/documentation/MediaPlayer/Reference/MPVolumeView_Class/). So, it needs to be tested every new iOS realease.

> If there is an Apple TV or other AirPlay-enabled device in range, the route button allows the user to choose it. If there is only one audio output route available, the route button is not displayed.

## Usage

### Start Monitoring

What I use to do is to start monitoring in the `AppDelegate`.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    if let window = window {
        AirPlay.sharedInstance.startMonitoring(window)
    }
    return true
}
```

### Adding/Removing Observers

To add them:

```swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: "<selector>", name: AirPlayAvailabilityChangedNotification, object: nil)
```

To remove them:

```swift
NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: AirPlayAvailabilityChangedNotification)
```

### Fetching `AirPlay` availability status

`AirPlay.sharedInstance.isPossible` will return `true` or `false`.

### Example

Just take a look at [Example using Protocol Extension and Constraint](https://github.com/eMdOS/AirPlay/wiki/Usage-Example#using-protocol-extension-and-constraint).

## Installation

AirPlay is available through [CocoaPods](http://cocoapods.org). To install it, simply add `pod "AirPlay"` to your **podfile**, and run `pod install`.

## Author

eMdOS, emilio.ojeda.mendoza@gmail.com

## License

AirPlay is available under the MIT license. See the LICENSE file for more info.
