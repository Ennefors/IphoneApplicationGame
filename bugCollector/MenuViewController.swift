//
//  MenuViewController.swift
//  bugCollector
//
//  Created by sdev on 12/10/17.
//  Copyright © 2017 sdev. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuViewController: UIViewController
{
    //@IBOutlet weak var HighScore: UITextField!
    
    @IBOutlet weak var HighScoreView: UITextView!
    @IBOutlet weak var playerOneName: UITextField!
    
    @IBOutlet weak var playerTwoName: UITextField!
    
    
    var NewHighscoreCombined =  String()
    var playerOne = " "
    var playerTwo = " "
    var mystringarray = [String] ()
    var myintarray = [Int] ()
    
    @IBAction func StartandUpdatenames(_ sender: AnyObject) {
        let userdefaults = UserDefaults.standard
        
        userdefaults.set(playerOneName.text,forKey: "playeroneName")
        userdefaults.set(playerTwoName.text,forKey: "playertwoName")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "startScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let userdefaults = UserDefaults.standard
                
                if (userdefaults.string(forKey: "playeroneName") != nil )
                {
                    mystringarray = userdefaults.stringArray(forKey: "SavedStringArray") ?? [String] ()
                    myintarray = userdefaults.array(forKey: "SavedIntArray") as? [Int] ?? [Int]()
                    playerOne = userdefaults.string(forKey: "playeroneName")!
                    playerTwo = userdefaults.string(forKey: "playertwoName")!
                    playerTwoName.text = userdefaults.string(forKey: "playertwoName")!
                    playerOneName.text = userdefaults.string(forKey: "playeroneName")!
                    
                  
                }
                else
                {
                    playerOne = "Randomname"
                    playerTwo = "Randomname"
                    playerOneName.text = "Randomname"
                    playerTwoName.text = "Randomname"
                    for _ in 0...9
                    {
                        mystringarray.append("randomname")
                        myintarray.append(999999)
                       
                        
                    }
                    userdefaults.set(mystringarray,forKey: "SavedStringArray")
                    userdefaults.set(myintarray,forKey: "SavedIntArray")
                    userdefaults.set(playerOneName.text,forKey: "playeroneName")
                    userdefaults.set(playerTwoName.text,forKey: "playertwoName")
                }
           
                if myintarray.count > 1 && mystringarray.count > 1
                {
                    for item in 0...9
                    {
                    
                        NewHighscoreCombined += (mystringarray[item] +
                            " " + String(myintarray[item]) + "\n")
                    }
                    HighScoreView.text = NewHighscoreCombined
                }
                
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
}
}
