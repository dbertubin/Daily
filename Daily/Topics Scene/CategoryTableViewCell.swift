//
//  TopicTableViewCell.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher
class TopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension TopicTableViewCell {
    func configure(with category: Category) {
        titleLabel.text = category.value
        backgroundImageView.backgroundColor = .lightGray

        let urlString = "https://loremflickr.com/320/240/\(category.key)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            let processor = BlurImageProcessor(blurRadius: 2) >> RoundCornerImageProcessor(cornerRadius: 0)
            self?.backgroundImageView.kf.setImage(with: url, options: [.transition(.fade(0.2)),.processor(processor)])
        }
        
    }
}