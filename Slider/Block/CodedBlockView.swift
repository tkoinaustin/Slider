//
//  CodedBlockView.swift
//  Slider
//
//  Created by Mac Daddy on 9/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class CodedBlockView: UIView {
  
  var imageView = UIImageView()
  var viewModel: BlockViewModel!

  public override init(frame: CGRect) {
    super.init(frame: frame)
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    self.addGestureRecognizer(pan)
    
    self.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let margins = layoutMarginsGuide
    
    imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo:margins.trailingAnchor).isActive = true
    
    imageView.image = UIImage(named: "superman1")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func get(parent: UIView, game: GameViewModel, index: Int) -> CodedBlockView {
    let block = CodedBlockView.init(frame: CGRect.zero)
    
    block.viewModel = game.block(index)
    block.center = block.viewModel.center
    block.bounds = block.viewModel.bounds
    
    block.viewModel.updateUI = { _ in
      block.center = block.viewModel.center
    }
    parent.addSubview(block)

    return block
  }
  
  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    
    let translation = panRecognizer.translation(in: superview)
    
    switch panRecognizer.state {
    case .began:
      break
    case .changed:
      viewModel.model.moving(amount: translation)
    default:
      viewModel.model.finished()
    }

    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: superview)
  }
}
