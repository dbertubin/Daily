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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var quoteImage: UIImage? {
        didSet {
            self.quoteImageView.image = quoteImage
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quoteImage = nil
    }
}

extension QuoteTableViewCell {
    
    func configure(with quote: Quote, at indexPath: IndexPath){
        
        guard let url = URL(string: quote.media) else {
            return
        }
        self.quoteImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
    
}

