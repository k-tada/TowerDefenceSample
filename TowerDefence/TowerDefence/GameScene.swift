//
//  GameScene.swift
//  TowerDefence
//
//  Created by 多田健太郎 on 2016/05/05.
//  Copyright (c) 2016年 多田健太郎. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var width: CGFloat!
    var height: CGFloat = 9
    var boxSize: CGFloat!
    var gridStart: CGPoint!

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
        createGrid()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createGrid(){
        let grid = SKNode()
        
        let usableWidth = size.width * 0.9
        let usableHeight = size.height * 0.8
        
        boxSize = usableHeight / height;
        
        width = CGFloat(Int(usableWidth / boxSize))
        
        let offsetX = (size.width - boxSize * width) / 2
        let offsetY = (size.height - boxSize * height) / 2
        
        for col in 0 ..< Int(width) {
            for row in 0 ..< Int(height) {
                let path = UIBezierPath(rect: CGRect(x: boxSize * CGFloat(col), y: boxSize * CGFloat(row), width: boxSize, height: boxSize))
                let box = SKShapeNode(path: path.CGPath)
                box.strokeColor = UIColor.grayColor()
                box.alpha = 0.3
                grid.addChild(box)
            }
        }
        
        gridStart = CGPointMake(offsetX, offsetY)
        grid.position = CGPointMake(offsetX, offsetY)
        addChild(grid)
    }
}
