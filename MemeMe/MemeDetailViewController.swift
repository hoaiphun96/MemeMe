//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by cc-user on 9/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImage!.image = self.image
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
