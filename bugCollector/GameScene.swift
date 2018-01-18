//
//  GameScene.swift
//  bugCollector
//
//  Created by sdev on 09/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bugs : [bugEntity] = []
    var Lines = [Line?](repeating: nil, count: 5)
    var fingers = [String?](repeating: nil, count: 5)
    var dicLin : [String: Line] = [:]
    var nrt : Int = 0
    var timeSpent : Double = 0
    var vtimer : Double = 0
    var player1Score=0
    var player2Score=0
    var player1name = " "
    var player2name = " "
    var p1win : Bool = false
    var p2win : Bool = false
    var Player1 : SKLabelNode = SKLabelNode(text: String(format: "Score = %d", 0))
    var Player2 : SKLabelNode = SKLabelNode(text: String(format: "Score = %d", 0))
    var Player1wl : SKLabelNode = SKLabelNode(text: String("Player 1 Wins!"))
    var Player2wl : SKLabelNode = SKLabelNode(text: String("Player 2 Wins!"))
    
    
    var intarr = [Int] ()
    var stringarr = [String] ()
    var gameEnd : Bool = false
    
    weak var viewController : GameViewController?
    
    
    
    override func didMove(to view: SKView) {
        for index in 1...25 {
            var tex : SKTexture = SKTexture(image: #imageLiteral(resourceName: "Spaceship"))
            
            switch index%5 {
            case 0:
                tex = SKTexture(image: #imageLiteral(resourceName: "BugBlue"))
                break
            case 1:
                tex = SKTexture(image: #imageLiteral(resourceName: "BugRed"))
                break
            case 2:
                tex = SKTexture(image: #imageLiteral(resourceName: "BugGreen"))
                break
            case 3:
                tex = SKTexture(image: #imageLiteral(resourceName: "BugYell"))
                break
            case 4:
                tex = SKTexture(image: #imageLiteral(resourceName: "BugPurp"))
                break
            default:
                break
            }
            
            let bug = bugEntity(texture: tex, color: UIColor.blue, size: CGSize(width: 35, height: 35), team:index%5)
            bugs.append(bug)
            self.addChild(bug)
        }
        let screen = UIScreen.main.bounds
        Player1.position = CGPoint(x: screen.width/2.7, y: screen.width/2.7)
        Player2.position = CGPoint(x: -screen.width/2.7, y: screen.width/2.7)
        Player1.fontColor = UIColor.red
        Player2.fontColor = UIColor.blue
        Player1.fontSize = 25
        Player2.fontSize = 25
        Player1.zPosition = 10
        Player2.zPosition = 10
        
        Player1wl.position = CGPoint(x: 0, y: 0)
        Player2wl.position = CGPoint(x: 0, y: 0)
        Player1wl.fontColor = UIColor.blue
        Player2wl.fontColor = UIColor.red
        Player1wl.fontSize = 44
        Player2wl.fontSize = 44
        Player1wl.alpha = 0
        Player2wl.alpha = 0
        Player1wl.zPosition = 5
        Player2wl.zPosition = 5
        
        self.addChild(Player1wl)
        self.addChild(Player2wl)
        
        self.addChild(Player1)
        self.addChild(Player2)
        
        
        let userdata = UserDefaults.standard
        player1name = userdata.string(forKey: "playeroneName")!
        player2name = userdata.string(forKey: "playertwoName")!
        intarr = userdata.array(forKey: "SavedIntArray") as? [Int] ?? [Int]()
        stringarr = userdata.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        
    }
    
    func touchDown(atPoint pos : CGPoint, key: String) {
        let L = Line()
        L.addPoint(point: pos)
        dicLin.updateValue(L, forKey: key)
        //print(key)
    }

    
    func touchMoved(toPoint pos : CGPoint, key: String) {
        dicLin[key]?.addPoint(point: pos)
    }
    
    func touchUp(atPoint pos : CGPoint, key: String) {
        if (dicLin[key]?.endLine(point: pos, bugs: &self.bugs))!
        {
            self.addChild(bugs.last!)
        }
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            self.dicLin[key]?.path.removeFromParent()
            self.dicLin.removeValue(forKey: key)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nrt+=1
        if nrt >= 9
        {
            nrt = 0
        }
        for t in touches
        {
            for(index, finger) in fingers.enumerated()
            {
                if finger == nil
                {
                    fingers[index] = (String(format: "%p", t))
                    self.touchDown(atPoint: t.location(in: self), key: fingers[index]!)
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches
        {
            for(index, finger) in fingers.enumerated()
            {
                if let finger = finger , finger == String(format: "%p", t)
                {
                    self.touchMoved(toPoint: t.location(in: self), key: fingers[index]!)
                    break
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches
        {
            for(index, finger) in fingers.enumerated()
            {
                if let finger = finger , finger == String(format: "%p", t)
                {
                    self.touchUp(atPoint: t.location(in: self), key: fingers[index]!)
                    fingers[index] = nil
                    break
                }
            }
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches
        {
            for(index, finger) in fingers.enumerated()
            {
                if let finger = finger , finger == String(format: "%p", t)
                {
                    self.touchUp(atPoint: t.location(in: self), key: fingers[index]!)
                    fingers[index] = nil
                    break
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        timeSpent += 1/60
        
        if timeSpent >= 1
        {
            player1Score += 1
            player2Score += 1
            if !p1win{
                Player1.text = String(format: "Score = %d", player1Score)
            }
            else
            {
                Player1wl.alpha = 1
                let when = DispatchTime.now() + 1
                if !gameEnd
                {
                    gameEnd = true
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        var tempscore = self.player1Score
                    
                        var tempname = self.player1name
                        for index in 0 ... self.intarr.count-1
                        {
                        
                            if (tempscore <  self.intarr[index] && index < 10)
                            {
                                let tempname2 = self.stringarr[index]
                                let tempscore2 = self.intarr[index]
                                self.stringarr[index] = tempname
                                self.intarr[index] = tempscore
                                tempname = tempname2
                                tempscore = tempscore2
                            
                            
                            }
                        
                            let userdata = UserDefaults.standard
                            userdata.set(self.intarr, forKey: "SavedIntArray")
                            userdata.set(self.stringarr, forKey: "SavedStringArray")
                        }
                    self.viewController?.performSegue(withIdentifier: "toMenu",sender: nil)
                    }
                }
            }
            if !p2win{
                Player2.text = String(format: "Score = %d", player2Score)
            }
            else
            {
                Player2wl.alpha = 1
                let when = DispatchTime.now() + 1
                
                if !gameEnd
                {
                    gameEnd = true
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        var tempscore = self.player2Score
                        
                        var tempname = self.player2name
                        for index in 0 ... self.intarr.count-1
                        {
                            
                            if (tempscore <  self.intarr[index] && index < 10)
                            {
                                let tempname2 = self.stringarr[index]
                                let tempscore2 = self.intarr[index]
                                self.stringarr[index] = tempname
                                self.intarr[index] = tempscore
                                tempname = tempname2
                                tempscore = tempscore2
                                
                                
                            }
                            
                            let userdata = UserDefaults.standard
                            userdata.set(self.intarr, forKey: "SavedIntArray")
                            userdata.set(self.stringarr, forKey: "SavedStringArray")
                        }
                        self.viewController?.performSegue(withIdentifier: "toMenu",sender: nil)
                    }
                }
            }
            timeSpent = 0
        }
        for item in bugs {
            item.moveToPoint()
            switch item.team {
            case 0:
                if item.level > 4
                {
                    p1win = true
                }
                break
            case 1:
                if item.level > 4
                {
                    p2win = true
                }
                break
            default:
                break
            }
        }
        for item in dicLin
        {
            item.value.path.removeFromParent()
            item.value.drawLine()
            self.addChild(item.value.path)
        }
    }
}
