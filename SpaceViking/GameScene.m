//
//  GameScene.m
//  SpaceViking
//
//  Created by chen fei on 11-8-26.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
    }
    
    return self;
}

@end
