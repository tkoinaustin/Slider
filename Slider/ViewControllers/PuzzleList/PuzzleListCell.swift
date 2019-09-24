//
//  PuzzleListCellTableViewCell.swift
//  Slider
//
//  Created by Tom Nelson on 10/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleListCell: UITableViewCell {
  
  let puzzleLabel: UILabel!
  let historyButton: UIButton!
  let bottomBorderHeight: CGFloat = 2.0
  let bottomBorder: CALayer
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    puzzleLabel = UILabel()
    puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    historyButton = UIButton()
    historyButton.translatesAutoresizingMaskIntoConstraints = false
    
    bottomBorder = CALayer()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.white.withAlphaComponent(0.25)

    self.layer.addSublayer(bottomBorder)
    bottomBorder.frame = CGRect(x: 0,
                                y: self.frame.height - bottomBorderHeight,
                                width: UIScreen.main.bounds.width,
                                height: bottomBorderHeight)
    
    self.selectionStyle = .none
    puzzleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    historyButton.setTitleColor(UIColor.label, for: .normal)
    historyButton.setTitleColor(UIColor.secondaryLabel, for: .disabled)
    historyButton.setTitleColor(UIColor.secondaryLabel, for: .highlighted)

    addSubview(puzzleLabel)
    addSubview(historyButton)
    setupConstraints()
  }
  
  private func setupConstraints() {

    historyButton.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    historyButton.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -8)
      .isActive = true

    puzzleLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    puzzleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 8).isActive = true
  }
  
  func won() {
    bottomBorder.backgroundColor = Color.moss.cgColor
    historyButton.isEnabled = true
  }
  
  func notWon() {
    bottomBorder.backgroundColor = Color.cayenne.cgColor
    historyButton.isEnabled = true
  }

  func neverPlayed() {
    bottomBorder.backgroundColor = UIColor.tertiaryLabel.cgColor
    historyButton.isEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
