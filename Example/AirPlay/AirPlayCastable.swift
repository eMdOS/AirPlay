//
//  AirPlayCastable.swift
//  AirPlay
//
//  Created by eMdOS on 1/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AirPlay

@objc protocol AirPlayCastable: class {
    func airplayDidChangeAvailability(_ notification: NSNotification)
    func airplayCurrentRouteDidChange(_ notification: NSNotification)
}

extension AirPlayCastable where Self: UIViewController {
    func registerForAirPlayAvailabilityChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(airplayDidChangeAvailability(_:)), name: .airplayAvailabilityChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayAvailabilityChanges() {
        NotificationCenter.default.removeObserver(self, name: .airplayAvailabilityChangedNotification, object: nil)
    }
    
    func registerForAirPlayRouteChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(airplayCurrentRouteDidChange(_:)), name: .airplayRouteStatusChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayRouteChanges() {
        NotificationCenter.default.removeObserver(self, name: .airplayRouteStatusChangedNotification, object: nil)
    }
}
