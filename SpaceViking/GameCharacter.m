//
//  GameCharacter.m
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize characterHealth;
@synthesize characterState;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)checkAndClampSpritePosition
{
    CGPoint pos = [self position];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (pos.x < 30.0)
            [self setPosition:ccp(30.0, pos.y)];
        else if (pos.x > 1000.0)
            [self setPosition:ccp(1000.0, pos.y)];
    } else {
        if (pos.x < 24.0)
            [self setPosition:ccp(24.0, pos.y)];
        else if (pos.x > 456.0)
            [self setPosition:ccp(456.0, pos.y)];
    }
}

- (int)getWeaponDamage
{
    CCLOG(@"getWeaponDamage should be overidden");
    return 0;
}



@end
