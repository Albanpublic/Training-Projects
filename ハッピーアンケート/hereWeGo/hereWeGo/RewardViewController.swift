//
//  ResultViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/10/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import Firebase

class RewardViewController: UIViewController {
    
    var answers:[Int] = [Int]()
    
    @IBOutlet weak var firstBubbleView: UIImageView!
    @IBOutlet weak var secondBubbleView: UIImageView!
    @IBOutlet weak var characterView: UIImageView!
    @IBOutlet weak var rewardView: UIImageView!
    @IBOutlet weak var resultBG: UIImageView!
    
    var firstBubbleText:String = "お疲れ様"
    var secondBubbleText:String = "Here comes your reward!!"
    
    
    
    let refcat = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/Cat")
    let refdog = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/Dog")
    let refnba = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/items/NBA")
    let resultsref = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/results")
    let settingsref = Firebase(url: "https://flickering-heat-2294.firebaseio.com/web/saving-data/settings")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstBubbleView.image = textToImage(firstBubbleText, inImage: UIImage(named: "bubble1")!, atPoint: CGPoint(x: 10, y: 25))
        secondBubbleView.image = textToImage(secondBubbleText, inImage: UIImage(named: "bubble2")!, atPoint: CGPoint(x: 10, y: 45))
        
        let timeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let results = ["A": String(answers[0]), "B": String(answers[1]), "C": String(answers[2]), "D": String(answers[3])]
        let dateResults = [String(timeStamp): results]
        
        resultsref.updateChildValues(dateResults)
        
        
            
        characterView.image = UIImage(named: actualCharacter)
         
        
        
        
        
        if actualCollection == "Cat"{
            var nonObtained = [Cat]()
            
            for(var i:Int = 0; i < cats.count; i++){
                if(cats[i].isVisible == false){
                    nonObtained.append(cats[i])
                }
            }
            print("number of non visible stuff" + String(nonObtained.count))
            var reward: Cat
            if(nonObtained.count > 1){
                let rand = Int(arc4random_uniform(UInt32(nonObtained.count)))
                reward = nonObtained[rand]
                rewardView.image = UIImage(named: reward.image)
                reward.isVisible = true
                refcat.childByAppendingPath(reward.image).updateChildValues(["visible" : true])
                
            }else if(nonObtained.count == 1){
                reward = nonObtained[0]
                rewardView.image = UIImage(named: reward.image)
                reward.isVisible = true
                refcat.childByAppendingPath(reward.image).updateChildValues(["visible" : true])
                
            }else{
                rewardView.image = UIImage(named: "Calvin")
            }
            
        }else if actualCollection == "Dog"{
            var nonObtained = [Dog]()
            
            for(var i:Int = 0; i < dogs.count; i++){
                if(dogs[i].isVisible == false){
                    nonObtained.append(dogs[i])
                }
            }
            
            var reward: Dog
            if(nonObtained.count > 1){
                let rand = Int(arc4random_uniform(UInt32(nonObtained.count)))
                reward = nonObtained[rand]
                rewardView.image = UIImage(named: reward.image)
                refdog.childByAppendingPath(reward.image).updateChildValues(["visible" : true])
                
            }else if(nonObtained.count == 1){
                reward = nonObtained[0]
                rewardView.image = UIImage(named: reward.image)
                refdog.childByAppendingPath(reward.image).updateChildValues(["visible" : true])
                
            }else{
                rewardView.image = UIImage(named: "Calvin")
            }
            
            
        }
        

        
    }
    
    func textToImage(drawText: String, inImage: UIImage, atPoint: CGPoint) ->UIImage{
        
        //Setup the font
        let textColor: UIColor = UIColor.blackColor()
        let textFont: UIFont = UIFont(name: "Helvetica", size: 8)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setup the font
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the Image in a rectangle
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        //Creating a point to start writing
        let rect:CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Drawing the text into the image
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        //Create an new Image with what we made
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //End the context
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromResultToMain"){
        }
    }

}
