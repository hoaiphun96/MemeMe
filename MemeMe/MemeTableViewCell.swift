//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by cc-user on 9/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCellImage: UIImageView!
    
    @IBOutlet weak var tableViewCellText: UITextField!
    
    func setUpCell(_ meme: Meme) {
        tableViewCellImage.image = meme.memedImage
        tableViewCellText.text = meme.topText + " " + meme.bottomText
        tableViewCellText.isEnabled = false
    }
}
