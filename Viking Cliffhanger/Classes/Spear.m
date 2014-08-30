//
//  Rope.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Spear.h"


@implementation Spear {
    //float originalLength;
    float originalAngle;
    
    CGPoint _target;
    
    
    float prevX;
    float prevY;
    float prevX2;
    float prevY2;
    
    float ticks;
    
    NSLock* attachLock;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Spear *)createSpear: (CGPoint)playerPosition target:(CGPoint)target {
    return [[self alloc] init:playerPosition target:target];
}

- (id)init: (CGPoint)playerPosition target:(CGPoint)target {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    _target = target;
    float angle = [Spear getAngle:playerPosition target:_target];
    
    // Initialize sprite
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_PropSpear000.png"]];
    float arm_length = [CCDirector is_iPad] ? PLAYER_ARM_LENGTH : PLAYER_ARM_LENGTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float xPos = playerPosition.x + (arm_length * sinf(CC_DEGREES_TO_RADIANS(angle)));
    float yPos = playerPosition.y + (arm_length * cosf(CC_DEGREES_TO_RADIANS(angle)));
    self.position = ccp(xPos, yPos);
    self.anchorPoint = ccp(0.5, 0.17);
    self.rotation = angle;
    originalAngle = angle;
    
    // Set up physics
    float radius = [CCDirector is_iPad] ? ROPE_HOOK_RADIUS : ROPE_HOOK_RADIUS / IPAD_TO_IPHONE_HEIGHT_RATIO;
    self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:radius andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    self.physicsBody.collisionGroup = @"spearGroup";
    self.physicsBody.collisionType = @"spearCollision";
    self.physicsBody.sensor = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    float shoot_speed = [CCDirector is_iPad] ? PLAYER_SHOOT_SPEED : PLAYER_SHOOT_SPEED / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float xVel = shoot_speed * sinf(CC_DEGREES_TO_RADIANS(angle));
    float yVel = shoot_speed * cosf(CC_DEGREES_TO_RADIANS(angle));
    [self.physicsBody setVelocity:ccp(xVel, yVel)];
    
    
    attachLock = [[NSLock alloc] init];
    _state = Flying;
    _pullState = NotPulling;
    prevX = playerPosition.x;
    prevY = playerPosition.y;
    prevX2 = 0;
    prevY2 = 0;
    
    ticks = 0;
    
    return self;
}

- (void)dealloc
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta {
    prevX2 = prevX;
    prevY2 = prevY;
    prevX = self.position.x;
    prevY = self.position.y;
    
    float xForce;
    float yForce;
    float acceleration_rope;
    /*
    CGPoint origin = playerPosition;
    CGPoint target = self.position;
    float angle = [Spear getAngle:origin target:target];
    */
    switch (_state) {
        case Flying:
            ticks++;
            if (ticks > SPEAR_MAX_LIFE) {
                [self detach];
                break;
            }
            acceleration_rope = [CCDirector is_iPad] ? ROPE_ACCEL : ROPE_ACCEL / IPAD_TO_IPHONE_HEIGHT_RATIO;
            xForce = acceleration_rope * sinf(CC_DEGREES_TO_RADIANS(originalAngle));
            yForce = acceleration_rope * cosf(CC_DEGREES_TO_RADIANS(originalAngle));
            [self.physicsBody applyForce:ccp(xForce, yForce)];
            break;
        case Attached:
            //_player.rotation = angle;
            if (_pullState == Pulling) {
                
            }
            else {
                //float ropeLength =
                /*if (ropeLength <= originalLength *1.01 && ropeLength >= originalLength*.99) {
                    [_player.physicsBody applyForce:ccp(0, ROPE_ADDITIONAL_GRAVITY)];
                }*/
            }
            break;
        case Detaching:
            break;
        default:
            break;
    }

}

- (BOOL)attach: (float)length {
    [attachLock lock];
    if (!(_state == Flying)) {
        //NSAssert(false, @"Invalid state change: attempting to attach");
        [attachLock unlock];
        return NO;
    }
    _state = Attached;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    _originalLength = length;
    [attachLock unlock];
    return YES;
    
}

- (void)detach {
    if (!(_state == Attached || _state == Flying)) {
        return;
    }
    _state = Detaching;
    [self stopAllActions];
    [_parent removeChild:self];
    //[_player.physicsBody applyForce:ccp(0, -ROPE_ADDITIONAL_GRAVITY)];
    //CCLOG(@"forces upon detaching: %f,%f",_player.physicsBody.force.x, _player.physicsBody.force.y);
}

- (BOOL)isAttached {
    return (_state == Attached);
}

- (CGPoint)activatePulling: (CGPoint) playerPosition {
    if (_state != Attached || _pullState == Pulled) {
        return ccp(0,0);
    }
    _pullState = Pulling;
    
    float acceleration_pull = [CCDirector is_iPad] ? ROPE_PULL_FORCE : ROPE_PULL_FORCE / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float angle = [Spear getAngle:playerPosition target:self.position];
    float xForce = acceleration_pull * sinf(CC_DEGREES_TO_RADIANS(angle));
    float yForce = acceleration_pull * cosf(CC_DEGREES_TO_RADIANS(angle));
    
    return ccp(xForce, yForce);
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
