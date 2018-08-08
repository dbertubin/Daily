//
//  QoDViewController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class QoDViewController: UIViewController, RequestControllerRequired {
    var requestController = RequestController()

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var speakerButton: UIButton!
    
    var placeholderImage: Placeholder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakerButton.isSelected = false
        speakerButton.tintColor = speakerButton.isSelected ? .white : .gray
        reloadData()
    }
    
    var quote: ForismaticQuote?
    
    private func reloadData() {
        requestController.requestForismaticQuote() { [weak self] error, quote in
            
            self?.quote = quote
        
            DispatchQueue.main.async {
                let urlString = "https://picsum.photos/800/?random"
                guard let url = URL(string: urlString) else {
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    self?.quoteLabel.alpha = 0
                }
                
                let processor = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 0)
               
                let image = self?.placeholderImage ?? UIImage()
                
                let options: KingfisherOptionsInfo = [.forceRefresh,.transition(.fade(0.2)),.processor(processor)]
                self?.backgroundImageView.kf.indicatorType = .activity
                self?.backgroundImageView.kf.setImage(with: url, placeholder: image, options: options) { image, _, _, _ in
                 
                    self?.placeholderImage = image
                    
                    UIView.animate(withDuration: 0.2) {
                        self?.quoteLabel.alpha = 1
                    }
                    self?.quoteLabel.attributedText = self?.attributedString(from: quote)
                    self?.speak(quote: quote)
                }
            }
            
        }
        
    }
    
    @IBAction func onShare(_ sender: UIButton) {
        sender.isSelected = sender.isSelected == false ? true : false
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(sender.isSelected)
        
        sender.tintColor = sender.isSelected ? .white : .gray
        
        guard sender.isSelected else {
            return
        }
        
        speak(quote: quote)
    }
    
    
    @IBAction func onMore(_ sender: Any) {
        
    }
    
    private func speak(quote: ForismaticQuote?) {
        
        guard speakerButton.isSelected else {
            return
        }
        
        let quoteAndAuthorText = "\(quote?.quoteText ?? "") \(quote?.quoteAuthor ?? "")"
        
        let string = quoteAndAuthorText
        let synth = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: string)
        synth.speak(utterance)
    }
    
    
    @IBAction func onNext(_ sender: Any) {
        reloadData()
    }
    
    
    func attributedString(from quote: ForismaticQuote?) -> NSAttributedString {
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        let quoteText = quote?.quoteText ?? ""
        let mutableAttributedString = NSMutableAttributedString(string: quoteText, attributes: attributes)
        
        let authorText = "\n-\(quote?.quoteAuthor ?? "Unknown")"
        let authorAttributes = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 26)
        ]
        let authorAttributedString = NSAttributedString(string: authorText, attributes: authorAttributes)
        
        mutableAttributedString.append(authorAttributedString)
        
        return mutableAttributedString
    }
}
