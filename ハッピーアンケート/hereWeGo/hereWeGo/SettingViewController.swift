//
//  SettingViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/3/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    let resultsRef = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data/results")
    
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var next5Button: UIButton!
    @IBOutlet weak var previous5Button: UIButton!
    @IBOutlet weak var displayText: UITextView!
    @IBOutlet weak var resultBG: UIImageView!
    
    var buttons:Array<UIButton>?
    var handle:UInt?
    var activeButton:Int = 0
    var multiplier:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthButton]
        
        for(var i = 0; i < 5; i++){
            buttons![i].setTitle(keyArray[i], forState: .Normal)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        }
        
    }

    @IBAction func firstButtonPressed(sender: AnyObject) {
        if handle != nil{
            resultsRef.childByAppendingPath(keyArray[activeButton * multiplier]).removeObserverWithHandle(handle!)
        }
        activeButton = 0
        
        var a, b, c, d:String?
        
        if ((0 * multiplier) < keyArray.count){
            
            handle = resultsRef.childByAppendingPath(keyArray[0 * multiplier]).observeEventType(.Value, withBlock: {snapshot in
                a = snapshot.value.objectForKey("A") as? String
                b = snapshot.value.objectForKey("B") as? String
                c = snapshot.value.objectForKey("C") as? String
                d = snapshot.value.objectForKey("D") as? String
                self.writeText(a!, b: b!, c: c!, d: d!)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
        }
            
        
        
    }
    
    @IBAction func secondButtonPressed(sender: AnyObject) {
        if handle != nil{
            resultsRef.childByAppendingPath(keyArray[activeButton * multiplier]).removeObserverWithHandle(handle!)
        }
        activeButton = 1
        var a, b, c, d:String?
        
        if ((1 * multiplier) < keyArray.count){
            
            handle = resultsRef.childByAppendingPath(keyArray[1 * multiplier]).observeEventType(.Value, withBlock: {snapshot in
                a = snapshot.value.objectForKey("A") as? String
                b = snapshot.value.objectForKey("B") as? String
                c = snapshot.value.objectForKey("C") as? String
                d = snapshot.value.objectForKey("D") as? String
                self.writeText(a!, b: b!, c: c!, d: d!)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
        }
    }
    
    @IBAction func thirdButtonPressed(sender: AnyObject) {
        if handle != nil{
            resultsRef.childByAppendingPath(keyArray[activeButton * multiplier]).removeObserverWithHandle(handle!)
        }
        activeButton = 2
        var a, b, c, d:String?
        
        if ((2 * multiplier) < keyArray.count){
            
            handle = resultsRef.childByAppendingPath(keyArray[2 * multiplier]).observeEventType(.Value, withBlock: {snapshot in
                a = snapshot.value.objectForKey("A") as? String
                b = snapshot.value.objectForKey("B") as? String
                c = snapshot.value.objectForKey("C") as? String
                d = snapshot.value.objectForKey("D") as? String
                self.writeText(a!, b: b!, c: c!, d: d!)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
        }
    }
    
    @IBAction func fourthButtonPressed(sender: AnyObject) {
        if handle != nil{
            resultsRef.childByAppendingPath(keyArray[activeButton * multiplier]).removeObserverWithHandle(handle!)
        }
        activeButton = 3
        var a, b, c, d:String?
        if ((3 * multiplier) < keyArray.count){
            
            handle = resultsRef.childByAppendingPath(keyArray[3 * multiplier]).observeEventType(.Value, withBlock: {snapshot in
                a = snapshot.value.objectForKey("A") as? String
                b = snapshot.value.objectForKey("B") as? String
                c = snapshot.value.objectForKey("C") as? String
                d = snapshot.value.objectForKey("D") as? String
                self.writeText(a!, b: b!, c: c!, d: d!)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
        }
    }
    
    @IBAction func fifthButtonPressed(sender: AnyObject) {
        if handle != nil{
            resultsRef.childByAppendingPath(keyArray[activeButton * multiplier]).removeObserverWithHandle(handle!)
        }
        activeButton = 4
        var a, b, c, d:String?
        
        if ((4 * multiplier) < keyArray.count){
            
            handle = resultsRef.childByAppendingPath(keyArray[4 * multiplier]).observeEventType(.Value, withBlock: {snapshot in
                a = snapshot.value.objectForKey("A") as? String
                b = snapshot.value.objectForKey("B") as? String
                c = snapshot.value.objectForKey("C") as? String
                d = snapshot.value.objectForKey("D") as? String
                self.writeText(a!, b: b!, c: c!, d: d!)
                
                }, withCancelBlock: {error in
                    print(error.description)
            })
        }
    }
    
    @IBAction func next5ButtonPressed(sender: AnyObject) {
        
        if (multiplier < (keyArray.count/5 + 1 )){
            multiplier++
            displayText.text = "displaying the next 5 results"
            for(var i = 0; i < 5; i++){
                if i + ((multiplier - 1)  * 5) < keyArray.count{
                    buttons![i].setTitle(keyArray[i + ((multiplier - 1)  * 5)], forState: .Normal)
                }else{
                    buttons![i].setTitle("", forState: .Normal)
                }
            }
        }else{
            displayText.text = "no more results"
        }
        
    }
    @IBAction func previous5ButtonPressed(sender: AnyObject) {
        
        if multiplier > 1{
            multiplier--
            displayText.text = "displaying the previous 5 results"
            for(var i = 0; i < 5; i++){
                if i + ((multiplier - 1)  * 5) < keyArray.count{
                    buttons![i].setTitle(keyArray[i + ((multiplier - 1)  * 5)], forState: .Normal)
                }else{
                    buttons![i].setTitle("", forState: .Normal)
                }
            }
        }else{
            displayText.text = "no previous enquete results"
        }
        
    }
    
    
    func writeText(a: String, b:String, c:String, d:String){
        
        displayText.text = "This session results were: \r\nAnswer a : " + a + "\r\nAnswer b: " + b + "\r\nAnswer c: " + c + "\r\nAnswer d: " + d
    }
    
    
    
    
    
}
