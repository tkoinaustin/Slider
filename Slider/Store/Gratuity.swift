//
//  Gratuity.swift
//  Slider
//
//  Created by Tom Nelson on 2/4/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation

public struct Gratuity {
  
  public static let smallGratuity = "com.tkosolutions.slider.smalldonation"
  
  fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Gratuity.smallGratuity]
  
  public static let store = InAppPurchase(productIds: Gratuity.productIdentifiers)
}
