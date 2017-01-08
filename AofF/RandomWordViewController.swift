//
//  RandomWordViewController.swift
//  AofF
//
//  Created by AJ Bronson on 12/23/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class RandomWordViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordSlider: UISlider!
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    var bookText: String = ""
    var currentText: [String] = ["", ""]
    var indexesRemoved:[Int] = []
    var book: Book?
    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordSlider.maximumValue = 25
        wordSlider.minimumValue = 1
        wordSlider.setValue(5.0, animated: false)
        wordTextField.text = "5"
        removeButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        currentText = bookText.getStringArray()
        
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book,
            let books = parentVC.books {
                self.tabBarController?.title = book.reference
                self.books = books
                self.book = book
                bookText = book.text
                currentText = bookText.getStringArray()
                reloadHTML()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        wordWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    func reloadHTML() {
        wordWebView.loadHTMLString(currentText.joined(separator: " "), baseURL: nil)
    }
    
    func removeElements() {
        let count = Int(wordSlider.value)
        for _ in 0..<count {
            
            if currentText.count == indexesRemoved.count {
                return
            }
            
            var random = Int(arc4random_uniform(UInt32(currentText.count)))
            
            while (indexesRemoved.contains(random)) {
                random = Int(arc4random_uniform(UInt32(currentText.count)))
            }
            
            currentText[random] = "__"
            indexesRemoved.append(random)
        }
    }

    func bookDidChange() {
        if let book = book {
            self.tabBarController?.title = book.reference
            bookText = book.text
            currentText = bookText.getStringArray()
            reloadHTML()
        }
    }
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        let value: Int = Int(wordSlider.value)
        wordTextField.text = "\(value)"
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        removeElements()
        reloadHTML()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        indexesRemoved = []
        currentText = bookText.getStringArray()
        reloadHTML()
    }
    
    @IBAction func screenSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: false) {
                bookDidChange()
                indexesRemoved = []
            }
        }
    }
    
    @IBAction func screenSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: true) {
                bookDidChange()
                indexesRemoved = []
            }
        }
    }
    
}
