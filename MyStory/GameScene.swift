//
//  GameScene.swift
//  MyStory
//
//  Created by leonardo palinkas on 23/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    let tapRec = UITapGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    var player: PlayerEntity!
    
    override func didMove(to view: SKView) {
        
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
        
        setUpGestureRecognizers()
        
        player = PlayerEntity(node: self.childNode(withName: "player") as! SKSpriteNode)

    }
    
    @objc func jump() {
        let nodeBody = player.spriteComponent.node.physicsBody!
        nodeBody.velocity.dy = CGFloat(700)
        
//        if player.spriteComponent.node.physicsBody?.allContactedBodies().count != 0 {
//            player.movementComponent?.jump()
//            player.movementComponent.ground = false
//        }
    }
    
    @objc func walk(sender: UILongPressGestureRecognizer) {
        
        let nodeBody = player.spriteComponent.node.physicsBody!

        let pos = sender.location(in: self.view!)
        let velocity = 300

        if pos.x < self.view!.frame.width/2 {
            // left
            player.spriteComponent.node.xScale = abs(player.spriteComponent.node.xScale) * -1.0
            nodeBody.applyForce(CGVector(dx: velocity * -1, dy: 0))

        } else {
            // right
            player.spriteComponent.node.xScale = abs(player.spriteComponent.node.xScale) * 1.0
            nodeBody.applyForce(CGVector(dx: velocity, dy: 0))

        }
        
        if sender.state == .ended {
            // quanto maior, mais devagar
            nodeBody.velocity.dx /= 3
            
        }
    }
    
    func setUpGestureRecognizers() {
        tapRec.addTarget(self, action: #selector(jump))
        tapRec.delegate = self
        self.view!.addGestureRecognizer(tapRec)

        longPressRec.addTarget(self, action: #selector(walk))
        longPressRec.delegate = self
        longPressRec.minimumPressDuration = 0.1

        self.view!.addGestureRecognizer(longPressRec)

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.camera?.position = player.spriteComponent.node.position + CGPoint(x: 0, y: frame.size.height/6)
    }
}
