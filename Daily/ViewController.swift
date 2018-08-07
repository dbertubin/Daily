//
//  ViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher
class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloadData()
        
    }
    
    var quotes: [Quote]? {
        didSet {
            guard let mediaUrlString = quotes?.first?.media, let mediaUrl = URL(string: mediaUrlString) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.kf.setImage(with: mediaUrl)
            }
        }
    }
    
    private func reloadData() {
        let requestController = RequestController()
        
       
        let endpointParameters = QuotesEndpointParameters(maximumResultCount: 5, imageSize: QuotesEndpointParameters.ImageSize.large, topic: "Wisdom")

        let quotesEndPoint = QuotesEndpoint(parameters: endpointParameters)
       
        let quotesRequest = Request(for: quotesEndPoint)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

