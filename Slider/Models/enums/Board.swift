//
//  Board.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Board {
  case moveZeroSpaces, moveOneSpace, moveTwoSpaces
}

enum GameState {
  case neverPlayed
  case played (won: Bool)
}

enum TimerState {
  case start, stop, reset
}
