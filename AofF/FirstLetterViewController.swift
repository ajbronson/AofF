//
//  FirstLetterViewController.swift
//  AofF
//
//  Created by AJ Bronson on 12/23/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class FirstLetterViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var wordWebView: UIWebView!
    @IBOutlet weak var letterTextField: UITextField!
    @IBOutlet weak var letterSlider: UISlider!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    
    var firstLetterText: String = ""
    var currentText: [String] = ["", ""]
    var indexesRemoved:[Int] = []
    var book: Book?
    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterSlider.maximumValue = 25
        letterSlider.minimumValue = 1
        letterSlider.setValue(5.0, animated: false)
        letterTextField.text = "5"
        removeButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book,
            let books = parentVC.books {
            self.book = book
            self.books = books
            self.tabBarController?.title = book.reference
            firstLetterText = book.text.setFirstLetters()
            let arrayText = firstLetterText.getStringArray()
            currentText = FileController.shared.removeEmptyElementsFromArray(array: arrayText)
            reloadHTML()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        wordWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    func reloadHTML() {
        let bookText = currentText.joined(separator: " ").replacingOccurrences(of: "\n", with: "<br>")
        wordWebView.loadHTMLString(bookText, baseURL: nil)
    }
    
    func removeElements(count: Int) {
        for _ in 0..<count {
            
            if currentText.count == indexesRemoved.count {
                return
            }
            
            var random = Int(arc4random_uniform(UInt32(currentText.count)))
            
            while (indexesRemoved.contains(random)) {
                random = Int(arc4random_uniform(UInt32(currentText.count)))
            }
            
            indexesRemoved.append(random)
            if currentText[random] == "<br>" {
                removeElements(count: 1)
            } else {
                currentText[random] = "_"
            }
        }
    }
    
    func bookDidChange() {
        if let book = book {
            self.tabBarController?.title = book.reference
            firstLetterText = book.text.setFirstLetters()
            let arrayText = firstLetterText.getStringArray()
            currentText = FileController.shared.removeEmptyElementsFromArray(array: arrayText)
            reloadHTML()
        }
    }
    
    @IBAction func letterSliderDidChange(_ sender: UISlider) {
        let value: Int = Int(letterSlider.value)
        letterTextField.text = "\(value)"
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        indexesRemoved = []
        let arrayText = firstLetterText.getStringArray()
        currentText = FileController.shared.removeEmptyElementsFromArray(array: arrayText)
        reloadHTML()
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        removeElements(count: Int(letterSlider.value))
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
