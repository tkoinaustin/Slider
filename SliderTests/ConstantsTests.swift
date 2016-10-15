//
//  ConstantsTests.swift
//  Slider
//
//  Created by Tom Nelson on 10/8/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class ConstantsTests: XCTestCase {
  
  func testSmallBlockCenter() {
    
    var point = GridConstants.blockCenter(row: 0, col: 0, type: .small)
    XCTAssertEqual(point, CGPoint(x: 0.125, y: 0.1) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 1, col: 1, type: .small)
    XCTAssertEqual(point, CGPoint(x: 0.375, y: 0.3) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 2, col: 2, type: .small)
    XCTAssertEqual(point, CGPoint(x: 0.625, y: 0.5) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 3, col: 3, type: .small)
    XCTAssertEqual(point, CGPoint(x: 0.875, y: 0.7) , "Point is wrong")
  }
  
  func testWideBlockCenter() {
    
    var point = GridConstants.blockCenter(row: 0, col: 0, type: .wide)
    XCTAssertEqual(point, CGPoint(x: 0.25, y: 0.1) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 1, col: 1, type: .wide)
    XCTAssertEqual(point, CGPoint(x: 0.5, y: 0.3) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 2, col: 2, type: .wide)
    XCTAssertEqual(point, CGPoint(x: 0.75, y: 0.5) , "Point is wrong")
  }
  
  func testTallBlockCenter() {
    
    var point = GridConstants.blockCenter(row: 0, col: 0, type: .tall)
    XCTAssertEqual(point, CGPoint(x: 0.125, y: 0.2) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 1, col: 1, type: .tall)
    XCTAssertEqual(point, CGPoint(x: 0.375, y: 0.4) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 2, col: 2, type: .tall)
    XCTAssertEqual(point, CGPoint(x: 0.625, y: 0.6) , "Point is wrong")
    
//    point = GridConstants.blockCenter(row: 3, col: 3, type: .tall)
//    XCTAssertEqual(point, CGPoint(x: 0.875, y: 0.8) , "Point is wrong")
  }
  
  func testBigBlockCenter() {
    
    var point = GridConstants.blockCenter(row: 0, col: 0, type: .big)
    XCTAssertEqual(point, CGPoint(x: 0.25, y: 0.2) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 1, col: 1, type: .big)
    XCTAssertEqual(point, CGPoint(x: 0.5, y: 0.4) , "Point is wrong")
    
    point = GridConstants.blockCenter(row: 2, col: 2, type: .big)
    XCTAssertEqual(point, CGPoint(x: 0.75, y: 0.6) , "Point is wrong")
    
//    point = GridConstants.blockCenter(row: 3, col: 2, type: .big)
//    XCTAssertEqual(point, CGPoint(x: 0.75, y: 0.8) , "Point is wrong")
  }
}
