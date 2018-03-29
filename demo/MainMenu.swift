
import SpriteKit

class MainMenu: SKScene {
    
    var player1 = SKSpriteNode()
    let player1Img = SKTexture(imageNamed: "14")
    
    var player2 = SKSpriteNode()
    let player2Img = SKTexture(imageNamed: "15")

    override func didMove(to view: SKView) {

        let player1 = SKLabelNode(fontNamed: "Marker Felt")
        player1.text = "Player 1"
        player1.name = "Player 1"
        player1.fontSize = 40
        player1.fontColor = SKColor.white
        player1.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(player1)
        
        let player2 = SKLabelNode(fontNamed: "Marker Felt")
        player2.text = "Player 2"
        player2.name = "Player 2"
        player2.fontSize = 40
        player2.fontColor = SKColor.white
        player2.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if(node.name == "Player 1") {
                if view != nil {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                }
            }
            
            if(node.name == "Player 2"){
                if view != nil {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene2(size: self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                    }
            }
            
            
    }
}
}

