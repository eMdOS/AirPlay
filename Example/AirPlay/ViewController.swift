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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        airplayStatus.text = AirPlay.isPossible ? "Possible" : "Not Possible"
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
        airplayStatus.text = AirPlay.isPossible ? "Possible" : "Not Possible"
    }
}
