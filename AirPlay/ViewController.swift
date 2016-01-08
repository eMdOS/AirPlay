//
//  ViewController.swift
//  AirPlay
//
//  Created by eMdOS on 1/8/16.
//  Copyright © 2016 NedBlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForAirPlayAvailabilityChanges()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForAirPlayAvailabilityChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AirPlayCastable {
    func airplayDidChangeAvailability(notification: NSNotification) {
        let isAirPlayAvailable = AirPlay.sharedInstance.isAvailable ? "Available" : "Not Available"
        print("AirPlay [\(isAirPlayAvailable)]")
    }
}
