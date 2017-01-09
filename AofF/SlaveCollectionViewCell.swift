//
//  SlaveCollectionViewCell.swift
//  AofF
//
//  Created by AJ Bronson on 12/23/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    var faceUp = true
    
    func updateWith(book: Book, showHints: Bool) {
        if faceUp {
            titleLabel.text = book.reference
            subtitleLabel.text = showHints ? book.hint : ""
            customView.layer.cornerRadius = 5
        } else {
            titleLabel.text = book.text
        }
        
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
        subtitleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/10)
    }
}
