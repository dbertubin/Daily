//
//  QuoteTableViewCell.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher

class QuoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quoteImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.quoteImageView.image = nil
    }
}

extension QuoteTableViewCell {
    
    func configure(with quote: Quote, at indexPath: IndexPath){
        
        guard let url = URL(string: quote.media) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.quoteImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
    }
}

