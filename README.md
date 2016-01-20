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

### Notifications, Properties, Methods

Notification / Property / Method | Description |
--- | --- |
`AirPlayAvailabilityChangedNotification` | Notification sent everytime AirPlay availability changes. |
`isPossible` | Returns `true` or `false` if there are or not available devices for casting via AirPlay. (read-only) |
`isBeingMonitored` | Returns `true` or `false` if AirPlay availability is being monitored or not. (read-only) |
`startMonitoring()` | Starts monitoring AirPlay availability changes |
`stopMonitoring()` | Stops monitoring AirPlay availability changes |


### Start Monitoring

What I use to do is to start monitoring in the `AppDelegate`. It can be implemented anywhere.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    AirPlay.startMonitoring()

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
NSNotificationCenter.defaultCenter().removeObserver(self, name: AirPlayAvailabilityChangedNotification, object: nil)
```

### Fetching `AirPlay` availability status

`AirPlay.isPossible` will return `true` or `false`.

### Example using Protocol Extensions and Constraints

Assuming we have a class called `Player` which extends from `UIViewController`.

`AirPlayCastable` protocol:

```swift
protocol AirPlayCastable: class {
    func airplayDidChangeAvailability(notification: NSNotification)
}
```

`AirPlayCastable` extension and constraint:

```swift
extension AirPlayCastable where Self: Player {
    func registerForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "airplayDidChangeAvailability:", name: AirPlayAvailabilityChangedNotification, object: nil)
    }

    func unregisterForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: AirPlayAvailabilityChangedNotification)
    }
}
```

Then, in `Player` class...

**Registering:**

```swift
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    registerForAirPlayAvailabilityChanges()
}
```

**Unregistering:**

```swift
override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForAirPlayAvailabilityChanges()
}
```

**Listening:**

```swift
extension Player: AirPlayCastable {
    func airplayDidChangeAvailability(notification: NSNotification) {
        // Where 'airplayStatus' is a UILabel
        airplayStatus.text = AirPlay.isPossible ? "Possible" : "Not Possible"
    }
}
```

## Installation

AirPlay is available through [CocoaPods](http://cocoapods.org). To install it, simply add `pod "AirPlay"` to your **podfile**, and run `pod install`.

## Author

[eMdOS](https://twitter.com/_eMdOS_)

## License

AirPlay is available under the MIT license. See the LICENSE file for more info.
