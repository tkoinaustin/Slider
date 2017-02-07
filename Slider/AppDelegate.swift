//
//  AppDelegate.swift
//  Slider
//
//  Created by Mac Daddy on 9/24/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [
    UIApplicationLaunchOptionsKey: Any
    ]?
    ) -> Bool {
//    Fabric.with([Crashlytics.self])
    GADMobileAds.configure(withApplicationID: "ca-app-pub-8254175664355700~3835606073")
    Gratuity.store.retrieveProducts { _, _ in }
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
}
