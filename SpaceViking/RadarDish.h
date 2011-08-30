//
//  RadarDish.h
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameCharacter.h"

@interface RadarDish : GameCharacter {
    CCAnimation *tiltingAnim;
    CCAnimation *transmittingAnim;
    CCAnimation *takingAHitAnim;
    CCAnimation *blowingUpAnim;
    GameCharacter *vikingCharacter;
}

@property(nonatomic, retain) CCAnimation *tiltingAnim;
@property(nonatomic, retain) CCAnimation *transmittingAnim;
@property(nonatomic, retain) CCAnimation *takingAHitAnim;
@property(nonatomic, retain) CCAnimation *blowingUpAnim;

@end
