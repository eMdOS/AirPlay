//
//  AirPlay.swift
//  Pods
//
//  Created by eMdOS on 1/12/16.
//
//

import Foundation
import MediaPlayer

/// Notification sent everytime AirPlay availability changes.
public let AirPlayAvailabilityChangedNotification = "AirPlayAvailabilityChangedNotification"

final public class AirPlay: NSObject {
    
    // MARK: Porperties
    
    private var window: UIWindow?
    private let volumeView: MPVolumeView!
    private var airplayButton: UIButton?
    
    /// Returns true | false if there are or not available devices for casting via AirPlay.
    private var isPossible = false
    
    /// Returns true | false if AirPlay availability is being monitored or not.
    private var isBeingMonitored = false
    
    // MARK: Singleton
    
    /// Singleton
    private static let sharedInstance = AirPlay()
    /// Private Initializer (because of Singleton pattern)
    private override init() {
        volumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 1, height: 1))
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true
    }
    
    // MARK: Methods
    
    final private func _startMonitoring() {
        guard let delegate = UIApplication.sharedApplication().delegate, _window = delegate.window else { return }
        window = _window
        
        window?.addSubview(volumeView)
        for view in volumeView.subviews {
            if view is UIButton {
                airplayButton = view as? UIButton
                airplayButton?.addObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey, options: [.Initial, .New], context: nil)
                
                isBeingMonitored = true
            }
        }
    }
    
    final private func _stopMonitoring() {
        airplayButton?.removeObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey)
        isBeingMonitored = false
    }
    
}

// MARK: - AirPlay KVO

private let AirPlayKVOButtonAlphaKey = "alpha"

extension AirPlay {
    final override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let object = object else { return }
        guard object is UIButton else { return }
        
        var newAvailabilityStatus: Bool
        
        if let newAvailabilityStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
            newAvailabilityStatus = newAvailabilityStatusAsNumber.floatValue == 1
        } else {
            newAvailabilityStatus = false
        }
        
        if isPossible != newAvailabilityStatus {
            isPossible = newAvailabilityStatus
            postAvailabilityChangeNotification()
        }
        
        isPossible = newAvailabilityStatus
    }
}

// MARK: - Notifications
extension AirPlay {
    private func postAvailabilityChangeNotification() {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(AirPlayAvailabilityChangedNotification, object: self)
        }
    }
}

// MARK: - Availability
extension AirPlay {
    /// Returns `true` or `false` if there are or not available devices for casting via AirPlay. (read-only)
    final public class var isPossible: Bool {
        return AirPlay.sharedInstance.isPossible
    }
    
    /// Returns `true` or `false` if AirPlay availability is being monitored or not. (read-only)
    final public class var isBeingMonitored: Bool {
        return AirPlay.sharedInstance.isBeingMonitored
    }
}

// MARK: - Monitoring
extension AirPlay {
    /**
     Starts monitoring AirPlay availability changes.
     */
    public static func startMonitoring() {
        AirPlay.sharedInstance._startMonitoring()
    }
    
    /**
     Stops monitoring AirPlay availability changes.
     */
    public static func stopMonitoring() {
        AirPlay.sharedInstance._stopMonitoring()
    }
}
