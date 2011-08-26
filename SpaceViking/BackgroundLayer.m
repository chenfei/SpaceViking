//
//  BackgroundLayer.m
//  SpaceViking
//
//  Created by chen fei on 11-8-26.
//  Copyright 2011年 founder. All rights reserved.
//

#import "BackgroundLayer.h"
#import "CCSprite.h"
#import "CCDirector.h"

@implementation BackgroundLayer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        } else {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
        }
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backgroundImage];
    }
    
    return self;
}

@end
