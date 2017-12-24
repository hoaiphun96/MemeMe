//
//  ViewController.swift
//  Meme
//
//  Created by cc-user on 9/4/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    override var prefersStatusBarHidden: Bool {return true}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        //setting the default attributes
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.50,
            ]
        configureText(textField: topTextField, text: "TOP", defaultAttributes: memeTextAttributes)
        configureText(textField: bottomTextField, text: "BOTTOM", defaultAttributes: memeTextAttributes)
        
        shareButton.isEnabled = false
        
    }
    func configureText(textField: UITextField, text: String, defaultAttributes: [String: Any]) {
        textField.defaultTextAttributes = defaultAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = text
        textField.backgroundColor = .clear
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //clear when first editing top and bottom
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text?.removeAll()
        }
        //unsubscribe to keyboard notification when editing top text field
        if textField == topTextField {
            unsubscribeToKeyBoardNotifications()
        }
            //subscribe when editing to bottom text field
        else {
            subscribeToKeyBoardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyBoardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //Pick image from Album
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    //Pick image from camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
        
    }
    
    func presentImagePickerWith(sourceType :UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        shareButton.isEnabled = true
        
    }
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    @objc func keyBoardWillShow(_ notification: Notification) {
        view.frame.origin.y = 0 - getKeyBoardHeight(notification)
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        let userInfor = notification.userInfo
        let keyBoardSize = userInfor![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        configureBar(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        configureBar(hidden: false)
        
        return memedImage
    }
    
    func configureBar(hidden: Bool) {
        toolBar.isHidden = hidden
        navigationBar.isHidden = hidden
    }
    
    
    @IBAction func cancelImage(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
        if let _ = self.navigationController {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func share(_ sender: Any)  {
        //generate meme and present the activity view
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if !completed {
                print("cancelled")
                return
            }else{
                self.save()
                if let _ = self.navigationController {
                    self.navigationController!.popToRootViewController(animated: true)
                }
                
            }
            
        }
    }}




