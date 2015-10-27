//
//  GamePlay.h
//  Shark prey
//
//  Created by Nur Farazi on 4/14/14.
//  Copyright (c) 2014 nur farazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Obtacle.h"
#import "GameOverScene.h"

@interface GamePlay : SKScene <SKPhysicsContactDelegate>


- (id)initWithSize:(CGSize)size :(int)Character;
@end
