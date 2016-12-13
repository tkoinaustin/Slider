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
      print("----- gameModel didSet")
    moves.text = gameModel.moves.description
    datePlayed.text = gameModel.datePlayed.description
  }}
  
  @IBOutlet weak var datePlayed: UILabel! { didSet {
    print("datePlayed didSet")
    }}

  @IBOutlet weak var moves: UILabel! { didSet {
    print("moves didSet")
    }}

}
