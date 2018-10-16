//
//  QuoteViewControllerTests.swift
//  DailyTests
//
//  Created by Derek Bertubin on 10/15/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import XCTest
import UIKit
@testable import Daily

class QuoteViewControllerTests: XCTestCase {

    var viewControllerUnderTest: QuoteViewController! = nil
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "QuoteViewController") as? QuoteViewController
    }

    override func tearDown() {
        viewControllerUnderTest = nil
    }
    
    func testViewControllerIsNotNil() {
        XCTAssert(viewControllerUnderTest != nil, "viewControllerUnderTest should not be nil")
    }
    
    func testAttributedStringFromQuote() {
        let quote = Quote(quote: "To test or not to test", author: "Every Developer Ever")
        let attributedString = viewControllerUnderTest.attributedString(from: quote)
        XCTAssertEqual(attributedString.string, "Every Developer Ever\nonce said...\nTo test or not to test")
    }
    
    func testSpeakQuote() {
        let quote = Quote(quote: "To test or not to test", author: "Every Developer Ever")
        let utterance = viewControllerUnderTest.speak(quote: quote)
        XCTAssertEqual(utterance.speechString, "Every Developer Ever once said...To test or not to test.")
    }

}
