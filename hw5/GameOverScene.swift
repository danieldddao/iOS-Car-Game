//
//  GameOverScene.swift
//  hw5
//
//  Created by Daniel Dao on 10/6/17.
//  Copyright © 2017 Daniel Dao. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let defaults = UserDefaults.standard

    var restartButton: SKSpriteNode!
    var yourScoreLabel: SKLabelNode!
    var top5ScoresLabel: SKLabelNode!
    
    var yourScore:Int = 0
    var top5ScoresArray: [Int] = [0, 0, 0, 0, 0]
    
    override func didMove(to view: SKView) {
        restartButton = self.childNode(withName: "restartButton") as! SKSpriteNode
        yourScoreLabel = self.childNode(withName: "yourScoreLabel") as! SKLabelNode
        
        let top1ScoreLB = self.childNode(withName: "top1ScoreLabel") as! SKLabelNode
        let top2ScoreLB = self.childNode(withName: "top2ScoreLabel") as! SKLabelNode
        let top3ScoreLB = self.childNode(withName: "top3ScoreLabel") as! SKLabelNode
        let top4ScoreLB = self.childNode(withName: "top4ScoreLabel") as! SKLabelNode
        let top5ScoreLB = self.childNode(withName: "top5ScoreLabel") as! SKLabelNode

        yourScoreLabel.text = "Your Score: \(yourScore)"
//        yourScoreLabel.fontName = "Chalkduster"
        
//        resetTop5Scores()
        loadTop5Scores()
        top5ScoresArray = top5ScoresArray.sorted { $0 > $1 }

        if yourScore > top5ScoresArray[4] && !top5ScoresArray.contains(yourScore) {
            top5ScoresArray[4] = yourScore
            top5ScoresArray = top5ScoresArray.sorted { $0 > $1 }
        }
        saveTop5Scores()
        print("your score: \(yourScore)")
        print("top5Scores: \(top5ScoresArray)")
        top1ScoreLB.text = "\(1). \(top5ScoresArray[0])"
        top2ScoreLB.text = "\(2). \(top5ScoresArray[1])"
        top3ScoreLB.text = "\(3). \(top5ScoresArray[2])"
        top4ScoreLB.text = "\(4). \(top5ScoresArray[3])"
        top5ScoreLB.text = "\(5). \(top5ScoresArray[4])"
    }
    
    func loadTop5Scores() {
        if let top5ScoresFromUD = defaults.array(forKey: "top5Scores") {
            top5ScoresArray = top5ScoresFromUD as! [Int]
        }
    }
    
    func saveTop5Scores() {
        defaults.set(top5ScoresArray, forKey: "top5Scores")
    }
    
    func resetTop5Scores() {
        defaults.removeObject(forKey: "top5Scores")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            if self.nodes(at: location).first?.name == "restartButton" {
                let trans = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: trans)
            }
        }
    }
}


