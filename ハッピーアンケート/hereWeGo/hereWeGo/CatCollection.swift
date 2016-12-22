//
//  CatCollection.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/22/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit
import Firebase


class CatCollection: UICollectionViewController {

    var reuseIdentifier:String = "catCell"
    var catsSection:Array<Array<AnyObject>>?
    let settingsref = Firebase(url:"https://flickering-heat-2294.firebaseio.com/web/saving-data/settings")
    
    var header:MySupplementaryView?
    
    @IBOutlet var catCollection: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catCollection.backgroundColor = UIColor.grayColor()
        clearsSelectionOnViewWillAppear = true
        
    }
    
    
    override func collectionView(collectionVIew: UICollectionView, numberOfItemsInSection section:Int) ->Int{
        return cats.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        
        if cats[indexPath.row].isVisible{
            cell.catImageDisplay.image = UIImage(named: cats[indexPath.row].image)!
        }else{
            cell.catImageDisplay.image = UIImage(named: cats[indexPath.row].backImage)!
        }
        
        
        if cats[indexPath.row].isCharacter{
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
            
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "catHeader", forIndexPath: indexPath) as? MySupplementaryView
            
            header?.headerCatLabel.text = actualCollection! + " is Selected"
            header?.headerCatButton.setTitle("select", forState: .Normal)
            
        }
        if kind == UICollectionElementKindSectionFooter{
            
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "catFooter", forIndexPath: indexPath) as? MySupplementaryView
            
            header?.footerCatButton.setTitle("Back To Main Menu", forState: .Normal)
            
        }
        
        return header!
    }
    
    @IBAction func catButtonPressed(sender: AnyObject) {
        let stuff = ["actual_collection": "Cat"]
        settingsref.updateChildValues(stuff)
        actualCollection = "Cat"
        
        header?.headerCatLabel.text = "Cat is Selected"
        
    }
    
}
