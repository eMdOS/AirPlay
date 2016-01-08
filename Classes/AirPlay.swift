//
//  AirPlay.swift
//  Player
//
//  Created by eMdOS on 1/7/16.
//  Copyright © 2016 NedBlu. All rights reserved.
//

import Foundation
import MediaPlayer

/// Notification sent with the status updates for AirPlay availability.
public let AirPlayAvailabilityChangedNotification = "AirPlayAvailabilityChangedNotification"

public final class AirPlay: NSObject {

    // MARK: Porperties
    
    private let volumeView: MPVolumeView!
    private var airplayButton: UIButton?
    /// Returns true | false if there are or not available devices for casting via AirPlay.
    private (set) var isAvailable = false
    
    // MARK: Singleton
    /// Singleton
    public static let sharedInstance = AirPlay()
    /// Private Initializer (because of Singleton pattern)
    private override init() {
        volumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 1, height: 1))
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true
    }
    
    // MARK: Methods
    /**
    AirPlay button needs to be visible to be able to check its availability. So, is needed a Window. As suggestion, please use `AppDelegate` window.
    
    - parameter window: Windows which will be tracking AirPlay availability.
    */
    public func startMonitoring(window: UIWindow) {
        window.addSubview(volumeView)
        for view in volumeView.subviews {
            if view is UIButton {
                airplayButton = view as? UIButton
                airplayButton?.addObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey, options: [.Initial, .New], context: nil)
            }
        }
    }
    
    /**
     Removes the observer of AirPlay availability.
     */
    public func stopMonitoring() {
        airplayButton?.removeObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey)
    }

}

// MARK:- AirPlay KVO

private let AirPlayKVOButtonAlphaKey = "alpha"

extension AirPlay {
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let object = object else { return }
        guard object is UIButton else { return }
        
        var newAvailabilityStatus: Bool
        
        if let newAvailabilityStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
            newAvailabilityStatus = newAvailabilityStatusAsNumber.floatValue == 1
        } else {
            newAvailabilityStatus = false
        }
        
        if isAvailable != newAvailabilityStatus {
            isAvailable = newAvailabilityStatus
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName(AirPlayAvailabilityChangedNotification, object: self)
            }
        }
        
        isAvailable = newAvailabilityStatus
    }
}
