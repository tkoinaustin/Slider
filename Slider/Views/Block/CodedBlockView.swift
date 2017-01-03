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
    
    imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
    imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
    imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
    imageView.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
    
    imageView.image = UIImage(named: "superman1")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func getReplayBlock(parent: UIView,
                             blockModel: BlockViewModel,
                             index: Int) -> CodedBlockView {
    let block = CodedBlockView.init(frame: CGRect.zero)
    block.viewModel = blockModel
    
    return get(block: block, parent: parent, index: index)
  }
  
  static func getGameBlock(parent: UIView, game: GameboardViewModel, index: Int) -> CodedBlockView {
    let block = CodedBlockView.init(frame: CGRect.zero)
    block.viewModel = game.block(index)
    
    return get(block: block, parent: parent, index: index)
  }
  
  // swiftlint:disable function_body_length
  static func get(block: CodedBlockView, parent: UIView, index: Int) -> CodedBlockView {
    block.center = block.viewModel.center
    block.bounds = block.viewModel.bounds
    block.layer.borderColor = UIColor.white.cgColor
    block.layer.borderWidth = 0.5
    let label = UILabel(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
    label.text = index.description
    label.textColor = UIColor.white
    block.addSubview(label)
    
    block.viewModel.updateBlockUI = { _ in
      UIView.animate(withDuration: 0.2, animations: {
        block.center = block.viewModel.center
      })
    }
    
    block.viewModel.nextStep = { _ in
      UIView.animate(withDuration: 0.4, animations: {
        block.center = block.viewModel.center
      })
    }
    
    block.viewModel.exitOffScreen = { _ in
      UIView.animate(
        withDuration: 0.5,
        delay: 0.25,
        options: .curveEaseIn ,
        animations: {
          block.center = block.viewModel.center
      },
        completion: nil
    )}
    
    block.viewModel.fadeIn = { _ in
      block.alpha = 0
      UIView.animate(withDuration: 0.3, animations: {
        block.alpha = 1
      })
    }
    
    block.alpha = 0
    parent.addSubview(block)
    UIView.animate(withDuration: 1, animations: {
      block.alpha = 1
    })

    return block
  }
  // swiftlint:enable function_body_length

  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    guard viewModel.swipeEnabled else { return }
    
    let translation = panRecognizer.translation(in: superview)
    
    switch panRecognizer.state {
    case .began:
      break
    case .changed:
      viewModel.model.blockMovedBy(translation)
    case .ended:
      viewModel.model.blockModelMoveFinished()
    default:
      print("pan recognizer indeterminate state")
    }

    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: superview)
  }
}
