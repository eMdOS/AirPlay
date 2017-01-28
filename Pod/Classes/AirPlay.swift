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

public extension Notification.Name {

    /// Notification sent everytime AirPlay availability changes.
    static let airplayAvailabilityChangedNotification = Notification.Name("AirPlayAvailabilityChangedNotification")

    /// Notification sent everytime AirPlay connection route changes.
    static let airplayRouteStatusChangedNotification = Notification.Name("AirPlayRouteChangedNotification")
}

final public class AirPlay: NSObject {
    
    public typealias AirPlayPossible = (_ airplay: AirPlay) -> Void
    public typealias AirPlayConnectionChanged = (_ airplay: AirPlay) -> Void
    
    // MARK: Porperties
    
    fileprivate var window: UIWindow?
    fileprivate let volumeView: MPVolumeView!
    fileprivate var airplayButton: UIButton?
    
    /// Returns true | false if there are or not available devices for casting via AirPlay.
    fileprivate var isPossible = false
    
    /// Returns true | false if AirPlay availability is being monitored or not.
    fileprivate var isBeingMonitored = false
    
    /// Returns Device's name if connected, if not, it return 'nil'.
    fileprivate var connectedDevice: String? {
        didSet {
            postCurrentRouteChangedNotification()
        }
    }
    
    fileprivate var _whenPossible: AirPlayPossible?
    fileprivate var _whenNotPossible: AirPlayPossible?
    fileprivate var _whenConnectionChanged: AirPlayConnectionChanged?
    
    // MARK: Singleton
    
    /// Singleton
    fileprivate static let sharedInstance = AirPlay()
    /// Private Initializer (because of Singleton pattern)
    fileprivate override init() {
        volumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 1, height: 1))
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true
    }
    
    // MARK: Methods
    
    final fileprivate func start() {
        guard let delegate = UIApplication.shared.delegate, let _window = delegate.window else { return }
        window = _window
        
        window?.addSubview(volumeView)
        for view in volumeView.subviews {
            if view is UIButton {
                airplayButton = view as? UIButton
                airplayButton?.addObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey, options: [.initial, .new], context: nil)
                
                isBeingMonitored = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AirPlay.audioRouteHasChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
    }
    
    final fileprivate func stop() {
        airplayButton?.removeObserver(self, forKeyPath: AirPlayKVOButtonAlphaKey)
        isBeingMonitored = false
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
    }
    
    final fileprivate func getConnectedDevice() -> String? {
        return AVAudioSession.sharedInstance().currentRoute.outputs.filter { $0.portType == AVAudioSessionPortAirPlay }.first?.portName
    }
    
    @objc fileprivate func audioRouteHasChanged(_ notification: Notification) {
        connectedDevice = getConnectedDevice()
    }
    
}

// MARK: - AirPlay KVO

private let AirPlayKVOButtonAlphaKey = "alpha"

extension AirPlay {
    final override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == AirPlayKVOButtonAlphaKey {
            guard let object = object else { return }
            guard object is UIButton else { return }

            var newAvailabilityStatus: Bool

            if let newAvailabilityStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
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
    fileprivate func postAvailabilityChangedNotification() {
        DispatchQueue.main.async { [unowned self] () -> Void in
            NotificationCenter.default.post(name: .airplayAvailabilityChangedNotification, object: self)
            
            if self.isPossible {
                if let whenPossible = self._whenPossible {
                    whenPossible(self)
                }
            } else {
                if let whenNotPossible = self._whenNotPossible {
                    whenNotPossible(self)
                }
            }
        }
    }
    
    fileprivate func postCurrentRouteChangedNotification() {
        DispatchQueue.main.async { [unowned self] () -> Void in
            NotificationCenter.default.post(name: .airplayRouteStatusChangedNotification, object: self)
            
            if let whenConnectionChanged = self._whenConnectionChanged {
                whenConnectionChanged(self)
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
