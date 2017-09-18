# AirPlay

[![CI Status](http://img.shields.io/travis/eMdOS/AirPlay.svg?style=flat)](https://travis-ci.org/eMdOS/AirPlay)
[![Version](https://img.shields.io/cocoapods/v/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)
[![License](https://img.shields.io/cocoapods/l/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)
[![Platform](https://img.shields.io/cocoapods/p/AirPlay.svg?style=flat)](http://cocoapods.org/pods/AirPlay)

AirPlay lets users track iOS AirPlay availability and provides extra information about AirPlay connections.

## Development Environment

+ Xcode 9.0 GM (9A235)
+ Swift 4.0 (swiftlang-900.0.65 clang-900.0.37)
+ Carthage 0.25.0
+ CocoaPods 1.3.1

## Support

![iOSSupport](https://img.shields.io/badge/iOS-8.0+-8e8e93.svg)

Currently, this library is a kind of workaround to be able to track **AirPlay availability** observing changes on [`MPVolumeView`](https://developer.apple.com/library/ios/documentation/MediaPlayer/Reference/MPVolumeView_Class/). So, it needs to be tested every new iOS release.

> If there is an Apple TV or other AirPlay-enabled device in range, the route button allows the user to choose it. If there is only one audio output route available, the route button is not displayed.

**PLEASE READ:**

When developers provide workarounds (like I'm doing "to detect" AirPlay's availability) related to private APIs or closed classes (via KVO), Apple uses to stop supporting those properties in order to push developers to stop using them.

Seems like for iOS 10+, Apple stopped supporting `alpha` property from `MPVolumeView`. So, it could results in always having `isAvailable` static property returning `true`; I'm unsure, I need to dig deeper and do a more exaustive QA.

Please let me know if you find any issue.

## Usage

### Notifications, Properties, Methods, Closures

#### Notifications

Notification | Description |
--: | :-- |
`.airplayAvailabilityChangedNotification` | Notification sent everytime AirPlay availability changes. |
`.airplayRouteStatusChangedNotification` | Notification sent everytime AirPlay connection route changes. |

#### Properties

Property | Description |
--: | :-- |
`isAvailable` | RReturns `true` or `false` if there are or not available devices for casting via AirPlay. (read-only) |
`isBeingMonitored` | Returns `true` or `false` if AirPlay availability is being monitored or not. (read-only) |
`isConnected` | Returns `true` or `false` if device is connected or not to a second device via AirPlay. (read-only) |
`connectedDevice` | Returns Device's name if connected, if not, it returns `nil`. (read-only) |

#### Methods

Method | Description |
--: | :-- |
`startMonitoring()` | Starts monitoring AirPlay availability changes. |
`stopMonitoring()` | Stops monitoring AirPlay availability changes. |


#### Closures

Closure | Description |
--: | :-- |
`whenAvailable` | Closure called when is available to cast media via `AirPlay`. |
`whenUnavailable` | Closure called when is not available to cast media via `AirPlay`. |
`whenRouteChanged` | Closure called when route changed. |


### Start Monitoring

What I use to do is to start monitoring in the `AppDelegate`. It can be implemented anywhere.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AirPlay.startMonitoring()
    return true
}
```

### Adding/Removing Observers

To add them:

```swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(<selector>),
    name: .airplayAvailabilityChangedNotification,
    object: nil
)
```

```swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(<selector>),
    name: .airplayRouteStatusChangedNotification,
    object: nil
)
```

To remove them:

```swift
NotificationCenter.default.removeObserver(
    self,
    name: .airplayAvailabilityChangedNotification,
    object: nil
)
```

```swift
NotificationCenter.default.removeObserver(
    self,
    name: .airplayRouteStatusChangedNotification,
    object: nil
)
```

### Using closures

When available:

```swift
AirPlay.whenAvailable = { [weak self] in
    <code>
}
```

When unavailable:

```swift
AirPlay.whenUnavailable = { [weak self] in
    <code>
}
```

When route changed:

```swift
AirPlay.whenRouteChanged = { [weak self] in
    <code>
}
```

### Displaying `AirPlay` availability status

`AirPlay.isAvailable` will return `true` or `false`.

### Displaying `AirPlay` connection status

`AirPlay.isConnected` will return `true` of `false`.

### Displaying connected device name

`AirPlay.connectedDevice ?? "Unknown Device"`

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

> CocoaPods 1.2.0 is required to guarantee `AirPlay v3.0.0+` will build.

To integrate **AirPlay** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AirPlay', '~> 3.0.0'
```

Then, run the following command:

```
$ pod install
```

### Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```
$ brew update
$ brew install carthage
```

To integrate **AirPlay** into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "eMdOS/AirPlay" ~> 3.0.0
```

Run `carthage update` to build the framework and drag the built `AirPlay.framework` into your Xcode project.

## Migration from v1.+ to v3.+

*I skipped version 2 just to match with the swift language version.*

### Changed

+ Notifications naming.
	- `.airplayAvailabilityChangedNotification`
	
		... was `AirPlayAvailabilityChangedNotification`.
	- `.airplayRouteStatusChangedNotification`

		... was `AirPlayRouteStatusChangedNotification`.

+ Properties naming.
	- `AirPlay.isAvailable`

		... was `AirPlay.isPossible`.

+ Closures naming.

	- `AirPlay.whenAvailable`

		... was `AirPlay.whenPossible`.
	
	- `AirPlay.whenUnavailable`

		... was `AirPlay. whenNotPossible`.
	
	- `AirPlay.whenRouteChanged`

		... was `AirPlay.whenConnectionChanged`.

## Author

[eMdOS](https://twitter.com/_eMdOS_)

## License

AirPlay is available under the MIT license. See the LICENSE file for more info.
