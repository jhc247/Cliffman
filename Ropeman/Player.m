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
    
    CGPoint helper_throwTarget;
    
    float ticks;
}


// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Player *)createPlayer: (CGPoint)position {
    return [[self alloc] init:position];
}

- (id)init: (CGPoint)position {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obj_FallFlat001.png"]];
    //self = [super initWithImageNamed:@"obj_FallFlat001.png"];
    self.position  = position;
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody = [CCPhysicsBody bodyWithPillFrom:ccp(self.contentSize.width/2,self.contentSize.height*.22) to:ccp(self.contentSize.width/2, self.contentSize.height*.5) cornerRadius:self.contentSize.height*.2];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.sensor = NO;
    self.physicsBody.mass = PLAYER_MASS;
    self.physicsBody.affectedByGravity = YES;
    //self.physicsBody.allowsRotation = NO;
    
    currentSpear = NULL;
    
    
    return self;
}

- (void)dealloc {
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta {
    switch (_state) {
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

- (void)throwSpear: (CGPoint) target {
    
    self.flipX = !(target.x >= self.position.x);
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
    if (currentSpear == NULL) {
        return NO;
    }
    CGPoint force = [currentSpear activatePulling: self.position];
    [self.physicsBody applyImpulse:force];
    return !(force.x == 0 && force.y == 0);
}

@end
