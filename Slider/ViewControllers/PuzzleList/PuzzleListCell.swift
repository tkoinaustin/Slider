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
  let sideBorder: CALayer

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    puzzleLabel = UILabel()
    puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    historyButton = UIButton()
    historyButton.translatesAutoresizingMaskIntoConstraints = false
    
    bottomBorder = CALayer()
    sideBorder = CALayer()

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.layer.addSublayer(bottomBorder)
    self.layer.addSublayer(sideBorder)
    bottomBorder.frame = CGRect(x: 0,
                                y: self.frame.height - bottomBorderHeight,
                                width: UIScreen.main.bounds.width,
                                height: bottomBorderHeight)
    sideBorder.frame = CGRect(x: 0,
                                y: 2,
                                width: 8,
                                height: self.frame.height - 6)

    self.selectionStyle = .none
    puzzleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    historyButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    historyButton.setTitleColor(UIColor.label, for: .normal)
    historyButton.setTitleColor(UIColor.quaternaryLabel, for: .disabled)
    historyButton.setTitleColor(UIColor.secondaryLabel, for: .highlighted)
    bottomBorder.backgroundColor = UIColor.tertiaryLabel.cgColor

    addSubview(puzzleLabel)
    addSubview(historyButton)
    setupConstraints()
  }

  private func setupConstraints() {

    historyButton.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    historyButton.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -8)
      .isActive = true

    puzzleLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    puzzleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 16).isActive = true
  }
    
    func deselected() {
        self.contentView.backgroundColor = UIColor.systemBackground
    }
    
    func selected() {
        self.contentView.backgroundColor = UIColor.secondarySystemBackground
    }
    
    override func prepareForReuse() {
        self.contentView.backgroundColor = UIColor.systemBackground
    }
  
  func won() {
    sideBorder.backgroundColor = UIColor.systemGreen.cgColor
    historyButton.isEnabled = true
  }
  
  func notWon() {
    sideBorder.backgroundColor = UIColor.systemRed.cgColor
    historyButton.isEnabled = true
  }

  func neverPlayed() {
    sideBorder.backgroundColor = UIColor.clear.cgColor
    historyButton.isEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
