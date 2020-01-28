//
//  SpriteComponent.swift
//  MyStory
//
//  Created by leonardo palinkas on 28/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    var node: SKSpriteNode

    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
