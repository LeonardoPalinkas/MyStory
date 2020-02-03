//
//  Player.swift
//  MyStory
//
//  Created by leonardo palinkas on 28/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    var spriteComponent: SpriteComponent
    
    
    init(node: SKSpriteNode) {
        
        spriteComponent = SpriteComponent(node: node)
        
        super.init()

        addComponent(spriteComponent)
        spriteComponent.node.entity = self
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
