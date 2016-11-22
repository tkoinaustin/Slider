//
//  XibLoadable.swift
//
//  Created by Joshua Antonishen on 8/27/16.
//  Copyright © 2016 thirteen23. All rights reserved.
//

import Foundation
import UIKit

/// Use a view loaded from a nib in a storyboard / another nib or programmatically.
protocol XibLoadable {
  
  /// The interface builder tag for this view. You'll need to set this in interface
  /// builder wherever you USE the view (not where you define it.)
  var ibTag: Int { get }
  
  /// Use this to load the view programmatically
  static func get() -> UIView
  
  static func getAndConfigure(from: UIView) -> UIView
  
  /// Override awakeAfter and call this.
  ///
  /// - parameter superAwakeAfter: Send in: { return super.awakeAfter(using: aDecoder) }
  ///
  /// - returns: Any?
  func customAwakeAfter(superAwakeAfter: () -> Any?) -> Any?
  
  /// Override prepareForInterfaceBuilder and call this.
  func makeIBDesignable()
  
  /// Called after your view is instantiated. Do any setup that you can't do
  /// on outlet didSet in here.
  func setup()
}

extension XibLoadable where Self: UIView {
  static func get() -> UIView {
    let bundle = Bundle(for: self)
    let nib = UINib(nibName: String(describing: self), bundle: bundle)
    guard let view = nib.instantiate(withOwner: self, options: nil)[0]
      as? UIView else { fatalError("something is wrong") }
    
    if let view = view as? XibLoadable { view.setup() }
    return view
  }
  
  // swiftlint:disable function_body_length
  static func getAndConfigure(from: UIView) -> UIView {
    // swiftlint:enable function_body_length
    let realView = self.get()
    
    realView.frame = from.frame
    realView.autoresizingMask = from.autoresizingMask
    realView.translatesAutoresizingMaskIntoConstraints =
      from.translatesAutoresizingMaskIntoConstraints
    
    for constraint in from.constraints {
      var firstItem: AnyObject {
        if let item = constraint.firstItem as? NSObject, item == from { return realView }
        else { return constraint.firstItem }
      }
      
      var secondItem: AnyObject? {
        if let item = constraint.secondItem as? NSObject, item == from { return realView }
        else { return constraint.secondItem }
      }
      
      realView.addConstraint(
        NSLayoutConstraint(
          item: firstItem,
          attribute: constraint.firstAttribute,
          relatedBy: constraint.relation,
          toItem: secondItem,
          attribute: constraint.secondAttribute,
          multiplier: constraint.multiplier,
          constant: constraint.constant
        )
      )
    }
    
    return realView
  }
  
  func customAwakeAfter(superAwakeAfter: () -> Any?) -> Any? {
    if self.tag == ibTag { return type(of: self).getAndConfigure(from: self) }
    
    return superAwakeAfter()
  }
  
  func makeIBDesignable() {
    let view = type(of: self).get()
    view.frame = self.bounds
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    addSubview(view)
  }
}
