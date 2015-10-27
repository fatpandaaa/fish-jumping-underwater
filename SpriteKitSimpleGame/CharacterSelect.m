//
//  CharacterSelect.m
//  Shark prey
//
//  Created by Nur Farazi on 4/18/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CharacterSelect.h"

@interface CharacterSelect ()

@end

@implementation CharacterSelect

SKSpriteNode *_background;
SKSpriteNode *_box;
SKSpriteNode *_Nextbutton;
SKSpriteNode *_Backbutton;
SKSpriteNode *_LeftArrow;
SKSpriteNode *_RightArrow;
SKSpriteNode *_Restorebtn;
SKSpriteNode *_Character;
SKSpriteNode *_Lock;
bool character1UnLock;
bool character2UnLock;
bool character3UnLock;



int tempnumber;



- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        ProductFound = NO;
        
         [self InappPurchaseLoad];
        tempnumber = 1;
        character1UnLock=YES;
        character2UnLock=NO;
        
        [self LockIcon];
        
        [self Backgrounds];
        [self box];
        [self Buttons];
        [self createCharacterImage];
        [self bubbleParticle];
       
        
        
    }
    return self;
}

-(void)InappPurchaseLoad{
    
    _products2 = nil;

    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products2 = products ;
            ProductFound=YES;
        }
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
}

-(void)box  {
    
    _box = [SKSpriteNode spriteNodeWithImageNamed:@"chasel"];
    [_box setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _box.name = @"box";
    [self addChild:_box];
}
-(void)LockIcon{
    
    _Lock = [SKSpriteNode spriteNodeWithImageNamed:@"lock"];
    [_Lock setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _Lock.name = @"Lock";
    [self addChild:_Lock];
    _Lock.zPosition=200;
}

-(void)Backgrounds{
    
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroud"];
    [_background setSize:self.size];
    [_background setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    _background.name = @"background";
    [self addChild:_background];
    
}
-(void)Buttons{
    
    _Nextbutton = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    _Nextbutton.name = @"Backbtn";
    [_Nextbutton setPosition:CGPointMake(self.size.width * 0.2 , self.size.height * 0.1)];
    [self addChild:_Nextbutton];
    [_Nextbutton setZPosition:5];
    
    
    _Backbutton = [SKSpriteNode spriteNodeWithImageNamed:@"next"];
    _Backbutton.name = @"Nextbtn";
    [_Backbutton setPosition:CGPointMake(self.size.width * 0.8, self.size.height *0.1)];
    [self addChild:_Backbutton];
    [_Backbutton setZPosition:5];
    
    
    _LeftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftA"];
    _LeftArrow.name = @"leftA";
    [_LeftArrow setPosition:CGPointMake(self.size.width * 0.1, self.size.height/2)];
    [self addChild:_LeftArrow];
    [_LeftArrow setZPosition:5];
    
    
    _RightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow"];
    _RightArrow.name = @"rightA";
    [_RightArrow setPosition:CGPointMake(self.size.width * 0.9, self.size.height/2)];
    [self addChild:_RightArrow];
    [_RightArrow setZPosition:5];
    
    _Restorebtn = [SKSpriteNode spriteNodeWithImageNamed:@"restore"];
    _Restorebtn.name = @"Restore";
    [_Restorebtn setPosition:CGPointMake(self.size.width /2, self.size.height *0.1)];
    [self addChild:_Restorebtn];
    [_Restorebtn setZPosition:5];
    
    
}
-(void)createCharacterImage
{
    _Character = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"c%d",tempnumber]];
    _Character.position = CGPointMake(self.frame.size.width/2, (self.frame.size.height /2));
    _Character.name=@"character";
    [_Character setScale:0.8];
    [self addChild:_Character];
}
-(void)update:(NSTimeInterval)currentTime{
    
    character2UnLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"character2unlock"];
    character3UnLock = [[NSUserDefaults standardUserDefaults] boolForKey:@"character3unlock"];

    
    if (tempnumber==1) {
        _LeftArrow.alpha=0.0;
        _RightArrow.alpha=255.0;
        _Lock.alpha=0.0;
    }
    if (tempnumber==2) {
         _LeftArrow.alpha=255.0;
        _RightArrow.alpha=255.0;
        if (character2UnLock==YES) {
            _Lock.alpha=0.0;
        }else{
            _Lock.alpha=255.0;
        }
    }
    if (tempnumber==3) {
        _LeftArrow.alpha=255.0;
        _RightArrow.alpha=0.0;
        if (character3UnLock==YES) {
            _Lock.alpha=0.0;
        }else{
            _Lock.alpha=255.0;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"leftA"]) {
        
        if (tempnumber==1) {
            
            return;
        } else {
            [_Character removeFromParent];
            
            tempnumber--;
            
            if (tempnumber==0){
                tempnumber=4;
            }
            
            [self createCharacterImage];
        }
    
    }
    if ([node.name isEqualToString:@"rightA"]) {
        
        if (tempnumber==3) {
            
            return;
        } else {
            
            [_Character removeFromParent];
            
            tempnumber++;
            
            if (tempnumber==4) {
                tempnumber=1;
            }
            
            [self createCharacterImage];
        }
    
    }
    
    if ([node.name isEqualToString:@"Nextbtn"]) {
        if (tempnumber==1) {
            
            
            SKTransition *transition = [SKTransition fadeWithDuration:0.2f];
            GamePlay *game = [[GamePlay alloc] initWithSize:self.size :tempnumber];
            [self.scene.view presentScene:game transition:transition];

            
        }

        if (tempnumber==2) {
            if (character2UnLock==YES) {
                SKTransition *transition = [SKTransition fadeWithDuration:0.2f];
                GamePlay *game = [[GamePlay alloc] initWithSize:self.size :tempnumber];
                [self.scene.view presentScene:game transition:transition];
                
            }else{
                if (ProductFound==TRUE) {
                    SKProduct *product = _products2[0];
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                } else {
                    [self productNotFound];
                }
               
                
            }

        }
        if (tempnumber==3) {
            if (character3UnLock==YES) {
                SKTransition *transition = [SKTransition fadeWithDuration:0.2f];
                GamePlay *game = [[GamePlay alloc] initWithSize:self.size :tempnumber];
                [self.scene.view presentScene:game transition:transition];
                
            }else{
                
                if (ProductFound) {
                    SKProduct *product = _products2[1];
                    [[RageIAPHelper sharedInstance] buyProduct:product];

                } else{
                    [self productNotFound];
                    
                }
                
            }
            
        }

    }
    if ([node.name isEqualToString:@"Backbtn"]) {
        
        SKTransition *transition = [SKTransition fadeWithDuration:0.2f];
        mainMenu *game = [[mainMenu alloc] initWithSize:self.size];
        [self.scene.view presentScene:game transition:transition];
        
        
    }
    
    if ([node.name isEqualToString:@"Restore"]) {
        
        [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
        
        
    }

    
}

- (void)productNotFound {
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"Network Problem , In App Purchase Not Found"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert2 show];
    
}
- (void)productPurchased:(NSNotification *)notification {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful"
                                                    message:@"Product Purchased succesfully"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)bubbleParticle{
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"bubble" ofType:@"sks"];
    
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    
    burstNode.position = CGPointMake(self.size.width/2,0);
    
    
    [self addChild:burstNode];
    burstNode.zPosition = 1;
}



@end
