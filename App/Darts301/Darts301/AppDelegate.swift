//
//  AppDelegate.swift
//  Darts301
//
//  Created by Aly & Friends on 2/19/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import Firebase
import GoogleMobileAds
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: Config.shared.adMobAppId)
        return true
    }
}

