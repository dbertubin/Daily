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

class QuoteViewController: UIViewController, RequestControllerRequired {
    var requestController = RequestController()

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var speakerButton: UIButton!
    
    let speechSynthesizer = AVSpeechSynthesizer()

    var placeholderImage: Placeholder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakerButton.isSelected = true
        onShare(speakerButton)
        reloadData()
    }
    
    var quote: Quote?
    var category: Category?
    var quoteAndAuthorText: String?
    private func reloadData() {
        
        let parameters = QuoteEndpointParameters(category: category?.key ?? "inspire")
        requestController.requestQuote(with: parameters) { [weak self] error, quote in
            
            guard let weakSelf = self else { 
                return 
            }
                                      
            weakSelf.quote = quote
        
            DispatchQueue.main.async {
                let urlString = "https://picsum.photos/800/?random"
                guard let url = URL(string: urlString) else {
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    weakSelf.quoteLabel.alpha = 0
                }
                
                let processor = BlurImageProcessor(blurRadius: 4) >> RoundCornerImageProcessor(cornerRadius: 0)
                let image = weakSelf.placeholderImage ?? UIImage()
                
                let options: KingfisherOptionsInfo = [.forceRefresh,.transition(.fade(0.2)),.processor(processor)]
                weakSelf.backgroundImageView.kf.indicatorType = .activity
                weakSelf.backgroundImageView.kf.setImage(with: url, placeholder: image, options: options) { image, _, _, _ in
                 
                    weakSelf.placeholderImage = image
                    
                    UIView.animate(withDuration: 0.2) {
                        weakSelf.quoteLabel.alpha = 1
                    }
                    weakSelf.quoteLabel.attributedText = weakSelf.attributedString(from: quote)
                    weakSelf.speak(quote: quote)
                }
            }
        }
    }
    
    @IBAction func onShare(_ sender: UIButton) {
        sender.isSelected = sender.isSelected == false ? true : false
        
        try? AVAudioSession.sharedInstance().setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback))
        try? AVAudioSession.sharedInstance().setActive(sender.isSelected)
        
        sender.tintColor = sender.isSelected ? .white : .lightGray
        
        guard sender.isSelected else {
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
            return
        }
        
        speak(quote: quote)
    }
    
    
    @IBAction func onMore(_ sender: Any) {
        
        guard let quoteAndAuthorText = quoteAndAuthorText else {
            return
        }
        let items = ["\(quoteAndAuthorText) Shared with Someone Once Said: Daily"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func speak(quote: Quote?) {
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .word)
        }
        
        guard speakerButton.isSelected else {
            return
        }
        
        let utterance = AVSpeechUtterance(string: quoteAndAuthorText ?? "Content unreadable.")
        speechSynthesizer.speak(utterance)
    }
    
    
    @IBAction func onNext(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        reloadData()
        sender.isUserInteractionEnabled = true

    }
    
    func attributedString(from quote: Quote?) -> NSAttributedString {
        
        quoteAndAuthorText = "\(quote?.author ?? "") once said...\(quote?.quote ?? "")."

        let quoteAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold),
            ]
        
        let authorAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 26, weight: .medium)
        ]
        
        let connectionAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)
        ]
        
        let quoteText = quote?.quote ?? ""
        let authorText = "\(quote?.author ?? "Unknown")\n"
        let connectionText = "once said...\n"
        
        
        let mutableAttributedString = NSMutableAttributedString(string: authorText, attributes: authorAttributes)
    
        let secondAttributedString = NSAttributedString(string: connectionText, attributes: connectionAttributes)
        
        let thirdAttributedString = NSAttributedString(string: quoteText, attributes: quoteAttributes)
        
        mutableAttributedString.append(secondAttributedString)
        mutableAttributedString.append(thirdAttributedString)
        return mutableAttributedString
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
