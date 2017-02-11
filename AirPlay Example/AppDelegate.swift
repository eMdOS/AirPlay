//
//  AppDelegate.swift
//  AirPlay Example
//
//  Created by eMdOS on 2/10/17.
//
//

import UIKit
import AirPlay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AirPlay.startMonitoring()
        return true
    }

}

