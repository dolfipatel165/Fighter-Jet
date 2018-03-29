import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool, score:Int) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.black
        
        // 2
        let message = won ? "You Won!" : "You Lose!"

        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        
        let label2 = SKLabelNode(fontNamed: "Marker Felt")
        label2.text = "\nPlayer 1 Score: \( PhysicsCategory.finalScore)"
        label2.fontSize = 30
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: "Marker Felt")
        label3.text = "\nPlayer 2 Score: \( PhysicsCategory.finalScore2)"
        label3.fontSize = 30
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: size.width/2, y: size.height/6)
        addChild(label3)

        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipVertical(withDuration: 0.5)
                let scene = MainMenu(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
