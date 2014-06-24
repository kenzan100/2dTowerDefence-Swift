//
//  Attacker.swift
//  2dTowerDefence
//
//  Created by Yuta Okazaki on 2014/06/22.
//  Copyright (c) 2014年 Yuta Okazaki. All rights reserved.
//

import SpriteKit

class Attacker: SKSpriteNode {
    init (view: GameScene, whichType: String) {
        var imageStr:String
        var moveAttacker:SKAction!
        var attackerTexture:SKTexture!
        var walk:SKAction!
        
        switch whichType {
        case "yours":
            let rabbitTexture1 = SKTexture(imageNamed: "polar_rabbit")
            let rabbitTexture2 = SKTexture(imageNamed: "polar_rabbit-2")
            let anim = SKAction.animateWithTextures([rabbitTexture1, rabbitTexture2], timePerFrame: 0.2)
            walk = SKAction.repeatActionForever(anim)
            attackerTexture = rabbitTexture1
        case "enemy":
            let bearTexture1 = SKTexture(imageNamed: "polar_bear")
            let bearTexture2 = SKTexture(imageNamed: "polar_bear-2")
            let anim = SKAction.animateWithTextures([bearTexture1, bearTexture2], timePerFrame: 0.2)
            walk = SKAction.repeatActionForever(anim)
            attackerTexture = bearTexture1
        default:
            imageStr = ""
        }
        super.init(texture: attackerTexture)
        self.runAction(walk)
        
        if whichType == "yours" {
            self.setScale(0.21)
            self.position = CGPoint(x: view.frame.size.width * 0.15, y: view.frame.size.height * 0.3)
            moveAttacker = SKAction.moveByX(7.0, y:0.0, duration:NSTimeInterval(0.01 * 10.0))
            self.name = "yourAttacker"
        } else if whichType == "enemy" {
            self.setScale(0.25)
            self.position = CGPoint(x: view.frame.size.width * 0.75, y: view.frame.size.height * 0.3)
            moveAttacker = SKAction.moveByX(-7.0, y:0.0, duration:NSTimeInterval(0.01 * 10.0))
            self.name = "enemyAttacker"
        }
        
        self.runAction(SKAction.repeatActionForever(moveAttacker))
        self.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        self.physicsBody.dynamic = true
        self.physicsBody.allowsRotation = false
        self.userData = ["life": 10] as NSMutableDictionary
        var lifeAsInt = self.userData["life"] as Int
        var lifeLabel = SKLabelNode(text: String(lifeAsInt))
        self.addChild(lifeLabel)
        lifeLabel.name = "life_label"
    }
    
    init (texture: SKTexture?) {
        super.init(texture: texture)
    }
    
    init (texture: SKTexture?, color: SKColor?, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
}
