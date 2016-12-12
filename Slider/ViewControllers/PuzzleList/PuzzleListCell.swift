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
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    puzzleLabel = UILabel()
    puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    historyButton = UIButton()
    historyButton.translatesAutoresizingMaskIntoConstraints = false
    
    bottomBorder = CALayer()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.layer.addSublayer(bottomBorder)
    bottomBorder.frame = CGRect(x: 0,
                                y: self.frame.height - bottomBorderHeight,
                                width: UIScreen.main.bounds.width,
                                height: bottomBorderHeight)
    
    self.selectionStyle = .none
    puzzleLabel.font = .systemFont(ofSize: 18)
    historyButton.setTitleColor(UIColor.black, for: .normal)
    historyButton.setTitleColor(UIColor.lightGray, for: .disabled)
    historyButton.setTitleColor(UIColor.lightGray, for: .highlighted)

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
    bottomBorder.backgroundColor = UIColor.green.cgColor
    historyButton.isEnabled = true
  }
  
  func notWon() {
    bottomBorder.backgroundColor = UIColor.red.cgColor
    historyButton.isEnabled = true
  }

  func neverPlayed() {
    bottomBorder.backgroundColor = UIColor.lightGray.cgColor
    historyButton.isEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
