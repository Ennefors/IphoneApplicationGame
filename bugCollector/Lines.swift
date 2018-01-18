//
//  Lines.swift
//  bugCollector
//
//  Created by sdev on 10/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//
import CoreGraphics
import SpriteKit
import Foundation

class Line
{
    var wayPoints: [CGPoint] = []
    var nrOfPoints: Int
    var ubpath = UIBezierPath()
    var path : SKShapeNode
    var intersected : Bool = false
    var sbupd : Bool = true
    
    init()
    {
        nrOfPoints = 0
        ubpath.lineWidth = 2
        path = SKShapeNode(path: self.ubpath.cgPath)
    }
    
    func addPoint(point: CGPoint)
    {
        wayPoints.append(point)
    }
    
    
    func drawLine()
    {
        if (wayPoints.count > 4 && !self.intersected && self.sbupd)
        {
            for i in 0 ..< wayPoints.count-3
            {
            
                if CheckIntersections(wayPoints[i],
                                            wayPoints[i+1],
                                            wayPoints[wayPoints.count-2],
                                            wayPoints.last!)! && wayPoints[i+1] != wayPoints[wayPoints.count-1]
                    {
                        self.intersected = true
                        break
                    }
            
            }
        }
        if !self.intersected
        {
            let ref = CGMutablePath()
            ref.addLines(between: wayPoints)
            ubpath = UIBezierPath(cgPath: ref)
            path = SKShapeNode(path: self.ubpath.cgPath)
            path.strokeColor = UIColor.blue
            path.lineWidth = 2
            if !sbupd
            {
                path.fillColor = UIColor.green
                path.zPosition = 2
            }
        }
        else
        {
            path.fillColor = UIColor.red
            path.zPosition = 2
            path.strokeColor = UIColor.red
        }
        
        
    }
    func CheckIntersections(_ p1 : CGPoint, _ p2: CGPoint, _ p3 : CGPoint, _ p4 : CGPoint) ->Bool?
    {
        var denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x ) * (p2.y - p1.y)
        var ua = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)
        var ub = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)
        
        if (denominator < 0 )
        {
            ua = -ua; ub = -ub; denominator = -denominator
        }
        
        if (ua >= 0.0 && ua <= denominator && ub >= 0.0 && ub <= denominator && denominator != 0)
        {
            //return CGPoint(x: p1.x + ua / denominator * (p2.x - p1.x), y: p1.y + ua / denominator * (p2.y - p1.y))
             return true
            
        }
        return false
    }
    
    func endLine(point:CGPoint,bugs: inout [bugEntity])->Bool
    {
        if self.intersected { return false }
        wayPoints.append(wayPoints[0])
        var nrofb = 0
        sbupd = false
        var indices : [Int] = []
        var iter = 0
        let ref = CGMutablePath()
        ref.addLines(between: wayPoints)
        ubpath = UIBezierPath(cgPath: ref)
        var sameTeam = true;
        var first = -1
        for item in bugs
        {
            if (ubpath.contains(item.position))
            {
                if first == -1
                {
                    first = item.team
                }
                switch item.team {
                case 0:
                    if first != item.team
                    {
                        sameTeam = false
                    }else
                    {
                        nrofb += 1
                        indices.append(iter)
                    }
                    break
                case 1:
                    if first != item.team
                    {
                        sameTeam = false
                    }else
                    {
                        nrofb += 1
                        indices.append(iter)
                    }
                    break
                    
                case 2:
                    if first != item.team
                    {
                        sameTeam = false
                    }else
                    {
                        nrofb += 1
                        indices.append(iter)
                    }
                    break
                    
                case 3:
                    if first != item.team
                    {
                        sameTeam = false
                    }else
                    {
                        nrofb += 1
                        indices.append(iter)
                    }
                    break
                    
                case 4:
                    if first != item.team
                    {
                        sameTeam = false
                    } else
                    {
                        nrofb += 1
                        indices.append(iter)
                    }
                    break
                default: break
                }
                
            }
            iter += 1
        }
        if nrofb > 1 && sameTeam
        {
            var totlvl = 0
            var point : CGPoint = CGPoint(x: 0, y: 0)
            for item in indices.reversed()
            {
                totlvl+=bugs[item].level
                point = bugs[item].position
                bugs[item].removeFromParent()
                bugs.remove(at: item)
            }
            var tex : SKTexture = SKTexture(image: #imageLiteral(resourceName: "Spaceship"))
            
            switch first
            {
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
            
            let bug = bugEntity(texture: tex, color: UIColor.blue, size: CGSize(width: 35*(totlvl), height: 35*(totlvl)), team: first)
            bug.level += totlvl - 1
            bug.position = point
            bugs.append(bug)
            return true
        }
        return false
    }
   
}
