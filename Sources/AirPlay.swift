//
//  AirPlay.swift
//  AirPlay
//
//  Created by eMdOS on 1/12/16.
//
//

import Foundation
import MediaPlayer
import AVFoundation

public extension Notification.Name {
    /// Notification sent everytime AirPlay availability changes.
    public static let airplayAvailabilityChangedNotification = Notification.Name("AirPlayAvailabilityChangedNotification")

    /// Notification sent everytime AirPlay connection route changes.
    public static let airplayRouteStatusChangedNotification = Notification.Name("AirPlayRouteChangedNotification")
}

final public class AirPlay: NSObject {

    public typealias AirPlayHandler = () -> Void

    // MARK: Properties

    fileprivate var window: UIWindow?
    fileprivate let volumeView: MPVolumeView
    fileprivate var airplayButton: UIButton?

    /// Returns `true` | `false` if there are or not available devices for casting via AirPlay.
    fileprivate var isAvailable = false

    /// Returns `true` | `false` if AirPlay availability is being monitored or not.
    fileprivate var isBeingMonitored = false

    /// Returns Device's name if connected, if not, it returns `nil`.
    fileprivate var connectedDevice: String? {
        didSet {
            postCurrentRouteChangedNotification()
        }
    }

    fileprivate var whenAvailable: AirPlayHandler?
    fileprivate var whenUnavailable: AirPlayHandler?
    fileprivate var whenRouteChanged: AirPlayHandler?

    // MARK: Singleton

    /// Singleton
    fileprivate static let shared = AirPlay()

    /// Private Initializer (because of Singleton pattern)
    fileprivate override init() {
        volumeView = MPVolumeView(
            frame: CGRect(
                x: -1000,
                y: -1000,
                width: 1,
                height: 1
            )
        )
        volumeView.showsVolumeSlider = false
        volumeView.showsRouteButton = true
    }

    // MARK: Methods

    fileprivate func start() {
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window else { return }

        self.window = window

        self.window?.addSubview(volumeView)

        for view in volumeView.subviews {
            if (view is UIButton) {
                airplayButton = view as? UIButton

                airplayButton?.addObserver(
                    self,
                    forKeyPath: AirPlayKVOButtonAlphaKey,
                    options: [.initial, .new],
                    context: nil
                )

                isBeingMonitored = true
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: .audioRouteHasChanged,
            name: .AVAudioSessionRouteChange,
            object: AVAudioSession.sharedInstance()
        )
    }

    fileprivate func stop() {
        airplayButton?.removeObserver(
            self,
            forKeyPath: AirPlayKVOButtonAlphaKey
        )

        isBeingMonitored = false
        isAvailable = false
        NotificationCenter.default.removeObserver(
            self,
            name: .AVAudioSessionRouteChange,
            object: AVAudioSession.sharedInstance()
        )
    }

    fileprivate func getConnectedDevice() -> String? {
        return AVAudioSession.sharedInstance().currentRoute.outputs.filter {
            $0.portType == AVAudioSessionPortAirPlay
        }.first?.portName
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
            guard let object = object, (object is UIButton) else { return }

            var newAvailabilityStatus: Bool

            if let newAvailabilityStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newAvailabilityStatus = (newAvailabilityStatusAsNumber.floatValue == 1)
            } else {
                newAvailabilityStatus = false
            }

            if (isAvailable != newAvailabilityStatus) {
                isAvailable = newAvailabilityStatus
                postAvailabilityChangedNotification()
            }

            isAvailable = newAvailabilityStatus
        }
    }
}

// MARK: - Notifications

extension AirPlay {
    fileprivate func postAvailabilityChangedNotification() {
        DispatchQueue.main.async { [weak self] () -> Void in
            guard let `self` = self else { return }

            NotificationCenter.default.post(name: .airplayAvailabilityChangedNotification, object: self)

            if let whenAvailable = self.whenAvailable, (self.isAvailable) {
                whenAvailable()
            } else if let whenUnavailable = self.whenUnavailable {
                whenUnavailable()
            }
        }
    }

    fileprivate func postCurrentRouteChangedNotification() {
        DispatchQueue.main.async { [unowned self] () -> Void in
            NotificationCenter.default.post(name: .airplayRouteStatusChangedNotification, object: self)

            if let whenRouteChanged = self.whenRouteChanged {
                whenRouteChanged()
            }
        }
    }
}

// MARK: - Availability / Connectivity

extension AirPlay {
    /// Returns `true` or `false` if there are or not available devices for casting via AirPlay. (read-only)
    public static var isAvailable: Bool {
        return AirPlay.shared.isAvailable
    }

    /// Returns `true` or `false` if AirPlay availability is being monitored or not. (read-only)
    public static var isBeingMonitored: Bool {
        return AirPlay.shared.isBeingMonitored
    }

    /// Returns `true` or `false` if device is connected or not to a second device via AirPlay. (read-only)
    public static var isConnected: Bool {
        return AVAudioSession.sharedInstance().currentRoute.outputs.filter {
            $0.portType == AVAudioSessionPortAirPlay
        }.count >= 1
    }

    /// Returns Device's name if connected, if not, it returns `nil`. (read-only)
    public static var connectedDevice: String? {
        return AirPlay.shared.connectedDevice
    }
}

// MARK: - Monitoring

extension AirPlay {
    /// Starts monitoring AirPlay availability changes.
    public static func startMonitoring() {
        AirPlay.shared.start()
    }

    /// Stops monitoring AirPlay availability changes.
    public static func stopMonitoring() {
        AirPlay.shared.stop()
    }
}

// MARK: - Closures

extension AirPlay {
    /// Closure called when is available to cast media via `AirPlay`.
    public static var whenAvailable: AirPlayHandler? {
        didSet {
            AirPlay.shared.whenAvailable = whenAvailable
        }
    }

    /// Closure called when is not available to cast media via `AirPlay`.
    public static var whenUnavailable: AirPlayHandler? {
        didSet {
            AirPlay.shared.whenUnavailable = whenUnavailable
        }
    }

    /// Closure called when route changed.
    public static var whenRouteChanged: AirPlayHandler? {
        didSet {
            AirPlay.shared.whenRouteChanged = whenRouteChanged
        }
    }
}

// MARK: - (Private) Selector

fileprivate extension Selector {
    static let audioRouteHasChanged: Selector = #selector(AirPlay.audioRouteHasChanged(_:))
}

