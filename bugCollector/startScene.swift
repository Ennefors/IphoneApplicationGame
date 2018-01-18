//
//  startScene.swift
//  bugCollector
//
//  Created by sdev on 12/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//

import Foundation
import SpriteKit

class startScene: SKScene {
    
    var myLabel = SKLabelNode()
    
    
    
    
    override func didMove(to view: SKView)
    {
        
        
        myLabel.text = "Touch to begin"
        myLabel.fontSize = 65
        myLabel.fontColor = UIColor.black
        myLabel.position = CGPoint(x:0,y:0)
        myLabel.zPosition = 4
        self.addChild(myLabel)
    }

    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      let gameSceneTemp = GameScene(fileNamed: "GameScene.sks")
        self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
    }
    

    
   
    
    
    override func update(_ currentTime: TimeInterval) {
        
}
    
}
