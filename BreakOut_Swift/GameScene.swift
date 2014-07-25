//
//  GameScene.swift
//  BreakOut_Swift
//
//  Created by apple on 2014/7/21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

import SpriteKit


let background:SKNode = SKNode()
var table:SKSpriteNode = SKSpriteNode()
var ball:SKSpriteNode = SKSpriteNode()
var wall:SKSpriteNode = SKSpriteNode()

var score:Int = 0
var label_score:SKLabelNode = SKLabelNode()

let FSBoundaryCategory:UInt32 = 1 << 0
let FSTableCategory:UInt32 = 1 << 1
let FSBallCategory:UInt32 = 1 << 2
let FSWallCategory:UInt32 = 1 << 3

var TouchsTableState:Bool = false

enum BOGameState: Int {
    case BOGameStateStarting
    case BOGameStatePlaying
    case BOGameStateEnded
}

var state:BOGameState = .BOGameStateStarting


class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    override func didMoveToView(view: SKView) {

        scene.scaleMode = .AspectFill
        /* Setup your scene here */
        initWorld()
        initBackground()
        initTable()
        initBall()
        initWall()
        initScore()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        //touches.count 為一次多點觸控數`
        
        if state == .BOGameStateStarting {
            state = .BOGameStatePlaying
            score = 0
            ball.physicsBody.applyImpulse(CGVectorMake(12, 12))
        }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (location.x <= table.position.x + table.size.width/2) && (location.x >= table.position.x - table.size.width/2) {
                TouchsTableState = true
            }else{
                TouchsTableState = false
            }
            //if table.position.x location.x
            
        }
    }
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            table.physicsBody.affectedByGravity = true
            if (TouchsTableState){
                table.position.x = table.position.x + (location.x - table.position.x)
            }
            if (table.position.x + table.size.width/2 > self.size.width){
                table.position.x = self.size.width - table.size.width/2
            }else if (table.position.x - table.size.width/2 < 0) {
                table.position.x = table.size.width/2
            }

        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    
    func initWorld(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -0.1)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0 , 100, self.size.width, self.size.height-200))
        self.physicsBody.categoryBitMask = FSBoundaryCategory
        self.physicsBody.collisionBitMask = FSBallCategory
        self.name = "world"
    }
    
    func initBackground(){
        self.addChild(background)
        let bgimg = SKSpriteNode(imageNamed: "background")
        bgimg.anchorPoint = CGPointZero
        bgimg.name = "bg"
        bgimg.zPosition = 10
        background.addChild(bgimg)
    }
    
    func initTable(){
        table = SKSpriteNode(imageNamed: "table")
        table.name = "table"
        table.position = CGPointMake(CGRectGetMidX(self.frame),table.size.height+200)
        //大小
        table.physicsBody = SKPhysicsBody(rectangleOfSize: table.size)
        //類別
        table.physicsBody.categoryBitMask = FSTableCategory
        //反彈0~1
        table.physicsBody.restitution = 0.2
        //允許選轉
        //table.physicsBody.allowsRotation = false
        //重力
        table.physicsBody.affectedByGravity = false
        //Ｚ軸
        table.zPosition = 20
        //摩擦力
        table.physicsBody.friction = 0.0
        table.physicsBody.dynamic = false
        //table.physicsBody.linearDamping = 0.0
        table.physicsBody.collisionBitMask = FSBallCategory
        table.physicsBody.contactTestBitMask = FSBallCategory
        
        self.addChild(table)
    }
    func initBall(){

        ball = SKSpriteNode(imageNamed: "Ball")
        ball.name = "ball"
        ball.position = CGPointMake(CGRectGetMidX(self.frame), table.position.y + table.size.height + 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        //ball.physicsBody = SKPhysicsBody(edgeLoopFromRect: background.frame)
        
        ball.physicsBody.categoryBitMask = FSBallCategory
        ball.physicsBody.restitution = 1
        ball.physicsBody.allowsRotation = false
        ball.physicsBody.affectedByGravity = true
        ball.zPosition = 50
        ball.physicsBody.contactTestBitMask = FSTableCategory | FSBoundaryCategory
        ball.physicsBody.collisionBitMask = FSBoundaryCategory | FSTableCategory | FSWallCategory
        ball.physicsBody.linearDamping = 0.0
        ball.physicsBody.friction = 0.0
        self.addChild(ball)
        
    }
    
    func initWall(){
        
        for i:CGFloat in 0...8 {
            for j:CGFloat in 0...6 {
                
                wall = SKSpriteNode(imageNamed: "table")
                wall.name = "wall"
                //大小
                wall.physicsBody = SKPhysicsBody(rectangleOfSize: table.size)
                //類別
                wall.physicsBody.categoryBitMask = FSWallCategory
                //反彈0~1
                wall.physicsBody.restitution = 0.1
                //允許選轉
                //table.physicsBody.allowsRotation = false
                //重力
                wall.physicsBody.affectedByGravity = false
                //Ｚ軸
                wall.zPosition = 20
                //摩擦力
                wall.physicsBody.friction = 0.0
                wall.physicsBody.dynamic = false
                //table.physicsBody.linearDamping = 0.0
                wall.physicsBody.collisionBitMask = FSBallCategory
                wall.physicsBody.contactTestBitMask = FSBallCategory
                
                wall.position = CGPointMake( (100 * i + 115),self.size.height-(200 + j*20))
                self.addChild(wall)
            }
        }
    }
    func initScore(){
        label_score = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        label_score.position = CGPointMake(25,620)
        label_score.text = "0"
        label_score.zPosition = 50
        self.addChild(label_score)
        
    }
    func didBeginContact(contact: SKPhysicsContact!) {
        let collision:UInt32 = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
        if collision == (FSTableCategory | FSBallCategory) {
            //println("touch!!")
            ball.physicsBody.applyImpulse(CGVectorMake(1.2, 2))
        }
        
        if collision == (FSWallCategory | FSBallCategory){
            contact.bodyA.node.removeFromParent()
            score++
            label_score.text = "\(score)"
            if self.children.count == 3 {

                state = .BOGameStateEnded
                self.removeAllChildren()
                var actionMoveDone = SKAction.removeFromParent()
                var winAction = SKAction.runBlock({
                    var reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    var gameOverScene = GameOverScene(size: self.size, won: true)
                    self.view.presentScene(gameOverScene, transition: reveal)
                    })
                runAction(SKAction.sequence([winAction,actionMoveDone]))
                state = .BOGameStateStarting
            }
        }
        if collision == (FSBallCategory | FSBoundaryCategory){
            
            if contact.bodyB.node.position.x > 1007 {
                ball.physicsBody.applyImpulse(CGVectorMake(-2,1))
            }
            if contact.bodyB.node.position.y < 125 {
                state = .BOGameStateEnded
                self.removeAllChildren()
                var actionMoveDone = SKAction.removeFromParent()
                var loseAction = SKAction.runBlock({
                    var reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    var gameOverScene = GameOverScene(size: self.size, won: false)
                    self.view.presentScene(gameOverScene, transition: reveal)
                    })
                runAction(SKAction.sequence([loseAction,actionMoveDone]))
                state = .BOGameStateStarting
            }
            
        }
    }
}
