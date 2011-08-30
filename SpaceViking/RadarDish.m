//
//  RadarDish.m
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "RadarDish.h"

@interface RadarDish ()

- (void)initAnimations;

@end

@implementation RadarDish

@synthesize tiltingAnim;
@synthesize transmittingAnim;
@synthesize takingAHitAnim;
@synthesize blowingUpAnim;

- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"### RadarDish initialized");
        [self initAnimations];
        characterHealth = 100.0;
        gameObjectType = kEnemyTypeRadarDish;
        [self changeState:kStateSpawning];
    }
    
    return self;
}

- (void)dealloc
{
    self.tiltingAnim = nil;
    self.transmittingAnim = nil;
    self.takingAHitAnim = nil;
    self.blowingUpAnim = nil;
    
    [super dealloc];
}

- (void)initAnimations
{
    self.tiltingAnim = [self loadPlistForAnimationWithName:@"tiltingAnim" andClassName:NSStringFromClass([self class])];
    self.transmittingAnim = [self loadPlistForAnimationWithName:@"transmittingAnim" andClassName:NSStringFromClass([self class])];
    self.takingAHitAnim = [self loadPlistForAnimationWithName:@"takingAHitAnim" andClassName:NSStringFromClass([self class])];
    self.blowingUpAnim = [self loadPlistForAnimationWithName:@"blowingUpAnim" andClassName:NSStringFromClass([self class])];
}

- (void)changeState:(CharacterStates)newState
{
    [self stopAllActions];
    
    [self setCharacterState:newState];
    
    id action = nil;
    
    switch (newState) {
        case kStateSpawning:
            CCLOG(@"RadarDish->Starting the Spawning Animation");
            action = [CCAnimate actionWithAnimation:tiltingAnim restoreOriginalFrame:NO];
            break;
        case kStateIdle:
            CCLOG(@"RadarDish->Changing State to Idle");
            action = [CCAnimate actionWithAnimation:transmittingAnim restoreOriginalFrame:NO];
            break;
        case kStateTakingDamage:
            CCLOG(@"RadarDish->Changing State to TakingDamage");
            characterHealth = characterHealth - [vikingCharacter getWeaponDamage];
            if (characterHealth < 0.0)
                [self changeState:kStateDead];
            else
                action = [CCAnimate actionWithAnimation:takingAHitAnim restoreOriginalFrame:NO];
            break;
        case kStateDead:
            CCLOG(@"RadarDish->Changing State to Dead");
            action = [CCAnimate actionWithAnimation:blowingUpAnim restoreOriginalFrame:NO];
            break;
        default:
            CCLOG(@"Unhandled state %d in RadarDish", newState);
            break;
    }
    if (action)
        [self runAction:action];
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if (characterState == kStateDead)
        return;
    vikingCharacter = (GameCharacter *)[[self parent] getChildByTag:kVikingSpriteTagValue];
    CGRect vikingBoundingBox = [vikingCharacter adjustedBoundingBox];
    CharacterStates vikingState = [vikingCharacter characterState];
    
    // calculate if the viking is attacking and nearby
    if (vikingState == kStateAttacking && CGRectIntersectsRect([self adjustedBoundingBox], vikingBoundingBox))
        if (characterState != kStateTakingDamage) {
            [self changeState:kStateTakingDamage];
            return;
        }
    
    if ([self numberOfRunningActions] == 0 && characterState != kStateIdle) {
        CCLOG(@"going to idle");
        [self changeState:kStateIdle];
        return;
    }
}

@end
