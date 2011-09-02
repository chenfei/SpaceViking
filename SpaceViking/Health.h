//
//  Health.h
//  SpaceViking
//
//  Created by chen fei on 11-8-31.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameObject.h"

@interface Health : GameObject {
    CCAnimation *healthAnim;
}

@property(nonatomic, retain) CCAnimation *healthAnim;

@end
