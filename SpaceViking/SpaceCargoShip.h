//
//  SpaceCargoShip.h
//  SpaceViking
//
//  Created by chen fei on 11-9-1.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameObject.h"

@interface SpaceCargoShip : GameObject {
    BOOL hasDroppedMallet;
    id<GameplayLayerDelegate> delegate;
}

@property(nonatomic, assign) id<GameplayLayerDelegate> delegate;

@end
