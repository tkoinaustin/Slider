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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Answers.self, Crashlytics.self])
    UINavigationBar.appearance().tintColor = UIColor(named: "smallBlock")

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
