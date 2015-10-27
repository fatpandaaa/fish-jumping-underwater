//
//  GamePlay.m
//  Shark prey
//
//  Created by Nur Farazi on 4/14/14.
//  Copyright (c) 2014 nur farazi LLC. All rights reserved.
//

#import "GamePlay.h"
#import "AppDelegate.h"
@interface GamePlay ()

@end

static const float BG1_VELOCITY = 20.0;
static const float BG2_VELOCITY = 55.0;

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPCoinCategory = 0x1 << 1;
static const uint32_t kPboostCategory = 0x1 << 4;
static const uint32_t kPipeCategory = 0x1 << 2;
static const uint32_t kGroundCategory = 0x1 << 3;


static CGFloat kGravity = -10;

static const CGFloat kDensity = 1.15;

static CGFloat kMaxVelocity = 400;

static const CGFloat kPipeFrequency = 1;

static bool allowTap = true;


@implementation GamePlay{
    
    Player *_player;
    
    SKLabelNode *_scoreLabel;
    SKLabelNode *_coinLabel;
    
    NSInteger _score;
    NSInteger _Coin;
    
    SKSpriteNode *_ground;
    
    SKSpriteNode *lifeimage1;
    SKSpriteNode *lifeimage2;
    SKSpriteNode *coin;
    
    SKSpriteNode *lifeimage3;
    
    SKEmitterNode *_bubbleEmitter;
    
    NSTimer *_pipeTimer;
    NSTimer *_CoinTimer;
    NSTimer *_CoinUpdateTimer;
    
    NSTimer *_scoreTimer;
    NSTimer *_SherkSpeed;
    NSTimer *_collitoin;
    
    SKAction *_pipeSound;
    
    SKAction *_animateExplosion;
    SKAction *_dieSound;
    SKAction *_swimSound;
    SKAction *_gameOversound;
    SKAction *_coinsound;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lastMissileAdded;
    
    int characterNumber;
    int life;
    NSString *firstFrame;
    NSString *secondFrame;
    float rotate;
    BOOL TopTouched;
    bool collitionActive;
    int minimumSpeed;
    int actualYForCoin;
    AppDelegate * appdelegate;
    int adddisplaycounter;
    
}
static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

- (id)initWithSize:(CGSize)size :(int)Character
{
    if (self = [super initWithSize:size]) {
        
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        actualYForCoin = 100;
        //adddisplaycounter = 0;
        adddisplaycounter = [[NSUserDefaults standardUserDefaults]integerForKey:@"adddisplaycounter"];
        minimumSpeed = 2;
        collitionActive = YES;
        
        characterNumber=Character;
        life = 2;
        _score = 0;
        rotate= 0.1;
        [self BubbleHero];
        [self CharacterLoadOnSelection:Character];
        [self physicsLoad];
        [self ScoreShow];
        [self initalizingScrollingBackground];
        [self setupPlayer];
        [self GroundLoad];
        [self LifeShow];
        [self SpeedParticle];
        [self CoinNumberShow];
        
        [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(startScoreTimer) userInfo:nil repeats:NO];
        
        _SherkSpeed = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(IncreaSherkSpeed) userInfo:nil repeats:YES];
        
        _pipeTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(AddSherk) userInfo:nil repeats:YES];
        
        _CoinTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(AddCoin) userInfo:nil repeats:YES];
        
        _CoinUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(CoinPositionUpdate) userInfo:nil repeats:YES];
        
        
       
        
        
        _swimSound = [SKAction playSoundFileNamed:@"swim.mp3" waitForCompletion:YES];
        _dieSound = [SKAction playSoundFileNamed:@"punch.wav" waitForCompletion:YES];
        _gameOversound = [SKAction playSoundFileNamed:@"gameover.mp3" waitForCompletion:YES];
        _coinsound = [SKAction playSoundFileNamed:@"coin2.wav" waitForCompletion:NO];
        
        
        
        
        
    }
    return self;
}

-(void)colideAction{
    collitionActive = YES;
    _player.alpha = 1.0;
}
-(void)IncreaSherkSpeed{
    
    minimumSpeed--;
    if (minimumSpeed==0) {
        minimumSpeed=1;
    }
    
    
}
-(void)LifeShow{
    
    lifeimage1 = [[SKSpriteNode alloc] initWithImageNamed:firstFrame];
    lifeimage1.position = CGPointMake((lifeimage1.size.width/2)*.5,self.size.height-(lifeimage1.size.height/2)*.5);
    [self addChild:lifeimage1];
    [lifeimage1 setScale:0.5];
    lifeimage1.zPosition=5;
    
    
    lifeimage2 = [[SKSpriteNode alloc] initWithImageNamed:firstFrame];
    lifeimage2.position = CGPointMake((lifeimage1.size.width)*1.5 , self.size.height-lifeimage1.size.height/2);
    [self addChild:lifeimage2];
    [lifeimage2 setScale:0.5];
    lifeimage2.zPosition=5;
    
    
    
    
}
-(void)CharacterLoadOnSelection :(int)Charac{
    
    switch (Charac) {
        case 1:
            firstFrame =@"jelly1";
            secondFrame=@"jelly2";
            break;
        case 2:
            firstFrame =@"seahorse1";
            secondFrame=@"seahorse2";
            break;
        case 3:
            firstFrame =@"turtle1";
            secondFrame=@"turtle2";
        default:
            break;
    }
}

- (void)setupPlayer
{
    _player = [Player spriteNodeWithImageNamed:firstFrame];
    [_player setPosition:CGPointMake(self.size.width * 0.3, self.size.height/2)];
    [self addChild:_player];
    [self animatePlayer];
    
}

-(void)applyPhysicsToPlayer {
    
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    [_player.physicsBody setDensity:kDensity];
    [_player.physicsBody setAllowsRotation:NO];
    
    [_player.physicsBody setCategoryBitMask:kPlayerCategory];
    [_player.physicsBody setContactTestBitMask:kPipeCategory | kGroundCategory];
    [_player.physicsBody setCollisionBitMask:kGroundCategory];
    
}

-(void)BubbleHero{
    
    NSString *sherkBubble = [[NSBundle mainBundle] pathForResource:@"heroBubble" ofType:@"sks"];
    _bubbleEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:sherkBubble];
    _bubbleEmitter.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:_bubbleEmitter];
    _bubbleEmitter.zPosition=0;
    
}
- (void)AddSherk {
    
    SKSpriteNode *collider = [SKSpriteNode spriteNodeWithImageNamed:@"shakerCollider"];
    
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithImageNamed:@"Sherk"];
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:collider.size]; // 1
    monster.physicsBody.dynamic = NO; // 2
    monster.physicsBody.categoryBitMask = kPipeCategory; // 3
    monster.physicsBody.contactTestBitMask = kPlayerCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5z
    
    
    
    int minY = monster.size.height / 2;
    int maxY = self.frame.size.height - monster.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    monster.position = CGPointMake(self.frame.size.width + monster.size.width/2, actualY);
    [self addChild:monster];
    
    int minDuration = minimumSpeed;
    int maxDuration = minimumSpeed+2;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        
        [monster removeFromParent];
    }];
    [monster runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    
}

-(void)DiePlayerparticle
{
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"die" ofType:@"sks"];
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstNode.position = _player.position;
    burstNode.zPosition=10;
    [self addChild:burstNode];
    
}


- (void)startScoreTimer
{
    [self applyPhysicsToPlayer];
    _scoreTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}

-(void)rotatePlayer {
    
    [_player runAction:[SKAction rotateByAngle:-0.5f duration:.5f]];
    [_player runAction:[SKAction rotateByAngle:0.5f duration:.2f]];
    
}
- (void)animatePlayer
{
    NSArray *animationFrames = @[
                                 [SKTexture textureWithImageNamed:firstFrame],
                                 [SKTexture textureWithImageNamed:secondFrame]
                                 ];
    
    [_player runAction:[SKAction repeatActionForever:
                        [SKAction animateWithTextures:animationFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:@"playerFish"];
    
}
-(void)AddCoin{
    
    coin = [SKSpriteNode spriteNodeWithImageNamed:@"coin"];
    [coin setScale:1.2];
    coin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:coin.size];
    coin.physicsBody.dynamic = NO;
    coin.physicsBody.categoryBitMask = kPCoinCategory;
    coin.physicsBody.contactTestBitMask = kPlayerCategory;
    coin.physicsBody.collisionBitMask = 0;
    
    
    coin.position = CGPointMake(self.frame.size.width + coin.size.width/2, actualYForCoin);
    [self addChild:coin];
    
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-coin.size.width/2, actualYForCoin) duration:5];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        
        [coin removeFromParent];
    }];
    [coin runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    
    
}
-(void)CoinPositionUpdate
{
    int minY = coin.size.height;
    int maxY = self.size.height - coin.size.height;
    int rangeY = maxY - minY;
    actualYForCoin= (arc4random() % rangeY) + minY;
}


-(void)physicsLoad{
    
    [self.physicsWorld setGravity:CGVectorMake(0, kGravity)];
    [self.physicsWorld setContactDelegate:self];
}

-(void)GroundLoad{
    _ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    [_ground setSize:CGSizeMake(self.size.width, 2)];
    [_ground setPosition:CGPointMake(0, 0)];
    
    _ground.zPosition = 100;
    
    _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
    [_ground.physicsBody setCategoryBitMask:kGroundCategory];
    [_ground.physicsBody setContactTestBitMask:kPlayerCategory];
    [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
    [_ground.physicsBody setAffectedByGravity:NO];
    [_ground.physicsBody setDynamic:NO];
    
    [self addChild:_ground];
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if( currentTime - _lastMissileAdded > 1)
    {
        _lastMissileAdded = currentTime + 1;
        
    }
    
    
    [self moveBg];
    
    //-------------------
    if (_player.physicsBody.velocity.dy > kMaxVelocity) {
        
        [_player.physicsBody setVelocity:CGVectorMake(_player.physicsBody.velocity.dx, kMaxVelocity)];
        
    }
    
    _bubbleEmitter.position = _player.position;
    
    if (_player.position.y>(self.size.height-(self.size.height* 0.1))) {
        allowTap = NO;
    }
    else {
        allowTap = YES;
    }
    
}

- (void)Shark:(SKSpriteNode *)Player didCollideWithPlayer :(SKSpriteNode *)shaekk {
    NSLog(@"Hit");
    
    [shaekk removeFromParent];
    
}
- (void)coins:(SKSpriteNode *)Player didCollideWithPlayer :(SKSpriteNode *)Coinss {
    NSLog(@"Hit");
    [self runAction:_coinsound];
    [self incrementCoin];
    [Coinss removeFromParent];
    
}
//Did the player touch anything?
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (collitionActive==NO) {
        return;
    } else{
        
        SKPhysicsBody *firstBody, *secondBody;
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // 2
        if ((firstBody.categoryBitMask & kPlayerCategory) != 0 &&
            (secondBody.categoryBitMask & kPCoinCategory) != 0)
        {
            [self coins:(SKSpriteNode *) firstBody.node didCollideWithPlayer:(SKSpriteNode *) secondBody.node];
        }
        
        if ((firstBody.categoryBitMask & kPlayerCategory) != 0 &&
            (secondBody.categoryBitMask & kGroundCategory) != 0)
        {
            [self DiePlayerparticle];
            [self LifeMinus];
        }
        if ((firstBody.categoryBitMask & kPlayerCategory) != 0 &&
            (secondBody.categoryBitMask & kPipeCategory) != 0)
        {
            //[self Shark:(SKSpriteNode *) firstBody.node didCollideWithPlayer:(SKSpriteNode *) secondBody.node];
            
            [self DiePlayerparticle];
            [self LifeMinus];
        }
        if ((firstBody.categoryBitMask & kPlayerCategory) != 0 &&
            (secondBody.categoryBitMask & kPboostCategory) != 0)
        {
            NSLog(@"okokokoko");
        }
    }
    
}

-(void)SpeedParticle{
    
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"Speed" ofType:@"sks"];
    SKEmitterNode *burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstNode.position = CGPointMake(self.size.width+50,self.size.height/2);
    [self addChild:burstNode];
    burstNode.zPosition=10;
}

#pragma mark Die
-(void)die{
    adddisplaycounter++;
    [[NSUserDefaults standardUserDefaults]setInteger:adddisplaycounter forKey:@"adddisplaycounter"];
    NSLog(@"adddisplaycounter == %d",adddisplaycounter);
    
    if (adddisplaycounter == 2) {
        [appdelegate showStaticChartboostInterstitial];

    }
    if (adddisplaycounter ==4) {

        [appdelegate showChartboostVideoInterstitial];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"adddisplaycounter"];
    }
    
    [self runAction:_gameOversound];
    
    [_pipeTimer invalidate];
    [_scoreTimer invalidate];
    
    [self runAction:[SKAction runBlock:^{
        
        SKTransition *transition = [SKTransition fadeWithDuration:.4];
        GameOverScene *gameOver = [[GameOverScene alloc] initWithSize:self.size gameScore:_score Character:characterNumber];
        
        
        gameOver.userData = [[NSMutableDictionary alloc] init];
        
        [gameOver.userData setValue:[NSNumber numberWithInteger:_score] forKey:@"score"];
        
        [gameOver didMoveToView:self.view];
        
        [self.scene.view presentScene:gameOver transition:transition];
        
    }]];
    
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg1"];
        //bg1.size=self.size;
        bg1.position = CGPointMake(i * bg1.size.width, 0);
        bg1.anchorPoint = CGPointZero;
        bg1.name = @"bg1";
        [self addChild:bg1];
    }
    
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg2"];
        bg2.position = CGPointMake(i * bg2.size.width, 0);
        //bg2.size=self.size;
        
        bg2.anchorPoint = CGPointZero;
        bg2.name = @"bg2";
        [self addChild:bg2];
    }
    
    
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg1" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG1_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    //------------------
    [self enumerateChildNodesWithName:@"bg2" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG2_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    
}
//Update score
- (void)incrementScore
{
    _score++;
    [_scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_score]]];
    
    if (_score==10) {
        [self LifePlus];
    }
}

- (void)incrementCoin
{
    _Coin++;
    
    [_coinLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_Coin]]];
}
//Executes when the screen is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //If we are allowing the player to currently play
    if(allowTap == true){
        [self runAction:_swimSound];
        [self rotatePlayer];
        [_player.physicsBody setVelocity:CGVectorMake(_player.physicsBody.velocity.dx, kMaxVelocity)];
        
    }
    
}

-(void)LifeMinus{
    collitionActive=NO;
    [self hit];
    life --;
    [self runAction:_dieSound];
    
    
    if (life==1) {
        lifeimage1.alpha=0.0f;
    }
    if (life==0) {
        lifeimage2.alpha=0.0f;
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:0.5],
                              [SKAction runBlock:^{
             [self die];
             
         }]
                              ]]
         ];
        
        
    }
}

-(void)LifePlus{
 
    life ++;
    if (life==1) {
        lifeimage1.alpha=1.0f;
    }
    if (life==2) {
        lifeimage2.alpha=1.0f;
    }
}


-(void)hit{
    _player.alpha = 0.0;
    
    SKAction *blinkSequence = [SKAction sequence:@[
                                                   [SKAction fadeAlphaTo:1.0 duration:0.1],
                                                   [SKAction fadeAlphaTo:0.0 duration:0.1]
                                                   ]];
    
    
    [_player runAction:[SKAction repeatAction:blinkSequence count:7] completion:^{
        [self colideAction];
    }];
}

-(void)ScoreShow{
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"04b 30"];
    [_scoreLabel setPosition:CGPointMake(self.size.width/2 , self.size.height-30)];
    [_scoreLabel setFontSize:36];
    [_scoreLabel setFontColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]];
    [_scoreLabel setZPosition:100];
    [_scoreLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:_score]]];
    [self addChild:_scoreLabel];
}
-(void)CoinNumberShow{
    
    _coinLabel = [SKLabelNode labelNodeWithFontNamed:@"04b 30"];
    [_coinLabel setPosition:CGPointMake(self.size.width-50 , self.size.height-30)];
    [_coinLabel setFontSize:30];
    [_coinLabel setFontColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]];
    [_coinLabel setZPosition:100];
    [_coinLabel setText:[NSString stringWithFormat:@"coin %@", [NSNumber numberWithInteger:_Coin]]];
    [self addChild:_coinLabel];
}
@end
