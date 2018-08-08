//
//  DailyViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher

class DailyViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    var quote: Quote? {
        didSet {
            guard let mediaUrl = quote?.media, let url = URL(string: mediaUrl) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.featuredImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                let processor = BlurImageProcessor(blurRadius: 20) >> RoundCornerImageProcessor(cornerRadius: 0)
                self?.backgroundImageView.kf.setImage(with: url, options: [.transition(.fade(0.2)),.processor(processor)])
            }
        }
    }
    
    private func reloadData(){
    requestController.requestQuotes(maximumResultCount: 1, imageSize: .large) { [weak self] error, quotes in
            guard error == nil else {
                return
            }
            self?.quote = quotes?.first
        }
    }
    
    @IBAction func onShare(_ sender: Any) {
        let shareText = "I thought you might like this! Shared from the Inspiration Daily App. Download at http://derekbertubin.com"
        
        guard let image = featuredImageView.image else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        present(vc, animated: true)
    }
}

extension DailyViewController: RequestControllerRequired {
    var requestController: RequestController {
        get {
            return RequestController()
        }
    }
}
