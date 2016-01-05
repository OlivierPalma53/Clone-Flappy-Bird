//
//  GameScene.swift
//  FlappyBird
//
//  Created by Olivier Palma on 11/12/15.
//  Copyright (c) 2015 Olivier Palma. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var gameOver = false
    var gameOverLabel = SKLabelNode()
    var score = 0
    var scoreLabel = SKLabelNode()
    var movingObjects = SKSpriteNode()
    var labelContainer = SKSpriteNode()
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makeBg()
        
        scoreLabel.fontName = "Helvetia"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - 70)
        
        self.addChild(scoreLabel)
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.dynamic = true
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue

        self.addChild(ground)
        
        let gapHeight = birdTexture.size().height * 4
        
        let movimentAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movimentAmount) - self.frame.size.height / 4
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
        
        pipe1.runAction(moveAndRemovePipes)
        
        self.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeOffset)
        
        pipe2.runAction(moveAndRemovePipes)
        
        self.addChild(pipe2)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        

        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score++
            scoreLabel.text = String(score)
            
        } else {
            if gameOver == false {
                
                gameOver = true
                self.speed = 0
                
                gameOverLabel.fontName = "Helvetia"
                gameOverLabel.fontSize = 20
                gameOverLabel.text = "Fim de Jogo! Toque para jogar novamente"
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                
                labelContainer.addChild(gameOverLabel)

            }
            
        }
        
        
    }
    
    func makePipes (){
        
        let gapHeight = bird.size.height * 4
        
        let movimentAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movimentAmount) - self.frame.size.height / 4
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
        
        pipe1.runAction(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe1.physicsBody!.dynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        movingObjects.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeOffset)
        
        pipe2.runAction(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size())
        pipe2.physicsBody!.dynamic = false
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        

        movingObjects.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.runAction(moveAndRemovePipes)
        
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: pipe1.size.width / 2, height: gapHeight))
        gap.physicsBody!.dynamic = false
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        movingObjects.addChild(gap)

        
    }
    
    func makeBg(){
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replaceBg]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width / 2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBgForever)
            bg.zPosition = -5
            
            self.addChild(bg)
        }

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameOver == false {
            
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 50))
            
        } else {
            
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            movingObjects.removeAllChildren()
            makeBg()
            gameOver = false
            self.speed = 1
            labelContainer.removeAllChildren()
            
            
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
