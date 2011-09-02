//
//  PhaserBullet.h
//  SpaceViking
//
//  Created by chen fei on 11-9-2.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameCharacter.h"

@interface PhaserBullet : GameCharacter {
    CCAnimation *firingAnim;
    CCAnimation *travelingAnim;
    
    PhaserDirection myDirection;
}

@property(nonatomic, retain) CCAnimation *firingAnim;
@property(nonatomic, retain) CCAnimation *travelingAnim;
@property PhaserDirection myDirection;

@end
