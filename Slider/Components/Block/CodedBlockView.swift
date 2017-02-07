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
  var color: UIColor { didSet { imageView.backgroundColor = color }}

  public override init(frame: CGRect) {
    color = Color.blue
    super.init(frame: frame)
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    self.addGestureRecognizer(pan)
    
    self.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: gameSize.layout).isActive = true
    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -gameSize.layout).isActive = true
    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: gameSize.layout).isActive = true
    imageView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -gameSize.layout).isActive = true
    
    imageView.image = UIImage(named: "block gradient")
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = Color.blue
    imageView.layer.cornerRadius = gameSize.corner
    
    imageView.layer.borderWidth = 0.5
    imageView.layer.borderColor = Color.purple.cgColor
    
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOpacity = 0.6
    imageView.layer.shadowRadius = gameSize.shadowRadius
    imageView.layer.shadowOffset = gameSize.shadowOffset
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
  
  static func getGameBlock(parent: UIView,
                           game: GameboardViewModel,
                           index: Int) -> CodedBlockView {
    let block = CodedBlockView.init(frame: CGRect.zero)
    block.viewModel = game.block(index)
    
    return get(block: block, parent: parent, index: index)
  }
  
  // swiftlint:disable function_body_length
  static func get(block: CodedBlockView, parent: UIView, index: Int, fade: Double? = 1) -> CodedBlockView {
    block.center = block.viewModel.center
    block.bounds = block.viewModel.bounds
    if index == 1 { block.imageView.backgroundColor = Color.darkBlue }
    block.setBlockClosures(index)
    
    parent.addSubview(block)

    block.alpha = 0

    UIView.animate(withDuration: 2, animations: {
      block.alpha = 1
    })
    return block
  }
  
  fileprivate func setBlockClosures(_ index: Int) {
    viewModel.reset = { [unowned self] _ in
      self.alpha = 0
      self.transform = .identity
    }
    
    viewModel.fadeOutAndRemove = { _ in
      UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 0
      })
    }
    
    viewModel.updateBlockUI = { [unowned self] duration in
      UIView.animate(withDuration: duration, animations: {
        self.center = self.viewModel.center
      })
    }
    
   viewModel.nextStep = { [unowned self] _ in
      UIView.animate(withDuration: 0.4, animations: {
        self.center = self.viewModel.center
      })
    }
    
    viewModel.spinOffScreen = { [unowned self] _ in
      self.superview?.sendSubview(toBack: self)
      let delay: Double = 0.4 * Double(index)
      let scale: CGFloat = 1.2
      let enlarge = CGAffineTransform(scaleX: scale, y: scale)
      
      UIView.animate(
        withDuration: 0.1,
        delay: delay,
        options: .curveEaseIn,
        animations: {
          self.transform = enlarge
      },
        completion: nil)
      
      var offScreen = CGAffineTransform.identity
      offScreen = offScreen.scaledBy(x: 0.01, y: 0.01)
      offScreen = offScreen.rotated(by: index % 2 == 0 ? CGFloat.pi + 0.01 : CGFloat.pi - 0.01)
      
      UIView.animate(
        withDuration: 0.75,
        delay: 0.15 + delay,
        options: .curveEaseIn,
        animations: {
          self.transform = offScreen
      }, completion: { _ in
        self.alpha = 0
      })
    }
    
    self.viewModel.exitOffScreen = { [unowned self] _ in
      let transform = CGAffineTransform(scaleX: 1, y: 0.001)
      UIView.animate(
        withDuration: 0.5,
        delay: 0.25,
        options: .curveEaseIn ,
        animations: {
          self.center = self.viewModel.center
          self.transform = transform
      },
        completion: nil
    )}
    
    viewModel.fadeIn = { [unowned self] _ in
      self.alpha = 0
      UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 1
      })
    }
  }
  // swiftlint:enable function_body_length

  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    guard viewModel.swipeEnabled else { return }
    
    let translation = panRecognizer.translation(in: superview)
    
    switch panRecognizer.state {
    case .began:
      viewModel.blockMoveStarted()
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
