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
    var enemies = [GKEntity]()
    var pathLine: SKNode!

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
        createEnemies()
        
        pathLine = SKNode()
        addChild(pathLine)
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
            updatePathForEntities(enemies)
        }
    }
    
    func updatePathForEntities(entities: [GKEntity]) {
        for entity in entities {
            if let movementComponent = entity.componentForClass(MovementComponent) {
                movementComponent.sprite.removeAllActions()
                
                var path = movementComponent.pathToDestination()
                path.removeAtIndex(0)
                
                // update visual path
                updateVisualPath(path)
                
                movementComponent.followPath(path)
            }
        }
    }
    
    func updateVisualPath(path: [GKGridGraphNode]) {
        pathLine.removeAllChildren()
        
        var index = 0
        
        for node in path {
            let position = pointForCoordinate(node.gridPosition)
            
            if index + 1 < path.count {
                let nextPosition = pointForCoordinate(path[index + 1].gridPosition)
                let bezierPath = UIBezierPath()
                let startPoint = CGPointMake(position.x, position.y)
                let endPoint = CGPointMake(nextPosition.x, nextPosition.y)
                bezierPath.moveToPoint(startPoint)
                bezierPath.addLineToPoint(endPoint)
                
                let pattern: [CGFloat] = [CGFloat(boxSize / 10), CGFloat(boxSize / 10)]
                let dashed = CGPathCreateCopyByDashingPath(bezierPath.CGPath, nil, 0, pattern, 2)!
                
                let line = SKShapeNode(path: dashed)
                line.strokeColor = UIColor.blackColor()
                pathLine.addChild(line)
            }
            
            index += 1
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
    
    func createEnemies() {
        let enemy = GKEntity()
        let gridPosition = int2(0, Int32(height) / 2)
        let destination = int2(Int32(width) - 1, Int32(height) / 2)
        
        let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: boxSize * 0.6, height: boxSize * 0.6))
        sprite.position = pointForCoordinate(gridPosition)
        
        let movementComponent = MovementComponent(scene: self, sprite: sprite, coordinate: gridPosition, destination: destination)
        enemy.addComponent(movementComponent)
        
        enemies.append(enemy)
        
        var sequence = [SKAction]()
        
        for enemy in enemies {
            let action = SKAction.runBlock() { [unowned self] in
                let movementComponent = enemy.componentForClass(MovementComponent)!
                self.addChild(movementComponent.sprite)
                
                // update path
                self.updatePathForEntities([enemy])
                
                // temporary code to add movement
                let path = movementComponent.pathToDestination()
                movementComponent.followPath(path)
            }
            
            let delay = SKAction.waitForDuration(2)
            
            sequence += [action, delay]
        }
        
        runAction(SKAction.sequence(sequence))
    }
}
