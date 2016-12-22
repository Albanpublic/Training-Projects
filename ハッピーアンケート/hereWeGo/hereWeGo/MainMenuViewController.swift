//
//  MainMenuViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 1/27/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import Firebase


var cats:Array<Cat> = [Cat]()
var dogs:Array<Dog> = [Dog]()
var keyArray:Array<String> = [String]()
var firstFlag:Bool = true
var actualCollection:String?
var actualCharacter:String = "Calvin"

class MainMenuViewController: UIViewController {

    @IBOutlet weak var welcomeTextWindow: UITextField!
    @IBOutlet weak var startQuestionButton: UIButton!
    @IBOutlet weak var displayingResultView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nakamaButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mainMenu_bg: UIImageView!
    
    
    let ref = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data")
    let refItems = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items")
    let refcat = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/Cat")
    let refdog = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/Dog")
    let refnba = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/NBA")
    let resultsRef = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data/results")
    let settingsref = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data/settings")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the name from the user settings in firebase and display it.
        let nameRef = ref.childByAppendingPath("users/iphone1/nickname")
        nameRef.observeEventType(.Value, withBlock: { snapshot in
            let message = snapshot.value as! String
            self.welcomeTextWindow.text = "Welcome " + message
        }, withCancelBlock: { error in
            print(error.description)
        })
        
        
        //Introduction display
        displayingResultView.text = "ハッピーアンケ-トヘようこそ"
        displayingResultView.layer.cornerRadius = 25
        displayingResultView.layer.borderColor = UIColor.blackColor().CGColor
        displayingResultView.layer.borderWidth = 1
        
        welcomeTextWindow.layer.cornerRadius = 10
        welcomeTextWindow.layer.borderColor = UIColor.blackColor().CGColor
        welcomeTextWindow.layer.borderWidth = 1
        
        
        //Get the items info
        collectionQuery()
        
        //Get the users preferences(collection and character)
        if firstFlag{
            resultQuery()
            firstFlag = false
        }
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    

    //Start question button
    @IBAction func startQuestionButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("mainToQuestion", sender: nil)
    }
    
    //Unused Buttons
    @IBAction func updateButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func addPressed(sender: AnyObject) {
           
        
    }
    
    
    
    //Get the item's data from firebase and fill the respectives array after cleaning them once.
    func collectionQuery(){
        
        cats.removeAll()
        for(var i = 1; i < 7; i++){
            refcat.childByAppendingPath("cat\(i)").observeSingleEventOfType(.Value, withBlock: {snapshot in
                let dic = snapshot.value as! NSDictionary
                let image = dic.valueForKey("image") as! String
                let backImage:String = dic.valueForKey("back_image") as! String
                let isVisible:Bool = dic.valueForKey("visible") as! Bool
                let isCharacter:Bool = dic.valueForKey("character") as! Bool
                
                let cat = Cat(image: image, backImage: backImage, isVisible: isVisible, isCharacter: isCharacter)
                cats.append(cat)
                
                }, withCancelBlock: {error in
                    print(error.description)
                })
            
            
        }
        dogs.removeAll()
        for(var i = 1; i < 7; i++){
            refdog.childByAppendingPath("dog\(i)").observeSingleEventOfType(.Value, withBlock: {snapshot in
                let dic = snapshot.value as! NSDictionary
                let image = dic.valueForKey("image") as! String
                let backImage:String = dic.valueForKey("back_image") as! String
                let isVisible:Bool = dic.valueForKey("visible") as! Bool
                let isCharacter:Bool = dic.valueForKey("character") as! Bool
                
                let dog = Dog(image: image, backImage: backImage, isVisible: isVisible, isCharacter: isCharacter)
                dogs.append(dog)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
            
            
        }
    }
    
    //Get the data about the selected collection and character from firebase.
    func resultQuery(){
        resultsRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {snapshot in
            
            keyArray.append(snapshot.key)
            
            }, withCancelBlock: {error in
                print(error.description)
        })
        
        settingsref.childByAppendingPath("actual_collection").observeEventType(.Value, withBlock: {snapshot in
            
            
            actualCollection = snapshot.value as! String
            
            }, withCancelBlock: {error in
                print(error.description)
        })
        settingsref.childByAppendingPath("actual_character").observeEventType(.Value, withBlock: {snapshot in
            
            actualCharacter = snapshot.value as! String
            
            }, withCancelBlock: {error in
                print(error.description)
        })
    }

    
    
    
}

