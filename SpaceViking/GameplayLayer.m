//  GameplayLayer.m
//  SpaceViking

#import "GameplayLayer.h"
#import "SpaceCargoShip.h"
#import "EnemyRobot.h"
#import "PhaserBullet.h"
#import "Mallet.h"
#import "Health.h"

@implementation GameplayLayer

- (void) dealloc {
    [leftJoystick release];
    [jumpButton release];
    [attackButton release];
    [super dealloc];
    
}

-(void)initJoystickAndButtons {
    CGSize screenSize = [CCDirector sharedDirector].winSize;       // 1
    // 2
    CGRect joystickBaseDimensions = CGRectMake(0, 0, 128.0f, 128.0f);
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    // 3
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    // 4
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iPhone 3.2 or later.
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition = ccp(screenSize.width*0.0625f,
                                   screenSize.height*0.052f);
        
        jumpButtonPosition = ccp(screenSize.width*0.946f,
                                 screenSize.height*0.052f);
        
        attackButtonPosition = ccp(screenSize.width*0.947f,
                                   screenSize.height*0.169f);
    } else {
        // The device is an iPhone or iPod touch.
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        
        joystickBasePosition = ccp(screenSize.width*0.07f,
                                   screenSize.height*0.11f);
        
        jumpButtonPosition = ccp(screenSize.width*0.93f,
                                 screenSize.height*0.11f);
        
        attackButtonPosition = ccp(screenSize.width*0.93f,
                                   screenSize.height*0.35f);
    }
    
    SneakyJoystickSkinnedBase *joystickBase =
    [[[SneakyJoystickSkinnedBase alloc] init] autorelease];        // 5
    joystickBase.position = joystickBasePosition;                  // 6
    joystickBase.backgroundSprite = 
    [CCSprite spriteWithFile:@"dpadDown.png"];                     // 7
    joystickBase.thumbSprite = 
    [CCSprite spriteWithFile:@"joystickDown.png"];                 // 8
    joystickBase.joystick = [[SneakyJoystick alloc]
                             initWithRect:joystickBaseDimensions]; // 9
    leftJoystick = [joystickBase.joystick retain];                // 10
    [self addChild:joystickBase];                                 // 11
    
    SneakyButtonSkinnedBase *jumpButtonBase =
    [[[SneakyButtonSkinnedBase alloc] init] autorelease];         // 12
    jumpButtonBase.position = jumpButtonPosition;                 // 13
    jumpButtonBase.defaultSprite = 
    [CCSprite spriteWithFile:@"jumpUp.png"];                      // 14
    jumpButtonBase.activatedSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                    // 15
    jumpButtonBase.pressSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                    // 16
    jumpButtonBase.button = [[SneakyButton alloc] 
                             initWithRect:jumpButtonDimensions];  // 17
    jumpButton = [jumpButtonBase.button retain];                  // 18
    jumpButton.isToggleable = NO;                                 // 19
    [self addChild:jumpButtonBase];                               // 20
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];             // 21
    attackButtonBase.position = attackButtonPosition;             // 22
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];                                    // 23
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];                                  // 24
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];                                  // 25
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];                             // 26
    attackButton = [attackButtonBase.button retain];              // 27
    attackButton.isToggleable = NO;                               // 28
    [self addChild:attackButtonBase];                             // 29
}



// Located in Viking.m from Chapter 4 on-wards
//-(void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime
//{
//    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0f); // 1
//    
//    CGPoint newPosition = 
//    ccp(tempNode.position.x + scaledVelocity.x * deltaTime, 
//        tempNode.position.y + scaledVelocity.y * deltaTime);       // 2
//    
//    [tempNode setPosition:newPosition];                            // 3
//    
//    if (jumpButton.active == YES) { 
//        CCLOG(@"Jump button is pressed.");                         // 4
//    }
//    if (attackButton.active == YES) {
//        CCLOG(@"Attack button is pressed.");                       // 5
//    }
//}

#pragma mark –
#pragma mark Update Method
-(void) update:(ccTime)deltaTime {
    CCArray *listOfGameObjects = 
    [sceneSpriteBatchNode children];                     // 1
    for (GameCharacter *tempChar in listOfGameObjects) {         // 2
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];                         // 3
    }
}

#pragma mark -
-(void)createObjectOfType:(GameObjectType)objectType 
               withHealth:(int)initialHealth
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue {
    
    if (kEnemyTypeRadarDish == objectType) {
        CCLOG(@"Creating the Radar Enemy");
        RadarDish *radarDish = [[RadarDish alloc] initWithSpriteFrameName:@"radar_1.png"];
        [radarDish setCharacterHealth:initialHealth];
        [radarDish setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:radarDish z:ZValue tag:kRadarDishTagValue];
        [radarDish release];
    } else if (kEnemyTypeAlienRobot == objectType) {
        CCLOG(@"Creating the Alien Robot");
        EnemyRobot *enemyRobot = [[EnemyRobot alloc] initWithSpriteFrameName:@"an1_anim1.png"];
        [enemyRobot setCharacterHealth:initialHealth];
        [enemyRobot setPosition:spawnLocation];
        [enemyRobot changeState:kStateSpawning];
        [sceneSpriteBatchNode addChild:enemyRobot z:ZValue];
        [enemyRobot setDelegate:self];
        [enemyRobot release];
    } else if (kEnemyTypeSpaceCargoShip == objectType) {
        CCLOG(@"Creating the Cargo Ship Enemy");
        SpaceCargoShip *spaceCargoShip = [[SpaceCargoShip alloc] initWithSpriteFrameName:@"ship_2.png"];
        [spaceCargoShip setDelegate:self];
        [spaceCargoShip setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:spaceCargoShip z:ZValue];
        [spaceCargoShip release];
    } else if (kPowerUpTypeMallet == objectType) {
        CCLOG(@"GameplayLayer -> Creating mallet powerup");
        Mallet *mallet = [[Mallet alloc] initWithSpriteFrameName:@"mallet_1.png"];
        [mallet setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:mallet];
        [mallet release];
    } else if (kPowerUpTypeHealth == objectType) {
        CCLOG(@"GameplayLayer-> Creating Health Powerup");
        Health *health = [[Health alloc] initWithSpriteFrameName:@"sandwich_1.png"];
        [health setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:health];
        [health release];
    }
}

-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection andPosition:(CGPoint)spawnPosition {
    PhaserBullet *phaserBullet = [[PhaserBullet alloc] initWithSpriteFrameName:@"beam_1.png"];
    [phaserBullet setPosition:spawnPosition];
    [phaserBullet setMyDirection:phaserDirection];
    [phaserBullet setCharacterState:kStateSpawning];
    [sceneSpriteBatchNode addChild:phaserBullet];
    [phaserBullet release];
}

-(void)addEnemy {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    RadarDish *radarDish = (RadarDish*)[sceneSpriteBatchNode getChildByTag:kRadarDishTagValue];
    if (radarDish != nil) {
        if ([radarDish characterState] != kStateDead) {
            [self createObjectOfType:kEnemyTypeAlienRobot withHealth:100 
                          atLocation:ccp(screenSize.width * 0.195f,
                                         screenSize.height * 0.1432f) 
                          withZValue:2];
        } else {
            [self unschedule:@selector(addEnemy)];
        }
    }
} 


-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        // enable touches
        self.isTouchEnabled = YES; 
        
        srandom(time(NULL)); // Seeds the random number generator
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {         
            [[CCSpriteFrameCache sharedSpriteFrameCache] 
             addSpriteFramesWithFile:@"scene1atlas.plist"];          // 1
            sceneSpriteBatchNode = 
            [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"]; // 2
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] 
             addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];          // 1
            sceneSpriteBatchNode = 
            [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];// 2
        }
        
        
        [self addChild:sceneSpriteBatchNode z:0];                // 3
        [self initJoystickAndButtons];                           // 4
        Viking *viking = [[Viking alloc] 
                          initWithSpriteFrame:[[CCSpriteFrameCache 
                                                sharedSpriteFrameCache] 
                                               spriteFrameByName:@"sv_anim_1.png"]];            // 5
        [viking setJoystick:leftJoystick];
        [viking setJumpButton:jumpButton];
        [viking setAttackButton:attackButton];
        [viking setPosition:ccp(screenSize.width * 0.35f, 
                                screenSize.height * 0.14f)]; 
        [viking setCharacterHealth:100];
        
        [sceneSpriteBatchNode 
         addChild:viking 
         z:kVikingSpriteZValue 
         tag:kVikingSpriteTagValue];                     // 6
        
        [self createObjectOfType:kEnemyTypeRadarDish 
                      withHealth:100 
                      atLocation:ccp(screenSize.width * 0.878f,
                                     screenSize.height * 0.13f) 
                      withZValue:10];                            // 7
        
        
//        id wavesAction = [CCWaves actionWithWaves:5 amplitude:20 horizontal:NO vertical:YES grid:ccg(15, 10) duration:20];
//        [sceneSpriteBatchNode runAction:[CCRepeatForever actionWithAction:wavesAction]];
        
        CCLabelTTF *gameBeginLabel = [CCLabelTTF labelWithString:@"Game Start" fontName:@"Helvetica" fontSize:64];
        [gameBeginLabel setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:gameBeginLabel];
        [gameBeginLabel setAnchorPoint:ccp(0.5, 0.5)];
        id labelAction = [CCSpawn actions:[CCScaleBy actionWithDuration:2.0 scale:4], [CCFadeOut actionWithDuration:2.0], nil];
        [gameBeginLabel runAction:labelAction];
        
        [self scheduleUpdate];                                   // 8
        
        
        [self schedule:@selector(addEnemy) interval:10.0f];
        [self createObjectOfType:kEnemyTypeSpaceCargoShip withHealth:0 
                      atLocation:ccp(screenSize.width * -0.5f,
                                     screenSize.height * 0.74f) 
                      withZValue:50];
        
    }
    return self; 
}



@end
