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
    float ropeLength;
    BOOL rising;
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
    
    _player = player;
    _origin = ccp(origin->x, origin->y);
    
    ropeLength = ccpDistance(player.position, *origin);
    originalLength = ropeLength >= ROPE_MIN_LENGTH ? ropeLength : ROPE_MIN_LENGTH;
    self = [super initWithColor:[CCColor blackColor] width:ROPE_THICKNESS height:ROPE_THICKNESS];
    self.position = *origin;
    self.anchorPoint = ccp(0.5, 0);
    
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody.collisionGroup = @"ropeGroup";
    self.physicsBody.sensor = YES;
    //self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    CGPoint target = CGPointMake(player.position.x, player.position.y);
    float angle = [Rope getAngle:origin target:&target];
    self.rotation = angle;
    CCLOG(@"Clicked");

    
    return self;
}

- (void)dealloc
{
    [joint invalidate];
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------


- (void)update:(CCTime)delta {
    float ropeLength = ccpDistance(_player.position, self.position);
    float ropeTension = _player.physicsBody.mass * GRAVITY_Y;
    CGPoint target = CGPointMake(_player.position.x, _player.position.y);
    float angle = [Rope getAngle:&_origin target:&target];
    float adjustedAngle = truncf(angle - 180);
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
    self.physicsBody.collisionGroup = @"ropeGroup";
    self.physicsBody.sensor = YES;
    //self.physicsBody.affectedByGravity = NO;
    
    
    
    if (rising) {
        float xTension = PLAYER_RISING_FORCE * sinf(CC_DEGREES_TO_RADIANS(adjustedAngle));
        float yTension = PLAYER_RISING_FORCE * cosf(CC_DEGREES_TO_RADIANS(adjustedAngle));
        CCLOG(@"yTension: %f", yTension);
        [_player.physicsBody applyForce:ccp(xTension, yTension)];
    }
    
    
}

- (void)enableRope {
    joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width/2, _player.contentSize.height/2) anchorB:CGPointZero minDistance:0 maxDistance:ropeLength];
}

- (void)rising {
    rising = YES;
    CCLOG(@"Rising");
}

- (void)doneRising {
    rising = NO;
    [joint invalidate];
    float maxLength = ccpDistance(_player.position, self.position);
    maxLength = maxLength < ROPE_MIN_LENGTH ? ROPE_MIN_LENGTH : maxLength;
    joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:self.physicsBody anchorA:ccp(_player.contentSize.width/2, _player.contentSize.height/2) anchorB:CGPointZero minDistance:0 maxDistance:maxLength];
    CCLOG(@"Done Rising");
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
