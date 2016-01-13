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
    
    private let airplay = AirPlay.sharedInstance
    
    @IBOutlet private weak var airplayStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let isAirPlayPossible = airplay.isPossible ? "Possible" : "Not Possible"
        airplayStatus.text = isAirPlayPossible
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
        let isAirPlayPossible = AirPlay.sharedInstance.isPossible ? "Possible" : "Not Possible"
        airplayStatus.text = isAirPlayPossible
    }
}
