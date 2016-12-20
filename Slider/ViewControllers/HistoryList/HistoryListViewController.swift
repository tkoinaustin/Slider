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
  var data = [GameModel]()
  var selected = IndexPath()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "\(data[0].name)"
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
    selected = indexPath
    let storyboard = UIStoryboard(name: "ReplayBoard", bundle: Bundle.main)
    // swiftlint:disable force_cast
    let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "replayNavController")
        as! UINavigationController
    
    let replayBoardViewController: ReplayBoardViewController = navController.viewControllers[0]
      as! ReplayBoardViewController
    // swiftlint:enable force_cast
    
    replayBoardViewController.replayText = "replaying"
    replayBoardViewController.index = indexPath.row
    self.navigationController!.pushViewController(replayBoardViewController, animated: true)
  }
  
  // swiftlint:disable force_cast
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dest = segue.destination as! UINavigationController
    let replay = dest.viewControllers[0] as! ReplayBoardViewController
    replay.replayText = "replaying"
    self.navigationController!.pushViewController(replay, animated: true)
  }
}
