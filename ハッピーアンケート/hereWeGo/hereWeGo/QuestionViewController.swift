//
//  QuestionViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 1/27/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionViewController: UIViewController {
    

    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var firstBubbleView: UIImageView!
    @IBOutlet weak var secondBubbeView: UIImageView!
    @IBOutlet weak var questionBG: UIImageView!
    
    
    
    @IBOutlet weak var previousPageButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var continueCount = 0
    var pageObject:[NSObject] = [NSObject]()
    var introductionText:String = "Here Comes the Next Question"
    
    var questionIndex:Int = 0
    
    var questionDictionary = [Int:String]()
    var answers:[Int] = [0, 0, 0, 0]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createQuestions()

        pageObject.append(characterImage)
        pageObject.append(firstBubbleView)
        pageObject.append(secondBubbeView)
        pageObject.append(answer1Button)
        pageObject.append(answer2Button)
        pageObject.append(answer3Button)
        pageObject.append(answer4Button)
        
        firstBubbleView.image = textToImage(introductionText, inImage: UIImage(named: "bubble1")!, atPoint: CGPoint(x: 10, y: 25))
        secondBubbeView.image = textToImage(questionDictionary[questionIndex]!, inImage: UIImage(named: "bubble2")!, atPoint: CGPoint(x: 10, y: 45))
        

        characterImage.image = UIImage(named: actualCharacter)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //To create an image with a text inside
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
    

    @IBAction func continuePressed(sender: AnyObject) {
        if let button = pageObject[continueCount] as? UIButton{
            button.hidden = false
        }else if let image = pageObject[continueCount] as? UIImageView{
            image.hidden = false
        }
        
        continueCount++
        if(continueCount == pageObject.count){
            continueButton.hidden = true
        }
        
    }
    
    @IBAction func answer1Pressed(sender: AnyObject) {
        answers[0]++
        if(questionIndex == questionDictionary.count - 1 ){
            performSegueWithIdentifier("fromQuestionToResult", sender: self)
        }else{
            resetScreen()
        }
    }
    @IBAction func answer2Pressed(sender: AnyObject) {
        answers[1]++
        if(questionIndex == questionDictionary.count - 1 ){
            performSegueWithIdentifier("fromQuestionToResult", sender: self)
        }else{
            resetScreen()
        }
    }
    @IBAction func answer3Pressed(sender: AnyObject) {
        answers[2]++
        if(questionIndex == questionDictionary.count - 1 ){
            performSegueWithIdentifier("fromQuestionToResult", sender: self)
        }else{
            resetScreen()
        }
    }
    @IBAction func answer4Pressed(sender: AnyObject) {
        answers[3]++
        if(questionIndex == questionDictionary.count - 1 ){
            performSegueWithIdentifier("fromQuestionToResult", sender: self)
        }else{
            resetScreen()
        }
    }
    
    func resetScreen(){
        questionIndex++
        continueCount = 0
        
        for var i:Int = 0; i < pageObject.count; i++ {
            if let button = pageObject[i] as? UIButton{
                button.hidden = true
            }else if let image = pageObject[i] as? UIImageView{
                image.hidden = true
            }
        }
        
        firstBubbleView.image = textToImage(introductionText, inImage: UIImage(named: "bubble1")!, atPoint: CGPoint(x: 10, y: 25))
        secondBubbeView.image = textToImage(questionDictionary[questionIndex]!, inImage: UIImage(named: "bubble2")!, atPoint: CGPoint(x: 10, y: 45))
        
        continueButton.hidden = false
        
    }
    
    func createQuestions(){
        questionDictionary[0] = "question 1"
        questionDictionary[1] = "question 2"
        questionDictionary[2] = "question 3"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromQuestionToResult"){
            if let destination = segue.destinationViewController as? RewardViewController{
                destination.answers = answers
            }
        }
    }

}
