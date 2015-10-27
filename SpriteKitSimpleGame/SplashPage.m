//
//  SplashPage.m
//  Shark prey
//
//  Created by Nur Farazi on 4/23/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "SplashPage.h"

@interface SplashPage ()

@end


@implementation SplashPage{
    
    SKSpriteNode *_background;
    
    
}



- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        
        [self Backgrounds];
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:1.0],
                              [SKAction runBlock:^{
             
             SKTransition *reveal = [SKTransition fadeWithDuration:0.3];
             SKScene * myScene = [[mainMenu alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: reveal];
         }]
                              ]]
         ];
        
        
    }
    return self;
}

-(void)Backgrounds{
    
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"splash"];
    [_background setSize:self.size];
    [_background setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _background.name = @"background";
    [self addChild:_background];
}


@end


