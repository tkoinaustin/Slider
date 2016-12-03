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
  var selected: PuzzleListCell? = nil 
  var puzzleToLoad: ((Gameboard?) -> ()) = { _ in }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Klotski Puzzles"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))

    tableView.separatorStyle = .none
    tableView.dataSource = dataProvider
    dataProvider.registerCellsForTableView(tableView)

    tableView.reloadData()
  }
  
  func dismissController() {
    puzzleToLoad(nil)
    dismiss(animated: true, completion: nil)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? PuzzleListCell {
      guard cell != selected else { return }
      let gameboard = dataProvider.store[indexPath.row]
      puzzleToLoad(gameboard)
      dismiss(animated: true, completion: nil ) // { self.puzzleToLoad(gameboard) })

//      cell.select()
//      selected?.deselect()
//      selected = cell
    }
  }
}
