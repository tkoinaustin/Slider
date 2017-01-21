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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "\(data[0].name)"
    formatter.dateFormat = "EEE, MMM d "

    tableView.backgroundView = UIImageView(image: UIImage(named: "background gradient90"))
    tableView.backgroundView?.addSubview(UIImageView(image: UIImage(named: "background image small tall")))
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // swiftlint:disable force_cast
    let row = sender as! Int
    // swiftlint:enable force_cast
    let navController = segue.destination as? UINavigationController
    let replayBoardViewController = navController?.viewControllers[0] as? ReplayBoardViewController
    replayBoardViewController?.viewModel.game = data[row]
    replayBoardViewController?.replayText = "replaying"
    replayBoardViewController?.index = row
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {    
    performSegue(withIdentifier: "replayBoardSegue", sender: indexPath.row)
  }
}
