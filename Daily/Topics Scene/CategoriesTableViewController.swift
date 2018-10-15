//
//  CatagoriesTableViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    let requestController = RequestController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableView.automaticDimension;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()

    }
    
    var categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func reloadData() {
        
        requestController.requestCategories { error, categories in 
            guard error == nil else {
                // show error
                return
            }
            
            self.categories = categories ?? [Category]()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CategoriesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}

extension CategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let quoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuoteViewController") as! QuoteViewController
        quoteViewController.category = categories[indexPath.row]
        navigationController?.pushViewController(quoteViewController, animated: true)
        
    }
}
