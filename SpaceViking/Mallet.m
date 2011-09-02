//
//  Mallet.m
//  SpaceViking
//
//  Created by chen fei on 11-8-31.
//  Copyright 2011年 founder. All rights reserved.
//

#import "Mallet.h"

@implementation Mallet

@synthesize malletAnim;

- (id)init
{
    self = [super init];
    if (self) {
        screenSize = [CCDirector sharedDirector].winSize;
        gameObjectType = kPowerUpTypeMallet;
        [self initAnimations];
        [self changeState:kStateSpawning];
    }
    
    return self;
}

- (void)dealloc
{
    self.malletAnim = nil;
    
    [super dealloc];
}

- (void)changeState:(CharacterStates)newState
{
    if (newState == kStateSpawning) {
        id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:malletAnim restoreOriginalFrame:NO]];
        [self runAction:action];
    } else {
        [self setVisible:NO];
        [self removeFromParentAndCleanup:YES];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    CGFloat groundHeight = screenSize.height * 0.065;
    if (self.position.y > groundHeight)
        self.position = ccp(self.position.x, self.position.y - 5.0);
}

- (void)initAnimations
{
    [self setMalletAnim:[self loadPlistForAnimationWithName:@"malletAnim" andClassName:NSStringFromClass([self class])]];
}

@end
