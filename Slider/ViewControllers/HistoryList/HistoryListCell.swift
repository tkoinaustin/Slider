//
//  HistoryListCell.swift
//  Slider
//
//  Created by Tom Nelson on 12/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryListCell: UITableViewCell {
  var gameModel: GameModel! { didSet {
    moves.text = "\(gameModel.moves.description) moves"
    datePlayed.text = gameModel.displayDate
    let winColor = gameModel.won ? UIColor.green : UIColor.red
    addOpacityGradient(winColor)
  }}
  
  @IBOutlet private weak var wonStripe: UIView!
  @IBOutlet private weak var datePlayed: UILabel!
  @IBOutlet private weak var moves: UILabel!
  
  private func addOpacityGradient(_ color: UIColor) {
    wonStripe.isUserInteractionEnabled = false
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame.size = wonStripe.frame.size
    gradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                            color.withAlphaComponent(0.012).cgColor,
                            color.withAlphaComponent(0.059).cgColor,
                            color.withAlphaComponent(0.155).cgColor,
                            color.withAlphaComponent(0.308).cgColor,
                            color.withAlphaComponent(0.50).cgColor,
                            color.withAlphaComponent(0.692).cgColor,
                            color.withAlphaComponent(0.844).cgColor,
                            color.withAlphaComponent(0.941).cgColor,
                            color.withAlphaComponent(0.989).cgColor,
                            color.withAlphaComponent(1).cgColor]
    
    wonStripe.layer.addSublayer(gradientLayer)
  }

}
