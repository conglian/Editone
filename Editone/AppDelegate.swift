//
//  AppDelegate.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 16/03/2026.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        EoLaunchLoadingManger.share.startRun()
        return true
    }


}

