//
//  GameOverScene.swift
//  BreakOut_Swift
//
//  Created by apple on 2014/7/25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    convenience init(size: CGSize, won: Bool) {
        self.init(size: size)
        self.backgroundColor = SKColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
        
        self.setupMsgLabel(isWon :won)
        self.directorAction()
    }
    func setupMsgLabel(isWon won: Bool) {
        var finalimg:NSString
        if won {
            finalimg = "youwin"
            
        }else{
            finalimg = "youlose"
        }
        
        var EndLabel = SKSpriteNode(imageNamed: finalimg)
        EndLabel.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(EndLabel)
    }
    
    func directorAction() {
        var actions: [AnyObject] = [ SKAction.waitForDuration(3.0), SKAction.runBlock({
            var reveal = SKTransition.flipHorizontalWithDuration(0.5)
            var gameScene = GameScene(size: self.size)
            self.view.presentScene(gameScene, transition: reveal)
            }) ]
        var sequence = SKAction.sequence(actions)
        scene.scaleMode = .AspectFill
        self.runAction(sequence)
        
        
    }
}