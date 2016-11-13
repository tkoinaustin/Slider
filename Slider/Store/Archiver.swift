//
//  Archiver.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class Archiver {
  
  static func store(data: MasterModel) {
    NSKeyedArchiver.archiveRootObject(data, toFile: "dataStore")
  }
  
  static func retrieve() -> MasterModel? {
    guard let master = NSKeyedUnarchiver.unarchiveObject(withFile: "dataStore") as? MasterModel else { return nil }
    return master
  }
}
