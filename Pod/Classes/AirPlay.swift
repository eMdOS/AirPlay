//
//  AirPlay.swift
//  Pods
//
//  Created by eMdOS on 1/12/16.
//
//

import Foundation
import MediaPlayer
import AVFoundation

/// Notification sent everytime AirPlay availability changes.
public let AirPlayAvailabilityChangedNotification = "AirPlayAvailabilityChangedNotification"

/// Notification sent everytime AirPlay connection route changes.
public let AirPlayRouteStatusChangedNotification = "AirPlayRouteChangedNotification"

final public class AirPlay: NSObject {
    
    public typealias AirPlayPossible = (airplay: AirPlay) -> Void
    public typealias AirPlayConnectionChanged = (airplay: AirPlay) -> Void
    
    // MARK: Porperties
    
    private var window: UIWindow?
    private let volumeView: MPVolumeView!
    private var airplayButton: UIButton?
    
    /// Returns true | false if there are or not available devices for casting via AirPlay.
    private var isPossible = false
    
    /// Returns true | false if AirPlay availability is being monitored or not.
    private var isBeingMonitored = false
    
    /// Returns Device's name if connected, if not, it return 'nil'.
    private var connectedDevice: String? {
        didSet {
            postCurrentRouteChangedNotification()
        }
    }
    
    private var _whenPossible: AirPlayPossible?
    private var _whenNotPossible: AirPlayPossible?
    private var _whenConnectionChanged: AirPlayConnectionChanged?
    
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
    
    final private func start() {
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioRouteHasChanged:", name: AVAudioSessionRouteChangeNotification, object: AVAudioSession.sharedInstance())
    }
    
    final private func stop() {
        airplayButton?.removeObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey)
        isBeingMonitored = false
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionRouteChangeNotification, object: AVAudioSession.sharedInstance())
    }
    
    final private func getConnectedDevice() -> String? {
        return AVAudioSession.sharedInstance().currentRoute.outputs.filter { $0.portType == AVAudioSessionPortAirPlay }.first?.portName
    }
    
    @objc private func audioRouteHasChanged(notification: NSNotification) {
        connectedDevice = getConnectedDevice()
    }
    
}

// MARK: - AirPlay KVO

private let AirPlayKVOButtonAlphaKey = "alpha"

extension AirPlay {
    final override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == AirPlayKVOButtonAlphaKey {
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
                postAvailabilityChangedNotification()
            }
            
            isPossible = newAvailabilityStatus
        }
    }
}

// MARK: - Notifications
extension AirPlay {
    private func postAvailabilityChangedNotification() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(AirPlayAvailabilityChangedNotification, object: self)
            
            if self.isPossible {
                if let whenPossible = self._whenPossible {
                    whenPossible(airplay: self)
                }
            } else {
                if let whenNotPossible = self._whenNotPossible {
                    whenNotPossible(airplay: self)
                }
            }
        }
    }
    
    private func postCurrentRouteChangedNotification() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(AirPlayRouteStatusChangedNotification, object: self)
            
            if let whenConnectionChanged = self._whenConnectionChanged {
                whenConnectionChanged(airplay: self)
            }
        }
    }
}

// MARK: - Availability / Connectivity
extension AirPlay {
    /// Returns `true` or `false` if there are or not available devices for casting via AirPlay. (read-only)
    final public class var isPossible: Bool {
        return AirPlay.sharedInstance.isPossible
    }
    
    /// Returns `true` or `false` if AirPlay availability is being monitored or not. (read-only)
    final public class var isBeingMonitored: Bool {
        return AirPlay.sharedInstance.isBeingMonitored
    }
    
    /// Returns `true` or `false` if device is connected or not to a second device via AirPlay. (read-only)
    final public class var isConnected: Bool {
        return AVAudioSession.sharedInstance().currentRoute.outputs.filter { $0.portType == AVAudioSessionPortAirPlay }.count >= 1
    }
    
    /// Returns Device's name if connected, if not, it returns `nil`. (read-only)
    final public class var connectedDevice: String? {
        return AirPlay.sharedInstance.connectedDevice
    }
}

// MARK: - Monitoring
extension AirPlay {
    /**
     Starts monitoring AirPlay availability changes.
     */
    public static func startMonitoring() {
        AirPlay.sharedInstance.start()
    }
    
    /**
     Stops monitoring AirPlay availability changes.
     */
    public static func stopMonitoring() {
        AirPlay.sharedInstance.stop()
    }
}

// MARK:- Closures
extension AirPlay {
    public static var whenPossible: AirPlayPossible? {
        didSet {
            AirPlay.sharedInstance._whenPossible = whenPossible
        }
    }
    
    public static var whenNotPossible: AirPlayPossible? {
        didSet {
            AirPlay.sharedInstance._whenNotPossible = whenNotPossible
        }
    }
    
    public static var whenConnectionChanged: AirPlayConnectionChanged? {
        didSet {
            AirPlay.sharedInstance._whenConnectionChanged = whenConnectionChanged
        }
    }
}
