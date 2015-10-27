//
//  GameOverScene.h
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GamePlay.h"
#import "mainMenu.h"
#import "Social/Social.h"

@interface GameOverScene : SKScene 
{
    SKAction *fbmove;
    SKAction *twittermove;
    SLComposeViewController *myslcomposeviewcontroler;
}
-(id)initWithSize:(CGSize)size gameScore:(NSInteger)Score Character:(int)Number;
 
@end
