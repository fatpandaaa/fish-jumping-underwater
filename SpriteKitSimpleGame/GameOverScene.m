//
//  GameOverScene.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) nur farazi. All rights reserved.
//

#import "GameOverScene.h"



@implementation GameOverScene
static NSString *kLeaderBoardName = @"SharkPreyLeader";

//The game over logo
SKSpriteNode *_logo;
SKSpriteNode *_GameBox;
SKSpriteNode *_background;


//The retry button
SKSpriteNode *_retrybutton;

//Label showing the message - in this case the score
SKLabelNode *_messageLabel;

//Menu button
SKSpriteNode *_menubutton;

//The local high score
SKLabelNode *_highscoreLabel;
SKSpriteNode *_ShareBtn;
SKSpriteNode *_Facebookbtn;
SKSpriteNode *_twitterbtn;


int chaNumber;

-(id)initWithSize:(CGSize)size gameScore:(NSInteger)Score Character:(int)Number{
    if (self = [super initWithSize:size]) {
 
        chaNumber = Number;
        
        [self Backgrounds];
        [self Logo];
        [self LogoScaleAnimation];
        [self Buttons];
        [self GameBox];
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
    
    _logo = [SKSpriteNode spriteNodeWithImageNamed:@"gameOver"];
    [_logo setSize:CGSizeMake(_logo.size.width, _logo.size.height)];
    [_logo setPosition:CGPointMake(self.size.width/2, self.size.height/2 + 80)];
    [self addChild:_logo];
    _logo.zPosition = 6;
    }

-(void)GameBox{
    
    _GameBox = [SKSpriteNode spriteNodeWithImageNamed:@"Gbox"];
    [_GameBox setSize:CGSizeMake(_GameBox.size.width, _GameBox.size.height)];
    [_GameBox setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [_GameBox setScale:1.2f];
    [self addChild:_GameBox];
    
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
    
    _retrybutton = [SKSpriteNode spriteNodeWithImageNamed:@"retry"];
    _retrybutton.name = @"Retry";
    [_retrybutton setPosition:CGPointMake(self.size.width* 0.33, self.size.height * 0.25)];
    [self addChild:_retrybutton];
    [_retrybutton setZPosition:5];
    
    
    
    _menubutton = [SKSpriteNode spriteNodeWithImageNamed:@"menubtn"];
    _menubutton.name = @"Menu";
    [_menubutton setPosition:CGPointMake(self.size.width*0.67, self.size.height *0.25)];
    [self addChild:_menubutton];
    [_menubutton setZPosition:5];
    
    
}
- (void)didMoveToView:(SKView *)view {
    
    NSInteger score = [[self.userData objectForKey:@"score"] integerValue];
    NSInteger highscore = [[NSUserDefaults standardUserDefaults] integerForKey: @"highScore"];

    _messageLabel = [self makeDropShadowString:[NSString stringWithFormat:@"%ld", (long)score] fontSize:70 shadowOffset:1];
    
    [_messageLabel setPosition:CGPointMake(self.size.width/2 , self.size.height * 0.4)];
    [_messageLabel setFontColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]];
    [_messageLabel setZPosition:100];
    
    [self addChild:_messageLabel];
    
    NSInteger displayscore = highscore;
    
    [self submitToLeaderboard:score];
    
    if(score > highscore){
        
        [self saveScore:score];
        
        displayscore = score;
        
        SKLabelNode *_newLabel = [self makeDropShadowString:@"NEW HighScore!!!!" fontSize:25 shadowOffset:1];
        [_newLabel setPosition:CGPointMake(self.size.width/2 , self.size.height - 50)];
        [_newLabel setFontColor:[UIColor colorWithRed:200/255.0f green:188/255.0f blue:200/255.0f alpha:1.0f]];
        [_newLabel setZPosition:100];
        
        [self addChild:_newLabel];
        
    }

}
-(void)submitToLeaderboard: (NSInteger)score{
    
    
    //Is Game Center available?
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        
    [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:kLeaderBoardName  sortOrder:GameCenterSortOrderHighToLow];
        
    }

}

//Save the local score
-(void)saveScore: (NSInteger)score {
    
    //We use NSUserDefaults for this
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:score forKey:@"highScore"];
    
    //Synchronize score
    [defaults synchronize];
    
}
//Creates a simple drop shadow
- (SKLabelNode *) makeDropShadowString:(NSString *) myString fontSize:(NSInteger) fontSize shadowOffset:(NSInteger) shadowOffset
{
    NSInteger offSetX = shadowOffset;
    NSInteger offSetY = shadowOffset;
    
    SKLabelNode *completedString = [SKLabelNode labelNodeWithFontNamed:@"04b 30"];
    completedString.fontSize = fontSize;
    completedString.fontColor = [SKColor redColor];
    completedString.text = myString;
    
    
    SKLabelNode *dropShadow = [SKLabelNode labelNodeWithFontNamed:@"04b 30"];
    dropShadow.fontSize = fontSize;
    dropShadow.fontColor = [SKColor blackColor];
    dropShadow.text = myString;
    dropShadow.zPosition = completedString.zPosition - 1;
    dropShadow.position = CGPointMake(dropShadow.position.x - offSetX, dropShadow.position.y - offSetY);
    
    [completedString addChild:dropShadow];
    
    return completedString;
}

//Screen is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"Retry"]) {
        
        SKTransition *transition = [SKTransition fadeWithDuration:.5];
        GamePlay *game = [[GamePlay alloc] initWithSize:self.size :chaNumber];
        [self.scene.view presentScene:game transition:transition];
        
    }
    if([node.name isEqualToString:@"Menu"]){
        
        SKTransition *transition = [SKTransition fadeWithDuration:.4];
        mainMenu *menu = [[mainMenu alloc] initWithSize:self.size];
        [self.scene.view presentScene:menu transition:transition];
        
    }
    
    if([node.name isEqualToString:@"Sharebutton"]){
        
        [_Facebookbtn runAction:fbmove];
        [_twitterbtn runAction:twittermove];
        
    }
}

@end
