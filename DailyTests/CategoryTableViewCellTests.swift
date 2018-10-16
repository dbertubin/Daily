//
//  CategoryTableViewCellTests.swift
//  DailyTests
//
//  Created by Derek Bertubin on 10/16/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import XCTest
import UIKit
@testable import Daily


class CategoryTableViewCellTests: XCTestCase {

    let category = QuoteCategory(key: "test", value: "Test Value")

    var categoriesTableViewController: CategoriesTableViewController? = nil
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        categoriesTableViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesTableViewController") as? CategoriesTableViewController
        categoriesTableViewController?.categories = [category]
        categoriesTableViewController?.loadView() 
        categoriesTableViewController?.tableView.reloadData()
    }
    
    override func tearDown() {
        categoriesTableViewController = nil
    }
    
    func testConfigureCategoryTableViewCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let category2 = QuoteCategory(key: "test", value: "Test Value 2")
        let cell = categoriesTableViewController?.tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        cell.configure(with: category2)
        XCTAssertEqual( cell.titleLabel.text, category2.value)
    }
}
