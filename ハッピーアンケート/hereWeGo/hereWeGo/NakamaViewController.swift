//
//  NakamaViewController.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/3/16.
//  Copyright © 2016 zemiken. All rights reserved.
//

import UIKit

class NakamaViewController: UIViewController {
    
    
    @IBOutlet weak var nakamaStorage: UICollectionView!
    @IBOutlet weak var nakamaBG: UIImageView!
    @IBOutlet weak var nakamaLabel: UILabel!
    
    
    
    var numberOfCharacter = 0
    var characters:[NSObject] = [NSObject]()
    
    let reuseIdentifier:String = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nakamaStorage.backgroundColor = UIColor.clearColor()
        nakamaLabel.text = "Selected character is " + actualCharacter
        
        for(var i = 0; i < cats.count; i++){
            if cats[i].isCharacter{
                print("adding a cat")
                characters.append(cats[i])
            }
        }
        for(var i = 0; i < dogs.count; i++){
            if dogs[i].isCharacter{
                print("adding a dog")
                characters.append(dogs[i])
            }
        }
        
    }
    
    func collectionView(collectionVIew: UICollectionView, numberOfItemsInSection section:Int) ->Int{

        print("the number of cells will be\(characters.count)")
        return characters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        
            if let char = characters[indexPath.row]as? Cat{
                if char.isVisible{
                    cell.nakamaImageDisplay.image = UIImage(named: char.image)
                }else{
                    cell.nakamaImageDisplay.image = UIImage(named: char.backImage)
                }
            }else if let char = characters[indexPath.row] as? Dog{
                if char.isVisible{
                    cell.nakamaImageDisplay.image = UIImage(named: char.image)
                }else{
                    cell.nakamaImageDisplay.image = UIImage(named: char.backImage)
                }
            }
        
        
        cell.backgroundColor = UIColor.yellowColor()
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath){
        if let char = characters[indexPath.row]as? Cat{
            if char.isVisible{
                actualCharacter = char.image
                nakamaLabel.text = "Selected character is " + actualCharacter
            }
        }else if let char = characters[indexPath.row] as? Dog{
            if char.isVisible{
                actualCharacter = char.image
                nakamaLabel.text = "Selected character is " + actualCharacter
            }
        }
    }
    
//    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath){
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath)
//        cell?.backgroundColor = UIColor.greenColor()
//        cell?.layer.shadowColor = UIColor.blackColor().CGColor
//        cell?.layer.shadowOffset = CGSize(width: 10, height: 10)
//        cell?.layer.shadowOpacity = 1.0
//        cell?.layer.shadowRadius = 10.0
//    }

    

}
