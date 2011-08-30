//
//  Viking.h
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameCharacter.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"

typedef enum {
    kLeftHook,
    kRightHook,
} LastPunchType;

@interface Viking : GameCharacter {
    LastPunchType myLastPunch;
    BOOL isCarryingMallet;
    CCSpriteFrame *standingFrame;
    
    // standing, breathing and walking
    CCAnimation *breathingAnim;
    CCAnimation *breathingMalletAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingMalletAnim;
    
    // crouching, standing up and jumping
    CCAnimation *crouchingAnim;
    CCAnimation *crouchingMalletAnim;
    CCAnimation *standingUpAnim;
    CCAnimation *standingUpMalletAnim;
    CCAnimation *jumpingAnim;
    CCAnimation *jumpingMalletAnim;
    CCAnimation *afterJumpingAnim;
    CCAnimation *afterJumpingMalletAnim;
    
    // punching
    CCAnimation *rightPunchAnim;
    CCAnimation *leftPunchAnim;
    CCAnimation *malletPunchAnim;
    
    // taking damage and death
    CCAnimation *phaserShockAnim;
    CCAnimation *deathAnim;
    
    SneakyButton *jumpButton;
    SneakyButton *attackButton;
    SneakyJoystick *joystick;
    
    CGFloat millisecondsStayingIdle;
}

@property(nonatomic, retain) CCAnimation *breathingAnim;
@property(nonatomic, retain) CCAnimation *breathingMalletAnim;
@property(nonatomic, retain) CCAnimation *walkingAnim;
@property(nonatomic, retain) CCAnimation *walkingMalletAnim;

// crouching, standing up, jumping
@property(nonatomic, retain) CCAnimation *crouchingAnim;
@property(nonatomic, retain) CCAnimation *crouchingMalletAnim;
@property(nonatomic, retain) CCAnimation *standingUpAnim;
@property(nonatomic, retain) CCAnimation *standingUpMalletAnim;
@property(nonatomic, retain) CCAnimation *jumpingAnim;
@property(nonatomic, retain) CCAnimation *jumpingMalletAnim;
@property(nonatomic, retain) CCAnimation *afterJumpingAnim;
@property(nonatomic, retain) CCAnimation *afterJumpingMalletAnim;

// punching
@property(nonatomic, retain) CCAnimation *rightPunchAnim;
@property(nonatomic, retain) CCAnimation *leftPunchAnim;
@property(nonatomic, retain) CCAnimation *malletPunchAnim;

// taking damage and death
@property(nonatomic, retain) CCAnimation *phaserShockAnim;
@property(nonatomic, retain) CCAnimation *deathAnim;

@property(nonatomic, retain) SneakyButton *jumpButton;
@property(nonatomic, retain) SneakyButton *attackButton;
@property(nonatomic, retain) SneakyJoystick *joystick;

@end
