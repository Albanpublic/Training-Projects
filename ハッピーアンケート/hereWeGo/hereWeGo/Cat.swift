//
//  Cat.swift
//  hereWeGo
//
//  Created by ゼミけん on 2/18/16.
//  Copyright © 2016 zemiken. All rights reserved.
//


class Cat{
    
    var image:String = ""
    var backImage:String = "question-mark"
    var isVisible:Bool = false
    var isCharacter:Bool = false
    
    init(image:String, backImage:String, isVisible:Bool, isCharacter:Bool){
        self.image = image
        self.backImage = backImage
        self.isVisible = isVisible
        self.isCharacter = isCharacter
    }
    
}