//
//  Player.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Player.h"


@implementation Player {
    Spear* currentSpear;
    CCNodeGradient* _rope;
    
    CGPoint helper_throwTarget;
    int ticks;
    BOOL canThrow;
    NSLock* throwLock;
    
    BOOL initiated;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Player *)createPlayer: (CGPoint)position shoot:(BOOL)shoot{
    return [[self alloc] init:position shoot:shoot];
}

- (id)init: (CGPoint)position shoot:(BOOL)shoot{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_Idle003.png"]];
    //self = [super initWithImageNamed:@"obj_FallFlat001.png"];
    self.position  = position;
    self.anchorPoint = ccp(0.5, 0.35);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){ccp(self.contentSize.width*.3,self.contentSize.height*.02), CGSizeMake(self.contentSize.width*.3, self.contentSize.height*.58)} cornerRadius:0];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.sensor = NO;
    self.physicsBody.mass = PLAYER_MASS;
    self.physicsBody.affectedByGravity = YES;
    //self.physicsBody.allowsRotation = NO;
    
    CCColor *whiteColor = [CCColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f];
    CCColor *blueColor = [CCColor colorWithRed:0.75f green:0.60f blue:0.30f];
    CCColor *brown = [CCColor colorWithRed:0.54f green:0.39f blue:0.13f];
    float ropeThickness = [CCDirector is_iPad] ? ROPE_THICKNESS : ROPE_THICKNESS / IPAD_TO_IPHONE_HEIGHT_RATIO;
    
    _rope = [CCNodeGradient nodeWithColor:brown fadingTo:blueColor];
    [_rope setContentSize:CGSizeMake(ropeThickness, 0)];
    _rope.anchorPoint = ccp(0.5, 0.0);
    _rope.opacity = 0;
    
    throwLock = [[NSLock alloc] init];
    _jointLock = [[NSLock alloc] init];
    currentSpear = NULL;
    if (shoot) {
        [self throwSpear:ccp(self.position.x, self.position.y + 1)];
    }
    ticks = 0;
    /*
    CCActionDelay *delay = [CCActionDelay actionWithDuration:START_DELAY_TIME];
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_RUN_ANIMATION_NAME];
    CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
    CCActionRepeatForever *anim = [CCActionRepeatForever actionWithAction:throwAnimation];
    //CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, anim]];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, throwAnimation]];
    [self runAction:sequence];
    */
    initiated = NO;
    
    return self;
}

- (void)dealloc {
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta {
    float xVel;
    float xLimit;
    
    if (!initiated) {
        [[[[self parent] parent] parent] addChild:_rope z:Z_ORDER_ROPE];
        initiated = YES;
    }
    
    if (currentSpear != NULL && currentSpear.state != Detaching && self.state != Dying && self.state != Won) {
        float target_x = currentSpear.position.x - sinf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.45;
        float target_y = currentSpear.position.y - cosf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.45;
        float angle1 = self.flipX ? self.rotation + 45 : -self.rotation + 45;
        
        float deltaX = cosf(CC_DEGREES_TO_RADIANS(angle1)) * self.contentSize.width*.10 * sqrtf(2);
        float deltaY = sinf(CC_DEGREES_TO_RADIANS(angle1)) * self.contentSize.width*.10 * sqrtf(2);
        
        float orig_x = self.flipX ? self.position.x - deltaX : self.position.x + deltaX;
        float orig_y = self.position.y + deltaY;
        CGPoint orig = ccp(orig_x, orig_y);
        CGPoint target = ccp(target_x, target_y);
        
        float length = ccpDistance(orig,target);
        float angle = [Spear getAngle:orig target:target];
        float ropeThickness = [CCDirector is_iPad] ? ROPE_THICKNESS : ROPE_THICKNESS / IPAD_TO_IPHONE_HEIGHT_RATIO;
        [_rope setContentSize:CGSizeMake(ropeThickness, length)];
        _rope.position = orig;
        _rope.rotation = angle;
         _rope.opacity = 0.2f;
        if ([currentSpear state] == Attached) {
             _rope.opacity = 1.0f;
            float originalLength = [currentSpear originalLength];
            [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_JumpHigh000.png"]];
            if (length <= originalLength *1.05 && length >= originalLength*.95 && self.state != Rising) {
                float extraGravity = [CCDirector is_iPad] ? ROPE_ADDITIONAL_GRAVITY : ROPE_ADDITIONAL_GRAVITY / IPAD_TO_IPHONE_HEIGHT_RATIO;
                [self.physicsBody applyForce:ccp(0, extraGravity)];
            }
        }
       
    }
    else {
        [_rope setContentSize:CGSizeMake(0, 0)];
    }
    
    switch (_state) {
        case Starting:
            _state = Falling;
            break;
            xLimit = [CCDirector is_iPad] ? PLAYER_RUN_DISTANCE : PLAYER_RUN_DISTANCE / IPAD_TO_IPHONE_HEIGHT_RATIO;
            if (self.position.x >= xLimit) {
                _state = Falling;
                float xImp = sinf(CC_DEGREES_TO_RADIANS(PLAYER_JUMP_ANGLE)) * PLAYER_JUMP_IMPULSE;
                float yImp = cosf(CC_DEGREES_TO_RADIANS(PLAYER_JUMP_ANGLE)) * PLAYER_JUMP_IMPULSE;
                if (![CCDirector is_iPad]) {
                    xImp = xImp / IPAD_TO_IPHONE_HEIGHT_RATIO;
                    yImp = yImp / IPAD_TO_IPHONE_HEIGHT_RATIO;
                }
                [self.physicsBody applyImpulse:ccp(xImp, yImp)];
                [self stopAllActions];
            }
            else {
                xVel = [CCDirector is_iPad] ? PLAYER_RUN_SPEED : PLAYER_RUN_SPEED / IPAD_TO_IPHONE_HEIGHT_RATIO;
                self.physicsBody.velocity = ccp(xVel, self.physicsBody.velocity.y);
            }
            break;
        case Throwing:
            
            break;
        default:
            break;
    }
    
    // Hack to prevent player body from merging with walls, causing the game to freeze
    // No noticeable effect on game physics
    float anti_gravity = [CCDirector is_iPad] ? IPAD_TO_IPHONE_HEIGHT_RATIO : 1;
    //[self.physicsBody applyImpulse:ccp(0, anti_gravity)];
    
    // Set limits on rotation
    float rotation = self.rotation;
    self.physicsBody.angularVelocity *= 0.99;

    
    // Fixes the player's rotation (Didn't like it)
    /*if (currentSpear != NULL && currentSpear.state == Attached) {
        float angle = [Spear getAngle:self.position target:currentSpear.position];
        self.rotation = angle;
    }*/
    if (self.state == Rising && ticks > 2) {
        self.state = Hanging;
        
        
        // Create the physics joint
        float target_x = currentSpear.position.x - sinf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.45;
        float target_y = currentSpear.position.y - cosf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.45;
        float angle1 = self.flipX ? self.rotation + 45 : -self.rotation + 45;
        
        float deltaX = cosf(CC_DEGREES_TO_RADIANS(angle1)) * self.contentSize.width*.10 * sqrtf(2);
        float deltaY = sinf(CC_DEGREES_TO_RADIANS(angle1)) * self.contentSize.width*.10 * sqrtf(2);
        
        float orig_x = self.flipX ? self.position.x - deltaX : self.position.x + deltaX;
        float orig_y = self.position.y + deltaY;
        CGPoint orig = ccp(orig_x, orig_y);
        CGPoint target = ccp(target_x, target_y);
        
        float ropeLength = ccpDistance(orig, target);
        float ropeMax = [CCDirector is_iPad] ? ROPE_MINMAX_LENGTH : ROPE_MINMAX_LENGTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
        ropeLength = (ropeLength >= ropeMax) ? ropeLength : ropeMax;
        //ropeLength *= 0.9;
        [currentSpear attach:ropeLength];
        [_jointLock lock];
        for (CCPhysicsJoint* joint in [self.physicsBody joints]) {
            if (joint.valid) {
                [joint invalidate];
            }
        }
        float ropemin = [CCDirector is_iPad] ? ROPE_MIN_LENGTH : ROPE_MIN_LENGTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
        CCPhysicsNode* a = self.physicsNode;
        CCPhysicsNode* b = currentSpear.physicsNode;
        if (currentSpear.state == Attached) {
        CCPhysicsJoint* joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:self.physicsBody bodyB:currentSpear.physicsBody anchorA:ccp(self.contentSize.width*.5, self.contentSize.height*.55) anchorB:ccp(currentSpear.contentSize.width*.5,0) minDistance:ropemin maxDistance:ropeLength];
        }
        [_jointLock unlock];
        [currentSpear setOriginalLength:ropeLength];

        
    }

    if (currentSpear != NULL && currentSpear.position.y < 0) {
        [self removeSpear];
        [currentSpear detach];
    }
    
    ticks++;
}

- (void)startSequence {
    //CCActionMoveTo *run = [CCActionMoveTo actionWithDuration:PLAYER_RUN_SPEED position:ccp(400, self.position.y)];
    //[self runAction:run];
    /*
    CCActionCallFunc *throw_spear = [CCActionCallFunc actionWithTarget:self selector:NSSelectorFromString(@"throwSpear_helper")];
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_RUN_ANIMATION_NAME];
    CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
    CCActionSequence *actions = [CCActionSequence actionWithArray:@[throwAnimation, throw_spear]];
    [self runAction:actions];

    */
    
}

- (void) killPlayer {
    self.state = Dying;
    
    [self stopAllActions];
    [self removeSpear];
    self.rotation = 0;
    [self.physicsBody setAngularVelocity:0];
    [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_FallFlat001.png"]];
    
}

- (void) removeSpear {
    [_jointLock lock];
    [currentSpear detach];
    for (CCPhysicsJoint* joint in [self.physicsBody joints]) {
        if (joint.valid) {
            [joint invalidate];
        }
    }
    [_jointLock unlock];
}

- (void) levelWon {
    self.state = Won;
    
    [self stopAllActions];
    [self removeSpear];
    self.rotation = 0;
    [self.physicsBody setAngularVelocity:0];
    [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_Crouch000.png"]];
    
}

- (void)throwSpear: (CGPoint) target {
    if (![throwLock tryLock]) {
        return;
    }
    /*
    if (currentSpear == NULL || currentSpear.state == Flying || currentSpear.state == Detaching) { // Remove spear
        [self stopAllActions];
        [currentSpear detach];
        [self removeSpear];
        self.flipX = !(target.x >= self.position.x);
        self.rotation = 0;
        [self.physicsBody setAngularVelocity:0];
        
        
        _state = Throwing;
        helper_throwTarget = target;
        [self stopAllActions];
        
        CCActionCallFunc *throw_spear = [CCActionCallFunc actionWithTarget:self selector:NSSelectorFromString(@"throwSpear_helper")];
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_THROW_ANIMATION_NAME];
        
        CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
        CCActionSequence *actions = [CCActionSequence actionWithArray:@[throwAnimation, throw_spear]];
        [self runAction:throwAnimation];
        [self runAction:actions];
        
        
    }
    else {
        [self stopAllActions];
        [currentSpear detach];
        [self removeSpear];
        [throwLock unlock];
    }
    */
    ///*
     self.flipX = !(target.x >= self.position.x);
     self.rotation = 0;
     [self.physicsBody setAngularVelocity:0];
     [currentSpear detach];
    _rope.opacity = 0;
     [self removeSpear];
     
     _state = Throwing;
     helper_throwTarget = target;
     [self stopAllActions];
     
     CCActionCallFunc *throw_spear = [CCActionCallFunc actionWithTarget:self selector:NSSelectorFromString(@"throwSpear_helper")];
     CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_THROW_ANIMATION_NAME];
     
     CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
     CCActionSequence *actions = [CCActionSequence actionWithArray:@[throwAnimation, throw_spear]];
     [self runAction:throwAnimation];
     [self runAction:actions];
     
     //*/
    
}

- (void)throwSpear_helper {
    currentSpear = [Spear createSpear:self.position target:helper_throwTarget];
    if (currentSpear.state == Flying) {
        //currentSpear.physicsBody.velocity = ccp(currentSpear.physicsBody.velocity.x + self.physicsBody.velocity.x, currentSpear.physicsBody.velocity.y);
    }
    
    [[_parent parent] addChild:currentSpear z:Z_ORDER_SPEAR];
    [throwLock unlock];
}

- (BOOL)pull {
    if (!(currentSpear != NULL && currentSpear.state == Attached)) {
        return NO;
    }
    self.state = Rising;
    ticks = 0;
    CGPoint force = [currentSpear activatePulling: self.position];
    [self.physicsBody applyForce:force];
    return !(force.x == 0 && force.y == 0);
}

@end
