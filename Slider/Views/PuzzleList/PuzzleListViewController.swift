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
  var loadNewPuzzle: ((PuzzleModel?) -> ()) = { _ in }
  var saveHistory: (() -> ()) = { }

  override func viewDidLoad() {
    super.viewDidLoad()
    print(HistoryStoreModel.shared)

    self.title = "Klotski Puzzles"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))

    tableView.separatorStyle = .none
    tableView.dataSource = dataProvider
    dataProvider.registerCellsForTableView(tableView)

    tableView.reloadData()
    dataProvider.assignParent(self)
    
    tableView.backgroundView = UIImageView(image: UIImage(named: "background gradient90"))
    tableView.backgroundView?.addSubview(UIImageView(image: UIImage(named: "background image14")))
//    tableView.backgroundView = UIImageView(image: UIImage(named: "background image"))
//    let gradientView = UIImageView(image: UIImage(named: "background gradient90"))
//    tableView.backgroundView?.addSubview(gradientView)
  }
  
  func dismissController() {
    loadNewPuzzle(nil)
    dismiss(animated: true, completion: nil)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    saveHistory()
    let puzzleModel = dataProvider.store[indexPath.row]
    loadNewPuzzle(puzzleModel)
    dismiss(animated: true, completion: nil )
  }
}
