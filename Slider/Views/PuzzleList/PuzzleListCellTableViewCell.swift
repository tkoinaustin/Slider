//
//  PuzzleListCellTableViewCell.swift
//  Slider
//
//  Created by Tom Nelson on 10/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleListCellTableViewCell: UITableViewCell {
  
  var label: UILabel!
  var completed: UILabel!
  let bottomBorderHeight: CGFloat = 2.0
  let bottomBorder: CALayer
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    completed = UILabel()
    completed.translatesAutoresizingMaskIntoConstraints = false
    
    bottomBorder = CALayer()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.layer.addSublayer(bottomBorder)
    bottomBorder.frame = CGRect(x: 0,
                                y: self.frame.height - bottomBorderHeight,
                                width: UIScreen.main.bounds.width,
                                height: bottomBorderHeight)
    
    setUpStyle()
    
    addSubview(label)
    addSubview(completed)
    
    setUpConstraints(["pattern": patternView, "name": nameLabel, "birthday": birthdayLabel])
  }

}
