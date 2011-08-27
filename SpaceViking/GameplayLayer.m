//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by chen fei on 11-8-26.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameplayLayer.h"
#import "CCDirector.h"

@implementation GameplayLayer

- (void)initJoystickAndButtons
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect joystickBaseDimensions = CGRectMake(0, 0, 128.0, 128.0);
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0, 64.0);
    CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0, 64.0);
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition = CGPointMake(screenSize.width*0.0625, screenSize.height*0.052);
        jumpButtonPosition = CGPointMake(screenSize.width*0.946, screenSize.height*0.052);
        attackButtonPosition = CGPointMake(screenSize.width*0.947, screenSize.height*0.169);
    } else {
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        joystickBasePosition = CGPointMake(screenSize.width*0.07, screenSize.height*0.11);
        jumpButtonPosition = CGPointMake(screenSize.width*0.93, screenSize.height*0.11);
        attackButtonPosition = CGPointMake(screenSize.width*0.93, screenSize.height*0.35);
    }
    
    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position = joystickBasePosition;
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
    
    leftJoyStick = [joystickBase.joystick retain];
    [self addChild:joystickBase];
    
    SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    jumpButtonBase.position = jumpButtonPosition;
    jumpButtonBase.defaultSprite = [CCSprite spriteWithFile:@"jumpUp.png"];
    jumpButtonBase.activatedSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.pressSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
    jumpButton = [jumpButtonBase.button retain];
    jumpButton.isToggleable = NO;
    [self addChild:jumpButtonBase];
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    attackButtonBase.position = attackButtonPosition;
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
    attackButton = [attackButtonBase.button retain];
    attackButton.isToggleable = NO;
    [self addChild:attackButtonBase];
}

- (void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(CGFloat)deltaTime
{
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0);
    CGPoint newPosition = CGPointMake(tempNode.position.x + scaledVelocity.x * deltaTime,
                                      tempNode.position.y + scaledVelocity.y * deltaTime);
    [tempNode setPosition:newPosition];
    
    if (jumpButton.active)
        CCLOG(@"Jump button is pressed");
    if (attackButton.active)
        CCLOG(@"Attack button is pressed");
    
}

- (void)update:(ccTime)deltaTime
{
    [self applyJoystick:leftJoyStick toNode:vikingSprite forTimeDelta:deltaTime];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
//        vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlas_default.plist"];
        CCSpriteBatchNode *chapter2SpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas_default.png"];

        vikingSprite = [CCSprite spriteWithSpriteFrameName:@"sv_anim_1.png"];
        [chapter2SpriteBatchNode addChild:vikingSprite];
        
        [vikingSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17)];
//        [self addChild:vikingSprite];
        [self addChild:chapter2SpriteBatchNode];
        
        [self initJoystickAndButtons];
        [self scheduleUpdate];
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [vikingSprite setScaleX:screenSize.width/1024];
            [vikingSprite setScaleY:screenSize.height/768];
        }
    }
    
    return self;
}

@end
