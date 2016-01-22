//
//  AirPlayCastable.swift
//  AirPlay
//
//  Created by eMdOS on 1/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AirPlay

protocol AirPlayCastable: class {
    func airplayDidChangeAvailability(notification: NSNotification)
    func airplayCurrentRouteDidChange(notification: NSNotification)
}

extension AirPlayCastable where Self: UIViewController {
    func registerForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "airplayDidChangeAvailability:", name: AirPlayAvailabilityChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AirPlayAvailabilityChangedNotification, object: nil)
    }
    
    func registerForAirPlayRouteChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "airplayCurrentRouteDidChange:", name: AirPlayRouteStatusChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayRouteChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AirPlayRouteStatusChangedNotification, object: nil)
    }
}
