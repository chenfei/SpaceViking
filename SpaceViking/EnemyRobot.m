//  EnemyRobot.m
//  SpaceViking
//

#import "EnemyRobot.h"

@implementation EnemyRobot
@synthesize delegate;
@synthesize robotWalkingAnim;
@synthesize raisePhaserAnim;
@synthesize shootPhaserAnim;
@synthesize lowerPhaserAnim;
@synthesize torsoHitAnim;
@synthesize headHitAnim;
@synthesize robotDeathAnim;

-(void) dealloc {
    delegate = nil;
    [robotWalkingAnim release];
    [raisePhaserAnim release];
    [shootPhaserAnim release];
    [lowerPhaserAnim release];
    [torsoHitAnim release];
    [headHitAnim release];
    [robotDeathAnim release];
    
    [super dealloc];
}

-(void)shootPhaser {
    CGPoint phaserFiringPosition;
    PhaserDirection phaserDir;
    CGRect boundingBox = [self boundingBox];
    CGPoint position = [self position];
    
    float xPosition = position.x + boundingBox.size.width * 0.542f;
    float yPosition = position.y + boundingBox.size.height * 0.25f;
    
    if ([self flipX]) {
        CCLOG(@"Facing right, Firing to the right");
        phaserDir = kDirectionRight;
    } else {
        CCLOG(@"Facing left, Firing to the left");
        xPosition = xPosition * -1.0f; // Reverse direction
        phaserDir = kDirectionLeft;
    }
    phaserFiringPosition = ccp(xPosition, yPosition);
    [delegate createPhaserWithDirection:phaserDir andPosition:phaserFiringPosition];
}

-(CGRect)eyesightBoundingBox {
    // Eyesight is 3 robot widths in the direction the robot is facing.
    CGRect robotSightBoundingBox;
    CGRect robotBoundingBox = [self adjustedBoundingBox];
    if ([self flipX]) {
        robotSightBoundingBox = CGRectMake(robotBoundingBox.origin.x, 
                                           robotBoundingBox.origin.y, 
                                           
                                           robotBoundingBox.size.width*3.0f, 
                                           robotBoundingBox.size.height);
    } else {
        robotSightBoundingBox = 
        CGRectMake(robotBoundingBox.origin.x - 
                   (robotBoundingBox.size.width*2.0f), 
                   robotBoundingBox.origin.y, 
                   robotBoundingBox.size.width*3.0f, 
                   robotBoundingBox.size.height);
    }
    return robotSightBoundingBox;
}

-(void)changeState:(CharacterStates)newState {
    if (characterState == kStateDead)
        return; // No need to change state further once I am dead
    
    [self stopAllActions];
    id action = nil; 
    characterState = newState;
    
    switch (newState) {
        case kStateSpawning:
            [self runAction:[CCFadeOut actionWithDuration:0.01f]]; 
            // Fades out the sprite if it was visible before
            [self setDisplayFrame:
             [[CCSpriteFrameCache sharedSpriteFrameCache] 
              spriteFrameByName:@"teleport.png"]];
            
            action =  [CCSpawn actions:
                       [CCRotateBy actionWithDuration:1.5f angle:360],
                       [CCFadeIn actionWithDuration:1.5f],
                       nil];
            break;
            
        case kStateIdle:
            CCLOG(@"EnemyRobot->Changing State to Idle");
            [self setDisplayFrame:
             [[CCSpriteFrameCache sharedSpriteFrameCache] 
              spriteFrameByName:@"an1_anim1.png"]];
            break;
            
        case kStateWalking:
            CCLOG(@"EnemyRobot->Changing State to Walking");
            if (isVikingWithinBoundingBox) 
                break; // AI will change to Attacking on next frame
            
            float xPositionOffSet = 150.0f;
            if (isVikingWithinSight) {
                if ([vikingCharacter position].x < [self position].x) 
                    xPositionOffSet = xPositionOffSet * -1; 
                // Invert to -150
            } else {
                if (CCRANDOM_0_1() > 0.5f) 
                    xPositionOffSet = xPositionOffSet * -1;
                
                if (xPositionOffSet > 0.0f) {
                    [self setFlipX:YES];
                } else {
                    [self setFlipX:NO];
                }
            }
            action = [CCSpawn actions:
                      [CCAnimate actionWithAnimation:robotWalkingAnim 
                                restoreOriginalFrame:NO],
                      [CCMoveTo actionWithDuration:2.4f 
                                          position:ccp([self position].x + 
                                                       xPositionOffSet, 
                                                       [self position].y)],
                      nil];
            break;
            
        case kStateAttacking:
            CCLOG(@"EnemyRobot->Changing State to Attacking");
            action = [CCSequence actions:
                      [CCAnimate actionWithAnimation:raisePhaserAnim 
                                restoreOriginalFrame:NO],
                      [CCDelayTime actionWithDuration:1.0f],
                      [CCAnimate actionWithAnimation:shootPhaserAnim 
                                restoreOriginalFrame:NO],
                      [CCCallFunc actionWithTarget:self 
                                          selector:@selector(shootPhaser)],
                      [CCAnimate actionWithAnimation:lowerPhaserAnim 
                                restoreOriginalFrame:NO],
                      [CCDelayTime actionWithDuration:2.0f],
                      nil];
            break;
            
        case kStateTakingDamage:
            CCLOG(@"EnemyRobot->Changing State to TakingDamage");
            if ([vikingCharacter getWeaponDamage] > kVikingFistDamage){
                // If the viking has the mallet, then 
                action = 
                [CCAnimate actionWithAnimation:headHitAnim 
                          restoreOriginalFrame:YES];
            } else {
                // Viking does not have weapon, body blow
                action = [CCAnimate actionWithAnimation:torsoHitAnim 
                                   restoreOriginalFrame:YES];
            }
            break;
            
        case kStateDead:
            CCLOG(@"EnemyRobot -> Going to Dead State");
            action = [CCSequence actions:
                      [CCAnimate actionWithAnimation:robotDeathAnim 
                                restoreOriginalFrame:NO],
                      [CCDelayTime actionWithDuration:2.0f],
                      [CCFadeOut actionWithDuration:2.0f],
                      nil];
            break;
            
        default:
            CCLOG(@"Enemy Robot -> Unknown CharState %d", 
                  characterState);
            break;
    }
    
    if (action != nil)  
        [self runAction:action];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    [self checkAndClampSpritePosition];
    
    if ((characterState != kStateDead) && (characterHealth <= 0)) {
        [self changeState:kStateDead];
        return;
    }
    
    vikingCharacter = (GameCharacter*)[[self parent] 
                                       getChildByTag:kVikingSpriteTagValue];
    CGRect vikingBoudingBox = [vikingCharacter adjustedBoundingBox];
    CGRect robotBoundingBox = [self adjustedBoundingBox];
    CGRect robotSightBoundingBox = [self eyesightBoundingBox];
    
    isVikingWithinBoundingBox = 
    CGRectIntersectsRect(vikingBoudingBox, robotBoundingBox) ? 
    YES : NO;
    isVikingWithinSight = 
    CGRectIntersectsRect(vikingBoudingBox, robotSightBoundingBox)? 
    YES : NO;
    
    if ((isVikingWithinBoundingBox) && 
        ([vikingCharacter characterState] == kStateAttacking)) {
        // Viking is attacking this robot
        if ((characterState != kStateTakingDamage) && 
            (characterState != kStateDead)) {
            [self setCharacterHealth:
             [self characterHealth] - 
             [vikingCharacter getWeaponDamage]];
            if (characterHealth > 0) {
                [self changeState:kStateTakingDamage];
            } else {
                [self changeState:kStateDead];
            }
            return; // Nothing to update further, stop and show damage
        }
    } 
    
    if ([self numberOfRunningActions] == 0) {
        
        if (characterState == kStateDead) {
            // Robot is dead, remove
            [self setVisible:NO];
            [self removeFromParentAndCleanup:YES];
        } else if ([vikingCharacter characterState] == kStateDead) {
            // Viking is dead, walk around the scene
            [self changeState:kStateWalking];
        } else if (isVikingWithinSight) {
            [self changeState:kStateAttacking];
        }  else {
            // Viking alive and out of sight, resume walking
            [self changeState:kStateWalking];
        }
    } 
}

-(CGRect)AdjustedBoundingBox {
    // Shrink the bounding box by 18% on the X axis, and move it to the right by 18% 
    // and crop it by 5% on the Y Axis. 
    // On the iPad this is 30 pixels on the X axis and cut 10 pixels from the top
    CGRect enemyRobotBoudingBox = [self boundingBox];
    float xOffsetAmount = enemyRobotBoudingBox.size.width * 0.18f;
    float yCropAmount = enemyRobotBoudingBox.size.height * 0.05f;
    enemyRobotBoudingBox = CGRectMake(enemyRobotBoudingBox.origin.x + xOffsetAmount, 
                                      enemyRobotBoudingBox.origin.y, 
                                      enemyRobotBoudingBox.size.width - xOffsetAmount, 
                                      enemyRobotBoudingBox.size.height - yCropAmount);
    return enemyRobotBoudingBox;
}

#pragma mark -
#pragma mark initAnimations

-(void)initAnimations {
    
    [self setRobotWalkingAnim:
     [self loadPlistForAnimationWithName:@"robotWalkingAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setRaisePhaserAnim:
     [self loadPlistForAnimationWithName:@"raisePhaserAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setShootPhaserAnim:
     [self loadPlistForAnimationWithName:@"shootPhaserAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setLowerPhaserAnim:
     [self loadPlistForAnimationWithName:@"lowerPhaserAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setTorsoHitAnim:
     [self loadPlistForAnimationWithName:@"torsoHitAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setHeadHitAnim:
     [self loadPlistForAnimationWithName:@"headHitAnim" 
                            andClassName:NSStringFromClass([self class])]];
    
    [self setRobotDeathAnim:
     [self loadPlistForAnimationWithName:@"robotDeathAnim" 
                            andClassName:NSStringFromClass([self class])]];
}

-(id) init
{
    if( (self=[super init]) )
    {
        isVikingWithinBoundingBox = NO; 
        isVikingWithinSight = NO;
        gameObjectType = kEnemyTypeAlienRobot;
        [self initAnimations];
        srandom(time(NULL)); 
    }
    return self;
}

@end

