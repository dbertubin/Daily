//
//  QuotesTableViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher
class QuotesTableViewController: UITableViewController {

    var requestController = RequestController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableViewAutomaticDimension;
       reloadData()
    }

    var quotes = [Quote]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var topic: Topic?
    
    func reloadData() {
        let topic = self.topic?.title ?? ""
        title = topic
        requestController.requestQuotes(maximumResultCount: 20, imageSize: .large, topic: topic) { error, quotes in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.quotes = quotes ?? [Quote]()
            }
        }
    }
}

extension QuotesTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteTableViewCell", for: indexPath) as! QuoteTableViewCell
        let quote = quotes[indexPath.row]
        cell.configure(with: quote, at: indexPath)
        return cell
    }
}
