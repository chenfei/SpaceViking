//
//  Constants.h
//  SpaceViking
//
//  Created by chen fei on 11-8-29.
//  Copyright 2011年 founder. All rights reserved.
//

#ifndef SpaceViking_Constants_h
#define SpaceViking_Constants_h

#define kVikingSpriteZValue             100
#define kVikingSpriteTagValue           0
#define kVikingIdleTimer                3.0
#define kVikingFistDamage               10
#define kVikingMalletDamage             40
#define kRadarDishTagValue              10

#define kMainMenuTagValue               10
#define kSceneMenuTagValue              20

typedef enum {
    kNoSceneUninitialized   = 0,
    kMainMenuScene,
    kOptionScene,
    kCreditsScene,
    kIntroScene,
    kLevelCompleteScene,
    kGameLevel1             = 101,
    kGameLevel2,
    kGameLevel3,
    kGameLevel4,
    kGameLevel5,
    kCutSceneForLevel2      = 201,
} SceneTypes;

typedef enum {
    kLinkTypeBookSite,
    kLinkTypeDeveloperSiteRod,
    kLinkTypeDeveloperSiteRay,
    kLinkTypeArtistSite,
    kLinkTypeMusicianSite
} LinkTypes;

#define ENEMY_STATE_DEBUG   0

#endif
