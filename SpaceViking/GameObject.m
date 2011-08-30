//
//  GameObject.m
//  SpaceViking
//
//  Created by chen fei on 11-8-30.
//  Copyright 2011年 founder. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;

- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"GameObject init");
        screenSize = [[CCDirector sharedDirector] winSize];
        isActive = YES;
        gameObjectType = kObjectTypeNone;
    }
    
    return self;
}

- (void)changeState:(CharacterStates)newState
{
    CCLOG(@"GameObject->changeState method should be overridden");
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    CCLOG(@"GameObject->updateStateWithDeltaTime method should be overridden");
}

- (CGRect)adjustedBoundingBox
{
    CCLOG(@"GameObject->adjustBoundingBox should be overridden");
    return [self boundingBox];
}

- (CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName andClassName:(NSString *)className
{
    // get the path to the plist file
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", className];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
           plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    
    // read the plist file
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // if the plistDict was nil, the file was not found
    if (!plistDict) {
        CCLOG(@"error reading plist: %@.plist", className);
        return nil;
    }
    
    // get just the mini-dict for this animation
    NSDictionary *animationSettings = [plistDict objectForKey:animationName];
    if (!animationSettings) {
        CCLOG(@"could not locate AnimationWithName: %@", animationName);
        return nil;
    }
    
    CCAnimation *animationToReturn  = [CCAnimation animation];
    
    // get the delay value for the animation
    CGFloat animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    [animationToReturn setDelay:animationDelay];
    
    // add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    return animationToReturn;
}

@end
