//
//  HistoryListViewController.swift
//  Slider
//
//  Created by Tom Nelson on 12/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryListViewController: UITableViewController {
  let formatter = DateFormatter()

  var data = [GameModel]() { didSet {
    print("HistoryListViewController didSet data, count: \(data.count)")
  }}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    formatter.dateFormat = "EEE, MMM d "
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellReuseIdentifier",
                                             for: indexPath)
    
    if let cell = cell as? HistoryListCell {
      let gameModel = data[indexPath.row]
      gameModel.displayDate = formatter.string(from: gameModel.datePlayed)
      cell.gameModel = gameModel
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "replaySegue", sender: self)
  }
  // swiftlint:disable force_cast
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    let nav = segue.destination as! UINavigationController
    
    let replay = nav.viewControllers[0] as! ReplayBoardViewController
    replay.replayText = "replaying"
  }
}
