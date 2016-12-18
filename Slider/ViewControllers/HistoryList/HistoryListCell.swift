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
    wonStripe.backgroundColor = winColor
  }}
  
  @IBOutlet private weak var wonStripe: UIView!
  @IBOutlet private weak var datePlayed: UILabel!
  @IBOutlet private weak var moves: UILabel!
  
}
