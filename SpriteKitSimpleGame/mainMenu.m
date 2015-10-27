//
//  mainMenu.m
//  SpriteKitSimpleGame
//
//  Created by Nur Farazi on 4/14/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "mainMenu.h"
#import "CharacterSelect.h"
#import "AppDelegate.h"

@interface mainMenu ()

@end

@implementation mainMenu{
    
    SKSpriteNode *_logo;
    SKSpriteNode *_underwaterPlayer;
    SKSpriteNode *_playbutton;
    SKSpriteNode *_highscorebutton;
    SKSpriteNode *_background;
    AppDelegate *appDelegate;
}



- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self Backgrounds];
        [self Logo];
        [self LogoScaleAnimation];
        //[self MenuPlayer];
        //[self animatePlayer];
        [self Buttons];
        [self bubbleParticle];
        [[GameCenterManager sharedManager] setDelegate:self];
    }
    return self;
}


-(void)Backgrounds{
    
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroud"];
    [_background setSize:self.size];
    [_background setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _background.name = @"background";
    [self addChild:_background];
}

-(void)Logo{
    
    _logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
    [_logo setSize:CGSizeMake(_logo.size.width, _logo.size.height)];
    [_logo setPosition:CGPointMake(self.size.width/2, self.size.height-_logo.size.height/2)];
    [self addChild:_logo];
}

-(void)MenuPlayer{
    
    _underwaterPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"frame1"];
    [_underwaterPlayer setSize:_underwaterPlayer.size];
    [_underwaterPlayer setPosition:CGPointMake(0, self.size.height/2)];
    [self addChild:_underwaterPlayer];
}

- (void)animatePlayer
{
    
    NSArray *animationFrames = @[
                                 [SKTexture textureWithImageNamed:@"frame1"],
                                 [SKTexture textureWithImageNamed:@"frame2"]
                                 ];
    [_underwaterPlayer runAction:[SKAction repeatActionForever:
                                  [SKAction animateWithTextures:animationFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:@"playerFish"];
}
-(void)LogoScaleAnimation {
    
    [_logo runAction:[SKAction repeatActionForever:
                      [SKAction sequence:@[
                                           [SKAction scaleTo:0.89f duration:0.3f],
                                           [SKAction scaleTo:0.8f duration:0.3f]
                                           ]]]
     ];
}

-(void)Buttons{
    
    _playbutton = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    _playbutton.name = @"playbutton";
    [_playbutton setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self addChild:_playbutton];
    [_playbutton setZPosition:5];
    
    
    
    _highscorebutton = [SKSpriteNode spriteNodeWithImageNamed:@"score"];
    _highscorebutton.name = @"GameCenter";
    [_highscorebutton setPosition:CGPointMake(self.size.width/2, _playbutton.position.y- _highscorebutton.size.height-20)];
    [self addChild:_highscorebutton];
    [_highscorebutton setZPosition:5];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"playbutton"]) {
        
        SKTransition *transition = [SKTransition fadeWithDuration:0.5f];
        CharacterSelect *game = [[CharacterSelect alloc] initWithSize:self.size];
        [self.scene.view presentScene:game transition:transition];
        
    }
    if ([node.name isEqualToString:@"GameCenter"]) {
        //Is game center available?
        BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
        
        if(isAvailable){
            
        
            NSLog(@"Presenting leaderboard...");
            
            UIViewController *vc = self.view.window.rootViewController;
            
            [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:vc];
            
        }else{
            
            //Showing an alert message that Game Center is unavailable
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Highscore" message: @"Game Center is currently unavailable. Make sure you are logged in." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
            
        }

        
        
    }
    
}
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController:gameCenterLoginController animated:YES completion:^{
        
        NSLog(@"Finished Presenting Authentication Controller");
        
    }];
}
-(void)bubbleParticle{
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"bubble" ofType:@"sks"];
    
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    
    burstNode.position = CGPointMake(self.size.width/2,0);

    
    [self addChild:burstNode];
}



@end
