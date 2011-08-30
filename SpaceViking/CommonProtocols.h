//
//  CommonProtocols.h
//  SpaceViking
//
//  Created by chen fei on 11-8-29.
//  Copyright 2011年 founder. All rights reserved.
//

#ifndef SpaceViking_CommonProtocols_h
#define SpaceViking_CommonProtocols_h

typedef enum {
    kDirectionLeft,
    kDirectionRight,
} PhaserDirection;

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateCrouching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTraveling,
    kStateDrilling,
    kStateAfterJumping,
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kPowerUpTypeHealth,
    kPowerUpTypeMallet,
    kEnemyTypeRadarDish,
    kEnemyTypeSpaceCargoShip,
    kEnemyTypeAlienRobot,
    kEnemyTypePhaser,
    kVikingType,
    kSkullType,
    kRockType,
    kMeteorType,
    kFrozenVikingType,
    kIceType,
    kLongBlockType,
    kCartType,
    kSpikesType,
    kDiggerType,
    kGroundType,
} GameObjectType;

@protocol GameplayLayerDelegate <NSObject>

- (void)createObjectOfType:(GameObjectType)objectType
                withHealth:(int)initialHealth
                atLocation:(CGPoint)spawnLocation
                withZValue:(int)ZValue;

- (void)createPhaserWithDirection:(PhaserDirection)phaserDirection
                      andPosition:(CGPoint)spawnPosition;

@end


#endif
