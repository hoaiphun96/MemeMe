//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by cc-user on 9/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

class MemeTableViewController: UITableViewController {

    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    @IBAction func newMeme(_ sender: Any) {
        let editMeme = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController!.pushViewController(editMeme, animated: true)
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.setUpCell(meme)
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detailMemeViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.image = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }
   
}
