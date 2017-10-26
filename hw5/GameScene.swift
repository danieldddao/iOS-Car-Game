//
//  GameScene.swift
//  hw5
//
//  Created by Daniel Dao on 10/6/17.
//  Copyright © 2017 Daniel Dao. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var roadfield:SKSpriteNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0
    
    var gameTimer:Timer!
    var isGameOver = false
    
    var carBlocks = ["ambulance", "police", "taxi", "truck"]
    
    let playerCat:UInt32 = 0x1 << 0
    let carBlockCat:UInt32 = 0x1 << 1

    override func didMove(to view: SKView) {
        isGameOver = false
        
        roadfield = SKSpriteNode(imageNamed: "road")
        roadfield.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addChild(roadfield)
        roadfield.zPosition = -1
        
        let playerTexture = SKTexture(imageNamed: "player")
        player = SKSpriteNode(texture: playerTexture)
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height)
        player.physicsBody = SKPhysicsBody(texture: playerTexture,size: CGSize(width:player.size.width,height: player.size.height))
        player.physicsBody?.categoryBitMask = playerCat
        player.physicsBody?.contactTestBitMask = carBlockCat
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        player.zPosition = 0
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        score = 0
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.red
        scoreLabel.text = "Score: \(score)"

        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(addNewCarBlock), userInfo: nil, repeats: true)
    }
    
    @objc func addNewCarBlock () {
        let carBlockRandom = Int(arc4random_uniform(4))
        let carBlockTexture = SKTexture(imageNamed: carBlocks[carBlockRandom])
        let carBlock = SKSpriteNode(texture: carBlockTexture)
        
        let randomCarBlockPosition = Int(arc4random_uniform(400)) + 5
        let position = CGFloat(randomCarBlockPosition)
        carBlock.position = CGPoint(x: position, y: self.frame.size.height + carBlock.size.height)
        
        carBlock.physicsBody = SKPhysicsBody(texture: carBlockTexture,size: CGSize(width:carBlock.size.width,height: carBlock.size.height))
        carBlock.physicsBody?.isDynamic = true
        carBlock.physicsBody?.allowsRotation = false
        carBlock.physicsBody?.categoryBitMask = carBlockCat
        carBlock.physicsBody?.contactTestBitMask = playerCat | carBlockCat
        carBlock.physicsBody?.collisionBitMask = 0
        carBlock.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(carBlock)
        carBlock.zPosition = 1
        
        let animationDuration:TimeInterval = TimeInterval(Int(arc4random_uniform(7)) + 2)
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -carBlock.size.height), duration: animationDuration))
        actionArray.append(SKAction.run {
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
        })
        actionArray.append(SKAction.removeFromParent())
        carBlock.run(SKAction.sequence(actionArray))
        //        print("added new car block: \(String(describing: carBlocks[0]))")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == playerCat || contact.bodyB.categoryBitMask == playerCat {
            if isGameOver == false {
                isGameOver = true
                print("player hit a car, game over")
                let trans = SKTransition.crossFade(withDuration: 0)
                let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                gameOver.yourScore = self.score
                self.view?.presentScene(gameOver, transition: trans)
            }
        } else if contact.bodyA.categoryBitMask == carBlockCat && contact.bodyB.categoryBitMask == carBlockCat {
//            print("2 cars hit each other")
            if let explosion = SKEmitterNode(fileNamed: "explosion") {
                explosion.position = contact.bodyA.node!.position
                self.addChild(explosion)
            }
            let r = Int(arc4random_uniform(2))
            if r == 0 {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.run(SKAction.moveTo(x: location.x, duration: 0))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
