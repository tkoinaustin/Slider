//
//  PuzzleListViewController.swift
//  Slider
//
//  Created by Tom Nelson on 10/26/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleListViewController: UITableViewController {
  var dataProvider = PuzzleListDataProvider()
  var loadNewPuzzle: ((PuzzleModel?) -> Void) = { _ in }
  var saveHistory: (() -> Void) = { }
  var currentIndex: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    print(HistoryStoreModel.shared)

    self.title = "Klotski Puzzles"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))
    navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "smallBlock")

    tableView.separatorStyle = .none
    tableView.dataSource = dataProvider
    dataProvider.registerCellsForTableView(tableView)

    tableView.reloadData()
    dataProvider.assignParent(self)
    let indexPath = IndexPath(row: currentIndex, section: 0)
    tableView.scrollToRow(at: indexPath, at: .middle , animated: true)
  }
  
    @objc func dismissController() {
    loadNewPuzzle(nil)
    dismiss(animated: true, completion: nil)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    saveHistory()
    let puzzleModel = dataProvider.store[indexPath.row]
    dismiss(animated: true, completion: {
      self.loadNewPuzzle(puzzleModel)
    })
  }
}
