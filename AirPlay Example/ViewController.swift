//
//  ViewController.swift
//  AirPlay Example
//
//  Created by eMdOS on 2/10/17.
//
//

import UIKit
import AirPlay

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var airplayAvailabilityStatusLabel: UILabel!
    @IBOutlet fileprivate weak var airplayConnectionStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        AirPlay.whenAvailable = { [weak self] in
            self?.updateUI()
        }

        AirPlay.whenUnavailable = { [weak self] in
            self?.updateUI()
        }

        AirPlay.whenRouteChanged = { [weak self] in
            self?.updateUI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

}

fileprivate extension ViewController {
    func updateUI() {
        airplayAvailabilityStatusLabel.text = "Availability: " + (AirPlay.isAvailable ? "Available" : "Not Available")

        if (AirPlay.isConnected) {
            let connectedDeviceName: String = AirPlay.connectedDevice ?? "Unknown Device"
            airplayConnectionStatusLabel.text = "Connected to: \(connectedDeviceName)"
        } else {
            airplayConnectionStatusLabel.text = "Not Connected"
        }
    }
}
