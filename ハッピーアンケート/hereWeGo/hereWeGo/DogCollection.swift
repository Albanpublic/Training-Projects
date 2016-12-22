//
//  DogCollection.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/22/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import Firebase

class DogCollection: UICollectionViewController {
    
    var reuseIdentifier:String = "dogCell"
    let settingsref = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data/settings")
    var header:MySupplementaryView?
    
    @IBOutlet var dogCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogCollection.backgroundColor = UIColor.grayColor()
        clearsSelectionOnViewWillAppear = true
        
    }
    
    
    override func collectionView(collectionVIew: UICollectionView, numberOfItemsInSection section:Int) ->Int{
        return dogs.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        
        if dogs[indexPath.row].isVisible{
            cell.dogImageDisplay.image = UIImage(named: dogs[indexPath.row].image)!
        }else{
            cell.dogImageDisplay.image = UIImage(named: dogs[indexPath.row].backImage)!
        }
        
        
        if dogs[indexPath.row].isCharacter{
            cell.layer.borderColor = UIColor.magentaColor().CGColor
            cell.layer.borderWidth = 3
        }else{
            cell.layer.borderColor = UIColor.grayColor().CGColor
            cell.layer.borderWidth = 1
        }
        
        cell.layer.cornerRadius = 25
        
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath){
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
        
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath){
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.greenColor()
        cell?.layer.shadowColor = UIColor.blackColor().CGColor
        cell?.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.shadowRadius = 10.0
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        if kind == UICollectionElementKindSectionHeader{
            
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "dogHeader", forIndexPath: indexPath) as? MySupplementaryView
            
            header?.headerDogLabel.text = actualCollection!  + " is Selected"
            header?.headerDogButton.setTitle("select", forState: .Normal)
            
            
        }
        if kind == UICollectionElementKindSectionFooter{
            
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "dogFooter", forIndexPath: indexPath) as? MySupplementaryView
            
            header?.footerDogButton.setTitle("Back To Main Menu", forState: .Normal)
            
        }
        
        return header!
    }
    
    @IBAction func dogButtonPressed(sender: AnyObject) {
        let stuff = ["actual_collection": "Dog"]
        settingsref.updateChildValues(stuff)
        actualCollection = "Dog"
        
        header?.headerDogLabel.text = "Dog is Selected"
    }
    
    
}
