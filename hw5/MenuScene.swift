//
//  MenuScene.swift
//  hw5
//
//  Created by Daniel Dao on 10/6/17.
//  Copyright © 2017 Daniel Dao. All rights reserved.
//


import SpriteKit

class MenuScene: SKScene {
    
    var startGameButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        startGameButton = self.childNode(withName: "startGameButton") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            if self.nodes(at: location).first?.name == "startGameButton" {
                let trans = SKTransition.doorsOpenVertical(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: trans)
            }
        }
    }
}
