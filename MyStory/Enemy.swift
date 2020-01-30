//
//  Enemy.swift
//  MyStory
//
//  Created by leonardo palinkas on 30/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    
    var node: SKSpriteNode
    
    private var movementAnim: SKAction!
    private var direction: String!
    
    init(node: SKSpriteNode) {
        self.node = node
        setup()
    }
    
    private func setup() {
        
        let enemyName = node.userData!["name"] as! String
        let range = node.userData!["range"] as! Int
        let duration = node.userData!["duration"] as! Int
        direction = node.userData!["direction"] as? String
        
        var frames: [SKTexture] = []
        
        switch enemyName {
        case "Mr Allergies":
            for i in 1...2 {
                frames.append(SKTexture(imageNamed: "alergias\(i)"))
            }
        default :
            break
        }
        
        if direction == "nil" {
            return
        }
        
        let directionVector: CGVector
        if direction == "vertical" {
            directionVector = CGVector(dx: 0, dy: -range)
        } else {
            directionVector = CGVector(dx: range, dy: 0)
        }
        movementAnim = SKAction.move(by: directionVector, duration: TimeInterval(duration))
        
        movementAnim.timingMode = .easeInEaseOut
        go()
        
    }
    
    private func go() {
        if direction == "horizontal" {
            node.xScale = -1
        }
        node.run(movementAnim) {
            self.back()
        }
    }
    
    private func back() {
        node.xScale = 1
        node.run(movementAnim.reversed()) {
            self.go()
        }
    }
    
}
