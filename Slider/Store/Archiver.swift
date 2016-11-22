//
//  Archiver.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class Archiver {
  static func dataFilePath() -> String {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let filepath = path[0].appendingPathComponent("datafile")
    return filepath.path
  }

  static func store(data: Any) -> Bool {
    let file = Archiver.dataFilePath()
    return NSKeyedArchiver.archiveRootObject(data, toFile: file)
  }
  
  static func retrieve() -> Any? {
    let file = Archiver.dataFilePath()
    guard let master = NSKeyedUnarchiver.unarchiveObject(withFile: file) else { return nil }
    return master
  }
}
