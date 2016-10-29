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
  let completedLabel: UILabel!
  let bottomBorderHeight: CGFloat = 2.0
  let bottomBorder: CALayer
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    puzzleLabel = UILabel()
    puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    completedLabel = UILabel()
    completedLabel.translatesAutoresizingMaskIntoConstraints = false
    
    bottomBorder = CALayer()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.layer.addSublayer(bottomBorder)
    bottomBorder.frame = CGRect(x: 0,
                                y: self.frame.height - bottomBorderHeight,
                                width: UIScreen.main.bounds.width,
                                height: bottomBorderHeight)
    
    self.selectionStyle = .none
    completedLabel.font = .systemFont(ofSize: 18)
    puzzleLabel.font = .systemFont(ofSize: 14)
    
    addSubview(puzzleLabel)
    addSubview(completedLabel)
    
    setupConstraints()
    deselect()
  }
  
  private func setupConstraints() {
    completedLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    completedLabel.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -8).isActive = true
    
    puzzleLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
    puzzleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 8).isActive = true
  }
  
  func select() {
    bottomBorder.backgroundColor = UIColor.blue.cgColor
  }
  
  func deselect() {
    bottomBorder.backgroundColor = UIColor.lightGray.cgColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
