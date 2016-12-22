//
//  ViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 1/27/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {

    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var textWindow: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var welcomeText: UITextView!
    @IBOutlet weak var idText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idText.layer.cornerRadius = 10
        idTextField.layer.cornerRadius = 10
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "loginToMain"){
        }
    }
    
    @IBAction func nextPageButtonPressed(sender: AnyObject) {
        
        if(idTextField.text == "1" && passwordTextField.text == "1"){
            performSegueWithIdentifier("loginToMain", sender: self)
        }else{
            textWindow.text = "Wrong ID or Password"
        }
    }
    

}

