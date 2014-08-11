//
//  Rope.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Rope.h"


@implementation Rope {
    Player *_player;
    float originalLength;
    float originalAngle;
    CCPhysicsJoint* joint;
    
    RopeState state;
    PullingState pullState;
    
    float prevX;
    float prevY;
    float prevX2;
    float prevY2;
    
    float ticks;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Rope *)createRope: (Player*)player target:(CGPoint*)target {
    return [[self alloc] init:player target:(CGPoint*)target];
}

- (id)init: (Player*)player target:(CGPoint*)target {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CGPoint playerPosition = CGPointMake(player.position.x, player.position.y);
    float angle = [Rope getAngle:&playerPosition target:target];
    
    // Store arguments in class
    _player = player;
    //_origin = ccp(origin->x, origin->y);
    
    // Initialize sprite
    self = [super initWithImageNamed:@"dude.png" ];
    float arm_length = [CCDirector is_iPad] ? PLAYER_ARM_LENGTH : PLAYER_ARM_LENGTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float xPos = player.position.x + (arm_length * sinf(CC_DEGREES_TO_RADIANS(angle)));
    float yPos = player.position.y + (arm_length * cosf(CC_DEGREES_TO_RADIANS(angle)));
    self.position = ccp(xPos, yPos);
    self.anchorPoint = ccp(0.5, 0.5);
    self.rotation = angle;
    originalAngle = angle;
    
    // Set up physics
    self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:ROPE_HOOK_RADIUS andCenter:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody.collisionGroup = @"ropeGroup";
    self.physicsBody.collisionType = @"ropeCollision";
    self.physicsBody.sensor = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    float shoot_speed = [CCDirector is_iPad] ? PLAYER_SHOOT_SPEED : PLAYER_SHOOT_SPEED / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float xVel = shoot_speed * sinf(CC_DEGREES_TO_RADIANS(angle));
    float yVel = shoot_speed * cosf(CC_DEGREES_TO_RADIANS(angle));
    [self.physicsBody setVelocity:ccp(xVel, yVel)];
    CCLOG(@"Initial Speed: %@", NSStringFromCGPoint(self.physicsBody.velocity));
    state = Flying;
    pullState = NotPulling;
    prevX = player.position.x;
    prevY = player.position.y;
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
    
    
    float ropeLength = ccpDistance(_player.position, self.position);
    CGPoint target = CGPointMake(_player.position.x, _player.position.y);
    //float angle = [Rope getAngle:&CGPointZero target:&target];
    prevX2 = prevX;
    prevY2 = prevY;
    prevX = self.position.x;
    prevY = self.position.y;
    
    float xForce;
    float yForce;
    
    switch (state) {
        case Flying:
            ticks = ticks + 1;
            float acceleration_rope = [CCDirector is_iPad] ? ROPE_ACCEL : ROPE_ACCEL / IPAD_TO_IPHONE_HEIGHT_RATIO;
            xForce = acceleration_rope * sinf(CC_DEGREES_TO_RADIANS(originalAngle));
            yForce = acceleration_rope * cosf(CC_DEGREES_TO_RADIANS(originalAngle));
            [self.physicsBody applyForce:ccp(xForce, yForce)];
            break;
        case Attached:
            if (pullState == Pulling) {
                float acceleration_pull = [CCDirector is_iPad] ? ROPE_PULL_FORCE : ROPE_PULL_FORCE / IPAD_TO_IPHONE_HEIGHT_RATIO;
                CGPoint origin = _player.position;
                CGPoint target = self.position;
                float angle = [Rope getAngle:&origin target:&target];
                xForce = acceleration_pull * sinf(CC_DEGREES_TO_RADIANS(angle));
                yForce = acceleration_pull * cosf(CC_DEGREES_TO_RADIANS(angle));
                [_player.physicsBody applyImpulse:ccp(xForce, yForce)];
                pullState = NotPulling;
                
                if (_player.position.y > self.position.y) {
                    //[_player.physicsBody applyForce:ccp(0, -GRAVITY_Y)];
                }
                //[_player.physicsBody applyForce:ccp(xForce, yForce)];
                //[_player.physicsBody applyForce:ccp(0, -GRAVITY_Y)];
                //CCLOG(@"Applying yforce: %f", yForce);
                 
            }
            else {
                if (ropeLength <= originalLength + 5 && ropeLength >= originalLength - 5) {
                    //[_player.physicsBody applyForce:ccp(0, ROPE_ADDITIONAL_GRAVITY)];
                }
            }
            break;
        case Detaching:
            break;
        default:
            break;
    }

}

/*- (void)rising {
    rising = YES;
    CCLOG(@"Rising");
}

- (void)doneRising {
    rising = NO;
    
    float maxLength = ccpDistance(_player.position, self.position);
    maxLength = maxLength < ROPE_MIN_LENGTH ? ROPE_MIN_LENGTH : maxLength;
    if (attached) {
        [joint invalidate];
        joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width/2, _player.contentSize.height/2) anchorB:ccp(0.5, 0.5) minDistance:0 maxDistance:maxLength];
    }
    
    CCLOG(@"Done Rising");
}*/

- (void)attach: (float)x y:(float)y width:(float)width height:(float)height {
    if (!(state == Flying || state == Attached)) {
        NSAssert(false, @"Invalid state change: attempting to attach");
    }
    state = Attached;
    CCLOG(@"Ticks: %f", ticks);
    float leftX = x;
    float rightX = x + width;
    float topY = y + height;
    float bottomY = y;
    //CCLOG(@"l,r,t,b: %f,%f,%f,%f", leftX, rightX, topY, bottomY);
    //CCLOG(@"prev, curr: (%f,%f), %@", prevX, prevY, NSStringFromCGPoint(self.position));
    float buffer = ROPE_HOOK_RADIUS;
    
    if (prevX + buffer <= leftX && self.position.x + buffer >= leftX) {
        //CCLOG(@"Collided with the left side of a wall");
        self.rotation = 90;
        self.position = ccp(leftX - self.contentSize.width/2,self.position.y);
        //perpendicularPosition = ccp(previousPosition.x, aquila.position.y);
        //modifiedTargetPosition = ccp(previousPosition.x, targetPosition.y);
    }
    // Collision on the right side of the wall
    else if (prevX - buffer >= rightX && self.position.x - buffer <= rightX) {
        //CCLOG(@"Collided with the right side of a wall");
        self.rotation = 270;
        self.position = ccp(rightX + self.contentSize.width/2,self.position.y);
        //perpendicularPosition = ccp(previousPosition.x, aquila.position.y);
        //modifiedTargetPosition = ccp(previousPosition.x, targetPosition.y);
    }
    // Collision on the top side of the wall
    else if (prevY - buffer >= topY && self.position.y - buffer <= topY) {
        //CCLOG(@"Collided with the top side of a wall");
        self.rotation = 180;
        self.position = ccp(self.position.x,topY + self.contentSize.height/2);
        //perpendicularPosition = ccp(aquila.position.x, previousPosition.y);
        //modifiedTargetPosition = ccp(targetPosition.x, previousPosition.y);
    }
    // Collision on the bottom side of the wall
    else if (prevY + buffer <= bottomY && self.position.y + buffer >= bottomY) {
        //CCLOG(@"Collided with the bottom side of a wall");
        self.rotation = 0;
        self.position = ccp(self.position.x,bottomY - self.contentSize.height/2);
        //perpendicularPosition = ccp(aquila.position.x, previousPosition.y);
        //modifiedTargetPosition = ccp(targetPosition.x, previousPosition.y);
    }
    else {
        CCLOG(@"ERROR");
    }
    
    
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    float ropeLength = ccpDistance(_player.position, self.position) + ROPE_INITIAL_SLACK;
    ropeLength = (ropeLength >= ROPE_MINMAX_LENGTH) ? ropeLength : ROPE_MINMAX_LENGTH;
    originalLength = ropeLength;
    //joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width*.65, _player.contentSize.height*.51) anchorB:ccp(self.contentSize.width/2,0) minDistance:ROPE_MIN_LENGTH maxDistance:ropeLength];
    joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width*.5, _player.contentSize.height*.5) anchorB:ccp(self.contentSize.width/2,self.contentSize.height/2) minDistance:ROPE_MIN_LENGTH maxDistance:ropeLength];
}

- (void)detach {
    if (!(state == Attached || state == Flying)) {
        return;
    }
    state = Detaching;
    [joint invalidate];
    [_parent removeChild:self];
    //[_player.physicsBody applyForce:ccp(0, -ROPE_ADDITIONAL_GRAVITY)];
    CCLOG(@"forces upon detaching: %f,%f",_player.physicsBody.force.x, _player.physicsBody.force.y);
}

- (BOOL)isAttached {
    return (state == Attached);
}

- (BOOL)activatePulling {
    if (state != Attached || pullState == Pulled) {
        return NO;
    }
    pullState = Pulling;
    return YES;
}

+ (float)getAngle: (CGPoint*)origin target:(CGPoint*)target {
    float deltaX = target->x - origin->x;
    float deltaY = target->y - origin->y;
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
