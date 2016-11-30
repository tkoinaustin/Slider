//
//  ControlBarView.swift
//  Slider
//
//  Created by Tom Nelson on 11/11/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

@IBDesignable

class ControlBarView: UIView, XibLoadable {
  let ibTag = 13
  let viewModel = ControlBarViewModel()
  
  @IBOutlet private weak var moveNumber: UILabel!
  @IBOutlet private weak var back: UIButton!
  @IBOutlet private weak var forward: UIButton!
  
  @IBAction func backAction(_ sender: UIButton) {
    viewModel.backward()
  }
  
  @IBAction func forwardAction(_ sender: UIButton) {
    viewModel.forward()
  }
  
  func setup() {
    print("----- ControlBarView setup -----")
    viewModel.updateUI = { _ in
      self.updateUI()
    }
  }

  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
  
  func updateUI() {
    UIView.animate(withDuration: 0.2, animations: {
      self.moveNumber.alpha = 0
    }, completion: { _ in
      self.moveNumber.text = self.viewModel.moveNumber.description
      UIView.animate(withDuration: 0.2, animations: {
      self.moveNumber.alpha = 1
      })
    })
  }
}
