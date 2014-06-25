//
//  GameScene.swift
//  2dTowerDefence
//
//  Created by Yuta Okazaki on 2014/06/21.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var attacker:SKSpriteNode!
    var enemyAttacker:SKSpriteNode!
    var ground:SKSpriteNode!
    var yourCastle:SKSpriteNode!
    var enemyCastle:SKSpriteNode!
    
    var enemyCastleHealth = 100.0
    var remainingEnemyCastleHealthLabel:SKLabelNode!
    var yourCastleHealth = 100.0
    var remainingYourCastleHealthLabel:SKLabelNode!
    
    var attackerCreateButton:SKSpriteNode!
    var levelUpButton:SKSpriteNode!
    var remainingMoney = 0.0
    var remainingMoneyLabel:SKLabelNode!
    var moneyUpRate = 12.0
    
    let yourAttackerCategory: UInt32 = 1 << 0
    let enemyAttackerCategory: UInt32 = 1 << 1
    let yourCastleCategory: UInt32 = 1 << 2
    let enemyCastleCategory: UInt32 = 1 << 3
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        
        attackerCreateButton = SKSpriteNode(imageNamed: "attackerCreateButton1")
        attackerCreateButton.position = CGPoint(x: 140, y: 550)
        levelUpButton = SKSpriteNode(imageNamed: "levelUpButton")
        levelUpButton.position = CGPoint(x: 140, y: 650)
        self.addChild(attackerCreateButton)
        self.addChild(levelUpButton)
        
        remainingMoneyLabel = SKLabelNode(text: String(remainingMoney))
        remainingMoneyLabel.position = CGPoint(x: 800, y: 650)
        remainingMoneyLabel.fontSize = 60.0
        self.addChild(remainingMoneyLabel)
        
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        ground = SKSpriteNode(imageNamed: "land")
        ground.setScale(3.2)
        ground.anchorPoint = CGPoint(x:0, y:0.45)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width * 2.0, self.frame.size.height / 2.0))
        ground.physicsBody.dynamic = false
        self.addChild(ground)
        
        yourCastle = SKSpriteNode(imageNamed: "youCastle")
        yourCastle.setScale(0.5)
        yourCastle.position = CGPointMake( self.frame.size.width * 0.1, self.frame.size.height * 0.35)
        yourCastle.physicsBody = SKPhysicsBody(rectangleOfSize: yourCastle.size)
        yourCastle.physicsBody.dynamic = false
        yourCastle.physicsBody.categoryBitMask = yourCastleCategory
        yourCastle.physicsBody.contactTestBitMask = enemyAttackerCategory
        self.addChild(yourCastle)
        remainingYourCastleHealthLabel = SKLabelNode(text: String(yourCastleHealth))
        remainingYourCastleHealthLabel.fontSize = 50.0
        yourCastle.addChild(remainingYourCastleHealthLabel)
     
        enemyCastle = SKSpriteNode(imageNamed: "enemyCastle")
        enemyCastle.setScale(0.5)
        enemyCastle.position = CGPointMake( self.frame.size.width * 0.9, self.frame.size.height * 0.35)
        enemyCastle.physicsBody = SKPhysicsBody(rectangleOfSize: enemyCastle.size)
        enemyCastle.physicsBody.dynamic = false
        enemyCastle.physicsBody.categoryBitMask = enemyCastleCategory
        enemyCastle.physicsBody.contactTestBitMask = yourAttackerCategory
        self.addChild(enemyCastle)
        
        remainingEnemyCastleHealthLabel = SKLabelNode(text: String(enemyCastleHealth))
        remainingEnemyCastleHealthLabel.fontSize = 50.0
        enemyCastle.addChild(remainingEnemyCastleHealthLabel)
        
        var enemy_attacker = Attacker(view: self, whichType: "enemy")
        setPhysicsCategory(enemy_attacker)
        self.addChild(enemy_attacker)
        var new_attacker = Attacker(view: self, whichType: "yours")
        setPhysicsCategory(new_attacker)
        self.addChild(new_attacker)
    }
    
    func setPhysicsCategory(attacker: SKSpriteNode) {
        if attacker.name == "yourAttacker" {
            attacker.physicsBody.categoryBitMask = yourAttackerCategory
            attacker.physicsBody.collisionBitMask = enemyCastleCategory | enemyAttackerCategory
            attacker.physicsBody.contactTestBitMask = enemyAttackerCategory
        } else if attacker.name == "enemyAttacker" {
            attacker.physicsBody.categoryBitMask = enemyAttackerCategory
            attacker.physicsBody.collisionBitMask = yourCastleCategory | yourAttackerCategory
        }
    }
   
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            //attacker.physicsBody.applyImpulse(CGVectorMake(10,6))
            
            if CGRectContainsPoint(attackerCreateButton.frame, touch.locationInNode(self)) {
                if remainingMoney > 40 {
                    var attacker = Attacker(view: self, whichType: "yours")
                    setPhysicsCategory(attacker)
                    self.addChild(attacker)
                    remainingMoney -= 40
                }
            }
            if CGRectContainsPoint(levelUpButton.frame, touch.locationInNode(self)) {
                if remainingMoney > 60 {
                    moneyUpRate *= 2
                    remainingMoney -= 60
                }
            }
        }
    }
   
    var moneyUpTimeCounter:CFTimeInterval = 0
    var enemyCreateTimeCounter:CFTimeInterval = 0
    var prevTime:CFTimeInterval = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        if prevTime == 0 { prevTime = currentTime }
        moneyUpTimeCounter += currentTime - prevTime
        if moneyUpTimeCounter > 0.5 {
            moneyUpTimeCounter = 0
            remainingMoney += moneyUpRate
            remainingMoneyLabel.text = String(remainingMoney)
        }
        enemyCreateTimeCounter += currentTime - prevTime
        if enemyCreateTimeCounter > 4 {
            enemyCreateTimeCounter = 0
            var enemy_attacker = Attacker(view: self, whichType: "enemy")
            setPhysicsCategory(enemy_attacker)
            self.addChild(enemy_attacker)
        }
        prevTime = currentTime
    }
    
    func didBeginContact(contact: SKPhysicsContact) {

        var bodyA_Mask = contact.bodyA.categoryBitMask
        var bodyB_Mask = contact.bodyB.categoryBitMask
        if ( bodyA_Mask == yourAttackerCategory && bodyB_Mask == enemyCastleCategory ) || ( bodyB_Mask == yourAttackerCategory && bodyA_Mask == enemyCastleCategory ) {
            enemyCastleHealth -= 10.0
            remainingEnemyCastleHealthLabel.text = String(enemyCastleHealth)
        }
        if ( bodyA_Mask == enemyAttackerCategory && bodyB_Mask == yourCastleCategory ) || ( bodyB_Mask == enemyAttackerCategory && bodyA_Mask == yourCastleCategory) {
            yourCastleHealth -= 10.0
            remainingYourCastleHealthLabel.text = String(yourCastleHealth)
        }
        if ( bodyA_Mask == yourAttackerCategory && bodyB_Mask == enemyAttackerCategory) {
            applyDamageTo(contact.bodyB.node)
            applyDamageTo(contact.bodyA.node)
            contact.bodyA.applyImpulse(CGVectorMake(-12, 8))
            let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType:"sks")
            let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath) as SKEmitterNode
            spark.position = contact.bodyB.node.position
            self.runAction(SKAction.sequence([
                SKAction.runBlock({self.addChild(spark)}),
                SKAction.waitForDuration(NSTimeInterval(0.1)),
                SKAction.runBlock({spark.removeFromParent()})
            ]))
        }
        if ( bodyB_Mask == yourAttackerCategory && bodyA_Mask == enemyAttackerCategory) {
            applyDamageTo(contact.bodyA.node)
            applyDamageTo(contact.bodyB.node)
            contact.bodyA.applyImpulse(CGVectorMake(12, 8))
            let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType:"sks")
            let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath) as SKEmitterNode
            spark.position = contact.bodyB.node.position
            self.runAction(SKAction.sequence([
                SKAction.runBlock({self.addChild(spark)}),
                SKAction.waitForDuration(NSTimeInterval(0.1)),
                SKAction.runBlock({spark.removeFromParent()})
            ]))
        }
    }
    
    func applyDamageTo(node: SKNode) {
        var life = node.userData["life"] as Int
        if life > 0 {
            node.userData["life"] = life - 1
        }
        if life <= 1 {
            node.removeFromParent()
        } else {
            var life_label = node.childNodeWithName("life_label") as SKLabelNode
            var life_result = node.userData["life"] as Int
            life_label.text = String(life_result)
        }
    }
}