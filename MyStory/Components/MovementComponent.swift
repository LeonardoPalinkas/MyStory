//
//  MovementComponent.swift
//  MyStory
//
//  Created by leonardo palinkas on 30/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import SpriteKit
import GameplayKit


class MovementComponent: GKComponent {

var spriteComponent: SpriteComponent!
var nodeBody: SKPhysicsBody!

    var moveRight: Bool = false
    var moveLeft: Bool = false
    
    private var force = 200.0
    private var maxVelocity: CGFloat = 200
    private var jumpVelocity: CGFloat = 500
    private var slowStopMultiplier: CGFloat = 3 // the higher the slower (0 <)
    
    func setUp(_ entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)! // pointer to the sprite component
        self.nodeBody = spriteComponent.node.physicsBody!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToTheLeft(_ move: Bool) {
        moveLeft = move
    }
    
    func moveToTheRight(_ move: Bool) {
        moveRight = move
    }
    
    func stop() {
        moveToTheLeft(false)
        moveToTheRight(false)
        nodeBody.velocity.dx /= slowStopMultiplier
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        _ = self.spriteComponent.node
     
            if -maxVelocity...maxVelocity ~= nodeBody.velocity.dx {
                if moveRight {
               nodeBody.applyForce(CGVector(dx: force * -1, dy: 0))
                }else if moveLeft {
                   nodeBody.applyForce(CGVector(dx: force, dy: 0))
                }
        }
    
    }
}
