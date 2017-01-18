//
//  BannerAdView.swift
//  Slider
//
//  Created by Tom Nelson on 1/12/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerAdView: GADBannerView, XibLoadable, GADBannerViewDelegate {
  let ibTag = 42

  var count = 0
  
  @IBOutlet weak var bannerAd: GADBannerView!
  
  func setup() {
    bannerAd.adSize = kGADAdSizeSmartBannerPortrait
    bannerAd.adUnitID = "ca-app-pub-8254175664355700/5312339275"
    bannerAd.delegate = self
  }
  
  func start() {
    bannerAd.rootViewController = parentViewController
    let request = GADRequest()
    request.testDevices = ["9c7a2d5b6a1929703dafec01e4e60605229dc5a6"]
    bannerAd.load(request)
  }
  
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
}
