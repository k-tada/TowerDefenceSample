//
//  GameScene.swift
//  TowerDefence
//
//  Created by 多田健太郎 on 2016/05/05.
//  Copyright (c) 2016年 多田健太郎. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var width: CGFloat!
    var height: CGFloat = 9
    var boxSize: CGFloat!
    var gridStart: CGPoint!
    var graph: GKGridGraph!

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
        createGrid()
        graph = GKGridGraph(fromGridStartingAt: int2(0,0), width: Int32(width), height: Int32(height), diagonalsAllowed: false)
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
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let coordinate = coordinateForPoint(location)
        createTowerAtCoordinate(coordinate)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func coordinateForPoint(point: CGPoint) -> int2 {
        return int2(Int32((point.x - gridStart.x) / boxSize), Int32((point.y - gridStart.y) / boxSize))
    }
    
    func createTowerAtCoordinate(coordinate: int2) {
        if let node = graph.nodeAtGridPosition(coordinate) {
            let tower = GKEntity()
            
            let towerSprite = SKSpriteNode(imageNamed: "turret")
            towerSprite.position = pointForCoordinate(coordinate)
            towerSprite.size = CGSize(width: boxSize * 0.9, height: boxSize * 0.9)
            
            // create and add visual component
            let visualComponent = VisualComponent(scene: self, sprite: towerSprite, coordinate: coordinate)
            tower.addComponent(visualComponent)
            
            addChild(towerSprite)
            
            graph.removeNodes([node])
            // update path
        }
    }
    
    func pointForCoordinate(coordinate: int2) -> CGPoint {
        return CGPointMake(CGFloat(coordinate.x) * boxSize + gridStart.x + boxSize / 2, CGFloat(coordinate.y) * boxSize + gridStart.y + boxSize / 2)
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
