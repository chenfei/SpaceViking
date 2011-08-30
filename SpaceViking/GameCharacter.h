//
//  GameCharacter.h
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameObject.h"
#import "CommonProtocols.h"

@interface GameCharacter : GameObject {
    int characterHealth;
    CharacterStates characterState;
}

@property(readwrite) int characterHealth;
@property(readwrite) CharacterStates characterState;

- (void)checkAndClampSpritePosition;
- (int)getWeaponDamage;

@end
