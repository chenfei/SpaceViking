//
//  Health.m
//  SpaceViking
//
//  Created by chen fei on 11-8-31.
//  Copyright 2011年 founder. All rights reserved.
//

#import "Health.h"

@implementation Health

@synthesize healthAnim;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        screenSize = [CCDirector sharedDirector].winSize;
        [self changeState:kStateSpawning];
        gameObjectType = kPowerUpTypeHealth;
    }
    
    return self;
}

- (void)dealloc
{
    self.healthAnim = nil;
    
    [super dealloc];
}

- (void)changeState:(CharacterStates)newState
{
    if (newState == kStateSpawning) {
        id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:healthAnim restoreOriginalFrame:NO]];
        [self runAction:action];
    } else {
        [self setVisible:NO];
        [self removeFromParentAndCleanup:YES];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    CGFloat groundHeight = screenSize.height * 0.065;
    if ([self position].y > groundHeight)
        self.position = ccp(self.position.x, self.position.y - 5.0);
}

- (void)initAnimations
{
    [self setHealthAnim:[self loadPlistForAnimationWithName:@"healthAnimation" andClassName:NSStringFromClass([self class])]];
    
}

@end
