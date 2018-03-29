import SpriteKit

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif


class GameScene2: SKScene, SKPhysicsContactDelegate {
    let collision = SKSpriteNode(imageNamed: "1.png")    // 1
    let player = SKSpriteNode(imageNamed: "player")
    var monstersDestroyed = 0
    var scoreCounter : Int = 0
    let button = SKSpriteNode(imageNamed: "375")
    let scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
    
    
    override func didMove(to view: SKView) {
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.05)
        //scoreLabel.name = "0"
        scoreLabel.fontColor = UIColor.white
        self.addChild(scoreLabel)
        scoreLabel.text = "Score: 0"
        
        
        // 2
        
        backgroundColor = SKColor.black
        // 3
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        
        // 4
        addChild(player)
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        let backgroundMusic = SKAudioNode(fileNamed: "John_Wesley_Coleman_-_07_-_Tequila_10_Seconds.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(6.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        //monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false ,score: self.monstersDestroyed)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var nodeTouched=SKNode()
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            nodeTouched = self.atPoint(location)
            if(nodeTouched == self.player)
            {
                self.player.position.x = location.x
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        run(SKAction.playSoundFileNamed("pew-pew-lei.mp3", waitForCompletion: false))
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //  if button.contains(touchLocation)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "arrow")
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.y < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        scoreCounter = scoreCounter + 1
        PhysicsCategory.finalScore2 = scoreCounter
        scoreLabel.text = "Score:" + String(scoreCounter)
        print(scoreCounter)
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.05), SKAction.run({
            self.collision.position = projectile.position
            self.collision.removeFromParent()
            
            self.addChild(self.collision)
            
            }
            )]))
        // collision.removeFromParent()
        
        
        
        projectile.removeFromParent()
        monster.removeFromParent()
        run(SKAction.playSoundFileNamed("Gun+357+Magnum.mp3", waitForCompletion: false))
        
        monstersDestroyed += 1
        UserDefaults.standard.set(monstersDestroyed, forKey: "playerScore2")

        if (monstersDestroyed > 30) {
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true, score: self.monstersDestroyed)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                
                
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
                
            }
        }
        
    }
}

