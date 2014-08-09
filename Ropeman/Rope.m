//
//  Rope.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Rope.h"


@implementation Rope {
    Player* _player;
    CGPoint _origin;
    float originalLength;
    CCPhysicsJoint* joint;
    
    RopeState state;
    BOOL pulling;
    BOOL justStarted;
    float prevX;
    float prevY;
    float prevX2;
    float prevY2;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Rope *)createRope: (Player*)player origin:(CGPoint*)origin {
    return [[self alloc] init:player origin:(CGPoint*)origin];
}

- (id)init: (Player*)player origin:(CGPoint*)origin {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CGPoint target = CGPointMake(player.position.x, player.position.y);
    float angle = [Rope getAngle:origin target:&target];
    
    // Store arguments in class
    _player = player;
    _origin = ccp(origin->x, origin->y);
    
    // Initialize sprite
    self = [super initWithImageNamed:@"Icon-Small.png" ];
    float xPos = player.position.x - PLAYER_ARM_LENGTH * sinf(CC_DEGREES_TO_RADIANS(angle));
    float yPos = player.position.y - PLAYER_ARM_LENGTH * cosf(CC_DEGREES_TO_RADIANS(angle));
    self.position = ccp(xPos, yPos);
    self.anchorPoint = ccp(0.5, 0.5);
    self.rotation = angle - 180;
    
    // Set up physics
    self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:ROPE_HOOK_RADIUS andCenter:ccp(self.contentSize.width/2, self.contentSize.height*.5)];
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody.collisionGroup = @"ropeGroup";
    self.physicsBody.collisionType = @"ropeCollision";
    self.physicsBody.sensor = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    float xVel = -PLAYER_SHOOT_SPEED * sinf(CC_DEGREES_TO_RADIANS(angle));
    float yVel = -PLAYER_SHOOT_SPEED * cosf(CC_DEGREES_TO_RADIANS(angle));
    [self.physicsBody setVelocity:ccp(xVel, yVel)];
    
    state = Flying;
    justStarted = YES;
    prevX = player.position.x;
    prevY = player.position.y;
    prevX2 = 0;
    prevY2 = 0;
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
    float angle = [Rope getAngle:&_origin target:&target];
    prevX2 = prevX;
    prevY2 = prevY;
    prevX = self.position.x;
    prevY = self.position.y;
    
    
    float xForce;
    float yForce;
    switch (state) {
        case Flying:
            xForce = -ROPE_ACCEL * sinf(CC_DEGREES_TO_RADIANS(angle));
            yForce = -ROPE_ACCEL * cosf(CC_DEGREES_TO_RADIANS(angle));
            [self.physicsBody applyForce:ccp(xForce, yForce)];
            break;
        case Attached:
            if (pulling) {
                xForce = -ROPE_PULL_FORCE * sinf(CC_DEGREES_TO_RADIANS(angle));
                yForce = -ROPE_PULL_FORCE * cosf(CC_DEGREES_TO_RADIANS(angle));
                //[_player.physicsBody applyForce:ccp(xForce, yForce)];
                
                [_player.physicsBody applyForce:ccp(0, ROPE_ADDITIONAL_GRAVITY)];
            }
            break;
        case Detaching:
            break;
        default:
            break;
    }
    justStarted = NO;
    
    /*
    float ropeLength = ccpDistance(_player.position, self.position);
    CGPoint target = CGPointMake(_player.position.x, _player.position.y);
    float angle = [Rope getAngle:&_origin target:&target];
    float adjustedAngle = truncf(angle - 180);
    */
    //float xTension = ropeTension * sinf(adjustedAngle);
    //float yTension = -ropeTension * cosf(adjustedAngle);
    
    
    /*// Apply forces to player
    if (angle >= 270 || angle <= 90 || ropeLength < originalLength - ROPE_BUFFER) {
        self.color = [CCColor yellowColor];
        _player.TensionX = 0;
        _player.TensionY = 0;
    }
    else if (ropeLength <= originalLength + ROPE_BUFFER) {
        self.color = [CCColor greenColor];
        _player.TensionX = xTension;
        _player.TensionY = yTension;
    }
    else {
        self.color = [CCColor redColor];
        _player.TensionX = 0;
        _player.TensionY = 0;
        float xmomentum = 1.5*_player.physicsBody.mass * _player.physicsBody.velocity.x;
        float ymomentum = 1.5*_player.physicsBody.mass * _player.physicsBody.velocity.y;
        
        
        [_player.physicsBody applyImpulse:ccp(-xmomentum, -ymomentum)];
    }
    
    else if (ropeLength <= originalLength + 5 || ropeLength >= originalLength - 5) {
        //[_player.physicsBody applyForce:ccp(0, -GRAVITY_Y)];
    }
    else {
        float yImpulse = -GRAVITY_Y;
        [_player.physicsBody applyImpulse:ccp(0,yImpulse)];
    }
    
    //[_player.physicsBody applyForce:ccp(0, -GRAVITY_Y*2)];
    //CCLOG(@"CLICKED");
    */
    
    // Update the rope
    //float scale = ropeLength / originalLength;
    //self.scaleY = scale;
    //self.rotation = angle;
    //self.physicsBody.
    //CGSize size = CGSizeMake(ROPE_THICKNESS, ropeLength);
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, size} cornerRadius:0]; // 1
    //self.physicsBody.collisionGroup = @"ropeGroup";
    //self.physicsBody.sensor = YES;
    //self.physicsBody.affectedByGravity = NO;
    
    
/*
    if (rising) {
        float xTension = PLAYER_RISING_FORCE * sinf(CC_DEGREES_TO_RADIANS(adjustedAngle));
        float yTension = PLAYER_RISING_FORCE * cosf(CC_DEGREES_TO_RADIANS(adjustedAngle));
        CCLOG(@"yTension: %f", yTension);
        [_player.physicsBody applyForce:ccp(xTension, yTension)];
    }
    if (!attached) {
        float xForce = -ROPE_ACCEL * sinf(CC_DEGREES_TO_RADIANS(angle));
        float yForce = -ROPE_ACCEL * cosf(CC_DEGREES_TO_RADIANS(angle));
        [self.physicsBody applyForce:ccp(xForce, yForce)];
    }
*/
    
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
        //CCLOG(@"ERROR");
    }
    
    
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    float ropeLength = ccpDistance(_player.position, self.position) + ROPE_INITIAL_SLACK;
    ropeLength = (ropeLength >= ROPE_MINMAX_LENGTH) ? ropeLength : ROPE_MINMAX_LENGTH;
    joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width/2, _player.contentSize.height/2) anchorB:ccp(self.contentSize.width/2,0) minDistance:ROPE_MIN_LENGTH maxDistance:ropeLength];
    pulling = YES;
}

- (void)detach {
    if (!(state == Attached || state == Flying)) {
        return;
    }
    state = Detaching;
    [joint invalidate];
    [_parent removeChild:self];
    [_player.physicsBody applyForce:ccp(0, -ROPE_ADDITIONAL_GRAVITY)];
    CCLOG(@"forces upon detaching: %f,%f",_player.physicsBody.force.x, _player.physicsBody.force.y);
    //[_player.physicsBody applyForce:ccp(0, 20000)];
}

/*- (void)stopPulling {
    if (!pulling) {
        NSAssert(false, @"Invalid state change: attempting to stop pulling");
    }
    CCLOG(@"Stopped pulling");
    pulling = NO;
    [joint invalidate];
    [_parent removeChild:self];
    //[self attach];
    
}*/

- (BOOL)isAttached {
    return (state == Attached);
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
