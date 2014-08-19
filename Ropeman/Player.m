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
    CCNodeColor* _rope;
    
    CGPoint helper_throwTarget;
    
    float ticks;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Player *)createPlayer: (CGPoint)position rope:(CCNodeColor *)rope {
    return [[self alloc] init:position rope:rope];
}

- (id)init: (CGPoint)position rope:(CCNodeColor *)rope {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_FallFlat001.png"]];
    //self = [super initWithImageNamed:@"obj_FallFlat001.png"];
    self.position  = position;
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){ccp(self.contentSize.width/2 - self.contentSize.height*.2,self.contentSize.height*.02), CGSizeMake(self.contentSize.height*.4, self.contentSize.height*.68)} cornerRadius:0];
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    //self.physicsBody = [CCPhysicsBody bodyWithPillFrom:ccp(self.contentSize.width/2,self.contentSize.height*.22) to:ccp(self.contentSize.width/2, self.contentSize.height*.5) cornerRadius:self.contentSize.height*.2];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.sensor = NO;
    self.physicsBody.mass = PLAYER_MASS;
    self.physicsBody.affectedByGravity = YES;
    //self.physicsBody.allowsRotation = NO;
    
    currentSpear = NULL;
    _rope = rope;
    
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_RUN_ANIMATION_NAME];
    CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
    CCActionRepeatForever *anim = [CCActionRepeatForever actionWithAction:throwAnimation];
    [self runAction:anim];
    
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
    
    if (currentSpear != NULL) {
        float target_x = currentSpear.position.x - sinf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.35;
        float target_y = currentSpear.position.y - cosf(CC_DEGREES_TO_RADIANS(currentSpear.rotation)) *currentSpear.contentSize.height*.35;
        
        CGPoint target = ccp(target_x, target_y);
        
        float length = ccpDistance(self.position, target);
        float angle = [Spear getAngle:self.position target:target];
        float ropeThickness = [CCDirector is_iPad] ? ROPE_THICKNESS : ROPE_THICKNESS / IPAD_TO_IPHONE_HEIGHT_RATIO;
        [_rope setContentSize:CGSizeMake(ropeThickness, length)];
        _rope.position = self.position;
        _rope.rotation = angle;
        _rope.opacity = ([currentSpear state] == Attached) ? 1.0f : 0.3f;
    }
    else {
        _rope.opacity = 0;
    }
    
    switch (_state) {
        case Starting:
            xLimit = [CCDirector is_iPad] ? PLAYER_RUN_DISTANCE : PLAYER_RUN_DISTANCE / IPAD_TO_IPHONE_HEIGHT_RATIO;
            if (self.position.x >= xLimit) {
                _state = Falling;
                float xImp = sinf(CC_DEGREES_TO_RADIANS(PLAYER_JUMP_ANGLE)) * PLAYER_JUMP_IMPULSE;
                float yImp = cosf(CC_DEGREES_TO_RADIANS(PLAYER_JUMP_ANGLE)) * PLAYER_JUMP_IMPULSE;
                if (![CCDirector is_iPad]) {
                    xImp = xImp / IPAD_TO_IPHONE_HEIGHT_RATIO;
                    yImp = yImp / IPAD_TO_IPHONE_HEIGHT_RATIO;
                }
                [self.physicsBody applyImpulse:ccp(0, yImp)];
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
    /*float height = [self textureRect].size.height;
     float width = [self textureRect].size.width;
     CGRect newSize = CGRectMake(50, 50, width + 1, height);
     [self setTextureRect:newSize];*/
    
    //float xVel = self.physicsBody.velocity.x;
    //float yVel = self.physicsBody.velocity.y;
    //[self.physicsBody setVelocity:ccp(xVel * (1-AIR_RESISTANCE), yVel)];
    
    //[self.physicsBody applyForce:ccp(resistance, 0)];
    
    // Hack to prevent player body from merging with walls, causing the game to freeze
    // No noticeable effect on game physics
    float anti_gravity = [CCDirector is_iPad] ? IPAD_TO_IPHONE_HEIGHT_RATIO : 1;
    [self.physicsBody applyImpulse:ccp(0, anti_gravity)];
    
    // Set limits on rotation
    float rotation = self.rotation;
    //CCLOG(@"Rotation: %f", rotation);
    if (rotation < -90) {
        //self.rotation = -90;
        //self.physicsBody.torque = 0;
    }
    else if (rotation > 90) {
        //self.rotation = 90;
        //self.physicsBody.torque = 0;
    }
    
    if (currentSpear != NULL && currentSpear.state == Attached) {
        //float angle = [Spear getAngle:self.position target:currentSpear.position];
        //self.rotation = angle;
    }
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

- (void)throwSpear: (CGPoint) target {
    if (_state == Starting) {
        return;
    }
    self.flipX = !(target.x >= self.position.x);
    self.rotation = 0;
    [self.physicsBody setAngularVelocity:0];
    _state = Throwing;
    helper_throwTarget = target;
    
    CCActionCallFunc *throw_spear = [CCActionCallFunc actionWithTarget:self selector:NSSelectorFromString(@"throwSpear_helper")];
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:PLAYER_THROW_ANIMATION_NAME];
    CCActionAnimate *throwAnimation = [CCActionAnimate actionWithAnimation:animation];
    CCActionSequence *actions = [CCActionSequence actionWithArray:@[throwAnimation, throw_spear]];
    [self runAction:actions];
}

- (void)throwSpear_helper {
    [currentSpear detach];
    currentSpear = [Spear createSpear:self.position target:helper_throwTarget];
    [(CCSpriteBatchNode*)_parent addChild:currentSpear z:Z_ORDER_SPEAR];
}

- (BOOL)pull {
    if (currentSpear == NULL || _state == Starting) {
        return NO;
    }
    CGPoint force = [currentSpear activatePulling: self.position];
    [self.physicsBody applyImpulse:force];
    return !(force.x == 0 && force.y == 0);
}

- (void)killPlayer {
    _state = Dying;
}

@end
