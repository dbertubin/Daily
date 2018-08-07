//
//  TopicsTableViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController {

    let requestController = RequestController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 375
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        topics = Topic.topics
    }
    
    var topics = [Topic]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func reloadData() {
        
        requestController.requestTopics { [weak self] error, topics in
            guard let `self` = self else {
                return
            }
            
            guard error == nil else {
                return
            }
            guard let topics = topics else { return }
            self.topics = topics
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TopicsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        cell.configure(with: topics[indexPath.row])
        return cell
    }
}

extension TopicsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let quotesTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuotesTableViewController") as! QuotesTableViewController
        quotesTableViewController.topic = topics[indexPath.row]
        navigationController?.pushViewController(quotesTableViewController, animated: true)
        
    }
}
