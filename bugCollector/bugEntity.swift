//
//  bugEntity.swift
//  bugCollector
//
//  Created by sdev on 10/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//

import Foundation
import SpriteKit

class bugEntity : SKSpriteNode
{
    var targetPoint : CGPoint
    var dirVec : CGPoint
    var dist : CGPoint
    var velocity : CGFloat
    var team : Int
    var level : Int
    
    init (texture: SKTexture?, color: UIColor, size: CGSize, team: Int)
    {
        
        self.targetPoint = CGPoint(x: 1.0,y: 1.0)
        self.team = team
        self.dirVec = CGPoint(x: 0, y: 0)
        self.dist = CGPoint(x: 0, y: 0)
        self.level = 1
        self.velocity = 1.8
        super.init(texture: texture, color: color, size: size)
        self.targetPoint = randPos()
        position = randPos()
        self.newDirection()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func checkClose()->Bool
    {
        let x = targetPoint.x - position.x
        let y = targetPoint.y - position.y
        
        return(x <= 15 && x >= -15 && y <= 15 && y >= -15 )
    }
    
    func checkDist()->Bool
    {
        let l = sqrt(pow(dist.x, 2) + pow(dist.y, 2))
        return(l >= 200)
    }
    
    func randPos()->CGPoint
    {
        let screenSize = UIScreen.main.bounds
        
        let rw = screenSize.width/1.95 - position.x
        let lw = -screenSize.width/1.95 - position.x
        
        let th = screenSize.height/1.95 - position.y
        let bh = -screenSize.height/1.95 - position.y
        
        let nx = position.x + ((CGFloat(arc4random()) / 0xFFFFFFFF) * (rw - lw) + lw)
        let ny = position.y + ((CGFloat(arc4random()) / 0xFFFFFFFF) * (th - bh) + bh)
        return CGPoint(x: nx, y: ny)
    }
    
    func newDirection()
    {
        var newX = (targetPoint.x - position.x)
        var newY = (targetPoint.y - position.y)
        let norm = sqrt(pow(newX, 2) + pow(newY, 2))
        newX = (newX/norm)*velocity
        newY = (newY/norm)*velocity
        dirVec = CGPoint(x: newX, y: newY)
    }
    
    func moveToPoint()
    {
        
        position.x += dirVec.x
        position.y += dirVec.y
        
        dist.x += dirVec.x
        dist.y += dirVec.y
        
        if(checkClose() || checkDist())
        {
            targetPoint = randPos()
            dist = CGPoint(x: 0, y: 0)
            newDirection()
        }
    }
}
