//
//  ViewController.swift
//  AirPlay
//
//  Created by eMdOS on 01/12/2016.
//  Copyright (c) 2016 eMdOS. All rights reserved.
//

import UIKit
import AirPlay

class ViewController: UIViewController {
    
    @IBOutlet private weak var airplayStatus: UILabel!
    @IBOutlet private weak var airplayConnectionStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerForAirPlayAvailabilityChanges()
        registerForAirPlayRouteChanges()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        unregisterForAirPlayAvailabilityChanges()
        unregisterForAirPlayRouteChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI() {
        airplayStatus.text = AirPlay.isPossible ? "Possible" : "Not Possible"
        if AirPlay.isConnected {
            let device = AirPlay.connectedDevice ?? "Unknown Device"
            airplayConnectionStatus.text = "Connected to: \(device)"
        } else {
            airplayConnectionStatus.text = "Not Connected"
        }
    }

}

extension ViewController: AirPlayCastable {
    func airplayDidChangeAvailability(notification: NSNotification) {
        updateUI()
    }
    
    func airplayCurrentRouteDidChange(notification: NSNotification) {
        updateUI()
    }
}
