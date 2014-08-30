//
//  Bat.m
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Bat.h"


@implementation Bat {
    CCNode* _player;
    BatState _state;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Bat *)createBat:(CGPoint)position orientation:(Orientation)orientation player:(CCNode*)player {
    return [[self alloc] init:position orientation:orientation player:player];
}

- (id)init: (CGPoint)position orientation:(Orientation)orientation player:(CCNode*)player {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Initialize sprite
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_hang.png"]];
    self.position = position;
    self.rotation = 90 * orientation;
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(self.contentSize.width,self.contentSize.height)} cornerRadius:0.0f];
    self.physicsBody.collisionGroup = @"batGroup";
    self.physicsBody.collisionType = @"batCollision";
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    
    _player = player;
    _state = BAT_HANGING;
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta {
    float angle;
    float threshhold_distance = [CCDirector is_iPad] ? BAT_AGGRESIVE_RADIUS : BAT_AGGRESIVE_RADIUS / IPAD_TO_IPHONE_HEIGHT_RATIO;
    switch (_state) {
        case BAT_HANGING:
            if (ccpDistance(self.position, _player.position) <= threshhold_distance) {
                _state = BAT_FLYING;
                [self startChasing];
            }
            break;
        case BAT_FLYING:
            angle = [Bat getAngle:self.position target:_player.position];
            float xVel = sinf(CC_DEGREES_TO_RADIANS(angle)) * BAT_CHASE_SPEED;
            float yVel = cosf(CC_DEGREES_TO_RADIANS(angle)) * BAT_CHASE_SPEED;
            if (![CCDirector is_iPad]) {
                xVel = xVel / IPAD_TO_IPHONE_HEIGHT_RATIO;
                yVel = yVel / IPAD_TO_IPHONE_HEIGHT_RATIO;
            }
            [self.physicsBody setVelocity:ccp(xVel, yVel)];
            break;
        case BAT_DYING:
            break;
        default:
            break;
    }
}

- (void) startChasing {
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:BAT_FLY_ANIMATION_NAME];
    CCActionAnimate *flyAnimation = [CCActionAnimate actionWithAnimation:animation];
    CCActionRepeatForever *fly = [CCActionRepeatForever actionWithAction:flyAnimation];
    [self runAction:fly];
}

- (void) killBat {
    if (_state != BAT_FLYING) {
        return;
    }
    [self stopAllActions];
    self.physicsBody.affectedByGravity = YES;
    _state = BAT_DYING;
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:BAT_DIE_ANIMATION_NAME];
    CCActionAnimate *dieAnimation = [CCActionAnimate actionWithAnimation:animation];
    [self runAction:dieAnimation];
}

+ (float)getAngle: (CGPoint)origin target:(CGPoint)target {
    float deltaX = target.x - origin.x;
    float deltaY = target.y - origin.y;
    float angle = CC_RADIANS_TO_DEGREES(atanf(deltaY/deltaX)) - 90;
    if (deltaY >= 0) {
        if (deltaX >= 0) {
            angle = 360 - angle;
        }
        else {
            angle = 180 - angle;
        }
    }
    else {
        if (deltaX >= 0) {
            angle = -1 * angle;
        }
        else {
            angle = 180 - angle;
        }
    }
    
    return angle;
}

@end
