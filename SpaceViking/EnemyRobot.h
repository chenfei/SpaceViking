//
//  EnemyRobot.h
//  SpaceViking
//
//  Created by chen fei on 11-9-1.
//  Copyright 2011年 founder. All rights reserved.
//
//  EnemyRobot.h
//  SpaceViking
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface EnemyRobot : GameCharacter {
    CCAnimation *robotWalkingAnim;
    
    CCAnimation *raisePhaserAnim;
    CCAnimation *shootPhaserAnim;
    CCAnimation *lowerPhaserAnim;
    
    CCAnimation *torsoHitAnim;
    CCAnimation *headHitAnim;
    CCAnimation *robotDeathAnim;
    
    BOOL isVikingWithinBoundingBox;
    BOOL isVikingWithinSight;
    
    GameCharacter *vikingCharacter;
    id <GameplayLayerDelegate> delegate;
    
    
}

@property (nonatomic,assign) id <GameplayLayerDelegate> delegate;
@property (nonatomic, retain) CCAnimation *robotWalkingAnim;
@property (nonatomic, retain) CCAnimation *raisePhaserAnim;
@property (nonatomic, retain) CCAnimation *shootPhaserAnim;
@property (nonatomic, retain) CCAnimation *lowerPhaserAnim;
@property (nonatomic, retain) CCAnimation *torsoHitAnim;
@property (nonatomic, retain) CCAnimation *headHitAnim;
@property (nonatomic, retain) CCAnimation *robotDeathAnim;

-(void)initAnimations;

@end
