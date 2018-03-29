import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenu(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .fill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

