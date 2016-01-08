# AirPlay

This library is completly written in **Swift**. It is based on [`AirPlayDetector`](https://github.com/StevePotter/AirPlayDetector).

## Support

+ iOS 8 & 9

Actually, this library is kind of workaround to be able to track **AirPlay availability** observing changes on [`MPVolumeView`](https://developer.apple.com/library/ios/documentation/MediaPlayer/Reference/MPVolumeView_Class/).

> If there is an Apple TV or other AirPlay-enabled device in range, the route button allows the user to choose it. If there is only one audio output route available, the route button is not displayed.

## How it works?

**AirPlay** is a *singleton*. So, to call it use `AirPlay.sharedInstance.isAvailable`.

Everytime AirPlay status changes, it is posting a notification with name `AirPlayAvailabilityChangedNotification`.

### Start Monitoring

What I use to do is to start monitoring in the `AppDelegate`.

```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    if let window = window {
        AirPlay.sharedInstance.startMonitoring(window)
    }
    return true
}
```

### Adding/Removing Observers

+ To add them:
```
NSNotificationCenter.defaultCenter().addObserver(self, selector: "<selector>", name: AirPlayAvailabilityChangedNotification, object: nil)
```
+ To remove them:
```
NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: AirPlayAvailabilityChangedNotification)
```

## Example (using Protocol Extensions and Protocol Constraints)

For better code organization, I love to use `Protocol Extension` and `Protocol Constraints`.

What I use to do is to create a `Protocol`:

```
protocol AirPlayCastable: class {
    func airplayDidChangeAvailability(notification: NSNotification)
}
```

and its `Extension` and `Constraint`:

```
extension AirPlayCastable where Self: UIViewController {
    func registerForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "airplayDidChangeAvailability:", name: AirPlayAvailabilityChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: AirPlayAvailabilityChangedNotification)
    }
}
```

So, if I want to track **AirPlay** availability changes in an specific `ViewController`, the only thing what I need to do is to implement the `AirPlayCastable` protocol.

```
extension ViewController: AirPlayCastable {
    func airplayDidChangeAvailability(notification: NSNotification) {
        let isAirPlayAvailable = AirPlay.sharedInstance.isAvailable ? "Available" : "Not Available"
        print("AirPlay [\(isAirPlayAvailable)]")
    }
}
```

and register/unregister the `ViewController`:

```
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    registerForAirPlayAvailabilityChanges()
}
    
override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForAirPlayAvailabilityChanges()
}
```

## Installation
### CocoaPods
1. Update your Podfile to include the following:

  ```
  use_frameworks!
  pod 'AirPlay', :git => 'https://github.com/eMdOS/AirPlay.git'
  ```

2. Run `pod install`

