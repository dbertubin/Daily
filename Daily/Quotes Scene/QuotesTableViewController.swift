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

    private var requestController = RequestController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableView.automaticDimension
       reloadData()
    }

    private var quotes = [Quote]() {
        didSet {
            DispatchQueue.main.async { [weak self] in 
                self?.tableView.reloadData()
            }
        }
    }

    var quoteCategory: QuoteCategory?
    
}

extension QuotesTableViewController {
    private func reloadData() {
        guard let quoteCategory = self.quoteCategory else {
            return
        }
        title = quoteCategory.value
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

extension QuotesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareText = "I thought you might like this! Shared from the Inspiration Daily App. Download at http://derekbertubin.com"
        let cell = tableView.cellForRow(at: indexPath) as! QuoteTableViewCell
        
        guard let image = cell.quoteImageView.image else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        present(vc, animated: true)
    }
}
