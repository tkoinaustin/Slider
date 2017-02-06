//
//  InAppPurchase.swift
//  Slider
//
//  Created by Tom Nelson on 2/4/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import StoreKit

protocol  IAPDelegate {
  func updateUI()
}

public typealias ProductIdentifier = String
//public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

open class InAppPurchase : NSObject  {
  var delegate: IAPDelegate?
  static let InAppPurchaseNotification = "InAppPurchaseNotification"
  fileprivate var product: SKProduct!
  
  fileprivate let productIdentifiers: Set<ProductIdentifier>
  fileprivate var appStoreProductIdentifiers = Set<ProductIdentifier>()
  fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
  fileprivate var productsRequest: SKProductsRequest?
  fileprivate var productsRequestCompletionHandler: (_ success: Bool, _ products: [SKProduct]?) -> Void =  { _, _ in }
  
  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    for productIdentifier in productIds {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        print("Previously purchased: \(productIdentifier)\n")
      } else {
        print("Not purchased: \(productIdentifier)\n")
      }
    }
    super.init()
    SKPaymentQueue.default().add(self)
  }
  
  var showBannerAds: Bool {
    return !purchasedProductIdentifiers.contains(Gratuity.smallGratuity)
  }

  public func checkForGratuity(completionHandler: @escaping (_ success: Bool, _ products: [SKProduct]?) -> Void) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    
//    if purchasedProductIdentifiers.contains(Gratuity.smallGratuity) { return }
    
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }
  
  public func buyProduct() {
    print("Buying \(product.productIdentifier)...")
    let payment = SKPayment(product: product)
//    SKPaymentQueue.default().add(payment)
  }
  
  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

extension InAppPurchase: SKProductsRequestDelegate {
  
  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    product = response.products[0]

    let products = response.products
    let productIds = products.map { $0.productIdentifier }
    print("Loaded list of products...\n")
    appStoreProductIdentifiers = Set<ProductIdentifier>(productIds)
    productsRequestCompletionHandler(true, products)
    
    productsRequest = nil
    productsRequestCompletionHandler = { _, _ in }
    
    for product in products {
      print("Found product: \(product.productIdentifier) - \(product.localizedTitle) - \(product.price.floatValue)\n")
    }
    
    if showBannerAds {
      self.restorePurchases()
    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.\n")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler(false, nil)
    
    productsRequest = nil
    productsRequestCompletionHandler = { _, _ in }
  }
}

extension InAppPurchase: SKPaymentTransactionObserver {
  
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
  
  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
    
    print("restore... \(productIdentifier)")
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as? NSError {
      if transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(transaction.error?.localizedDescription)")
      }
    }
    
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  fileprivate func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }
    
    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    UserDefaults.standard.synchronize()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchase.InAppPurchaseNotification), object: identifier)
  }
}

