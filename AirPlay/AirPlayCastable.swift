//
//  AirPlayCastable.swift
//  AirPlay
//
//  Created by eMdOS on 1/8/16.
//  Copyright © 2016 NedBlu. All rights reserved.
//

import Foundation
import UIKit

protocol AirPlayCastable: class {
    func airplayDidChangeAvailability(notification: NSNotification)
}

extension AirPlayCastable where Self: UIViewController {
    func registerForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "airplayDidChangeAvailability:", name: AirPlayAvailabilityChangedNotification, object: nil)
    }
    
    func unregisterForAirPlayAvailabilityChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: AirPlayAvailabilityChangedNotification)
    }
}
