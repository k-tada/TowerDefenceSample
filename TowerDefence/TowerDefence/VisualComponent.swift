//
//  VisualComponent.swift
//  TowerDefence
//
//  Created by 多田健太郎 on 2016/05/05.
//  Copyright © 2016年 多田健太郎. All rights reserved.
//

import SpriteKit
import GameplayKit

class VisualComponent: GKComponent {
    var scene: GameScene!
    var sprite: SKSpriteNode!
    var coordinate: int2!
    
    init(scene: GameScene, sprite: SKSpriteNode, coordinate: int2) {
        self.scene = scene
        self.sprite = sprite
        self.coordinate = coordinate
    }
}
