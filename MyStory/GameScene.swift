//
//  GameScene.swift
//  MyStory
//
//  Created by leonardo palinkas on 23/01/20.
//  Copyright © 2020 leonardo palinkas. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    let tapRec = UITapGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    var player: PlayerEntity!
    
    private var enemies = [Enemy]()
    private var musicPlayer: AVAudioPlayer!
    
    let velocity = 600
    var moveLeft = false
    var moveRight = false
    
    struct PhysicsCategory {
        static let Player: UInt32 = 0
        static let Interacoes: UInt32 = 0b1
        static let Chao: UInt32 = 0b10
    }
   

    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
        
        setUpGestureRecognizers()
        
        player = PlayerEntity(node: self.childNode(withName: "player") as! SKSpriteNode)
        
        
        // Enemies
        enumerateChildNodes(withName: "enemy") { (node, stop) in
            let enemy = Enemy(node: node as! SKSpriteNode)
            self.enemies.append(enemy)
        }
        
        // Music
        playMusic()
        
        setUpContact()

        childNode(withName: "Contato")!.children.forEach({
            $0.physicsBody?.categoryBitMask = PhysicsCategory.Chao
        })
    }
    
    func setUpContact() {
        let body = player.spriteComponent.node.physicsBody!
        body.categoryBitMask = PhysicsCategory.Player
        body.contactTestBitMask = PhysicsCategory.Interacoes
        body.collisionBitMask = PhysicsCategory.Chao
        
        childNode(withName: "Z-6")!.children.forEach({
            let body = $0.physicsBody!
            body.categoryBitMask = PhysicsCategory.Interacoes
            body.contactTestBitMask = PhysicsCategory.Player
            body.collisionBitMask = 0
            body.fieldBitMask = PhysicsCategory.Player
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var other = contact.bodyA
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player {
            other = contact.bodyB
        }
        
        if other.categoryBitMask == PhysicsCategory.Interacoes {
            
            switch other.node?.name {
            case "Dino":
                let dinoText = childNode(withName: "dinoText")!
                dinoText.alpha = 1
            case "Desenho":
                let dinoText = childNode(withName: "desenhoText")!
                dinoText.alpha = 1
            default:
                break
            }
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var other = contact.bodyA
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player {
            other = contact.bodyB
        }
        
        if other.categoryBitMask == PhysicsCategory.Interacoes {
            
            switch other.node?.name {
            case "Dino":
                let dinoText = childNode(withName: "dinoText")!
                dinoText.alpha = 0
            case "Desenho":
                let dinoText = childNode(withName: "desenhoText")!
                dinoText.alpha = 0
            default:
                break
            }
            
        }
    }
    
    @objc func jump() {
        let nodeBody = player.spriteComponent.node.physicsBody!
        nodeBody.velocity.dy = 700
        run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
    }
    
    @objc func walk(sender: UILongPressGestureRecognizer) {
        
        let nodeBody = player.spriteComponent.node.physicsBody!

        let pos = sender.location(in: self.view!)

        if pos.x < self.view!.frame.width/2 {
            // left
            moveLeft = true
            moveRight = false

        } else {
            // right
            moveRight = true
            moveLeft = false

        }
        
        if sender.state == .ended {
            moveLeft = false
            moveRight = false
            // quanto maior, mais devagar
            nodeBody.velocity.dx /= 3
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer.location(in: self.view) == otherGestureRecognizer.location(in: self.view) {
                return false
            }
            if gestureRecognizer is UILongPressGestureRecognizer || otherGestureRecognizer is UILongPressGestureRecognizer {
                return true
            }
            return false
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

        let nodeBody = player.spriteComponent.node.physicsBody!
        
        if moveLeft {
            // left
            player.spriteComponent.node.xScale = abs(player.spriteComponent.node.xScale) * -1.0
            nodeBody.applyForce(CGVector(dx: velocity * -1, dy: 0))
//            run(SKAction.playSoundFileNamed("Steps.wav", waitForCompletion: true))

        } else if moveRight {
            // right
            player.spriteComponent.node.xScale = abs(player.spriteComponent.node.xScale) * 1.0
            nodeBody.applyForce(CGVector(dx: velocity, dy: 0))
//            run(SKAction.playSoundFileNamed("Steps.wav", waitForCompletion:true))
            

        }
    }
    
    func playMusic() {
           
           let url = Bundle.main.url(forResource: "musica", withExtension: "mp3")!
           
           do {
               musicPlayer =  try AVAudioPlayer(contentsOf: url)
           } catch {
               print("could not load sound file")
           }
           musicPlayer.numberOfLoops = 5
           musicPlayer.volume = 0
           musicPlayer.setVolume(0.2, fadeDuration: 2.0)
           musicPlayer.prepareToPlay()
           musicPlayer.play()
       }
    
    
}
