//
//  Player.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Player.h"


@implementation Player {

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
    
    self = [super initWithImageNamed:@"dude.png"];
    self.position  = position;
    //self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody = [CCPhysicsBody bodyWithPillFrom:ccp(self.contentSize.width/2,self.contentSize.height*.22) to:ccp(self.contentSize.width/2, self.contentSize.height*.5) cornerRadius:self.contentSize.height*.2];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.sensor = NO;
    self.physicsBody.mass = PLAYER_MASS;
    self.physicsBody.affectedByGravity = YES;
    
    return self;
}

- (void)dealloc {
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta {
    /*float height = [self textureRect].size.height;
    float width = [self textureRect].size.width;
    CGRect newSize = CGRectMake(50, 50, width + 1, height);
    [self setTextureRect:newSize];*/
    
    float xVel = self.physicsBody.velocity.x;
    float yVel = self.physicsBody.velocity.y;
    //[self.physicsBody setVelocity:ccp(xVel * (1-AIR_RESISTANCE), yVel)];
    
    //[self.physicsBody applyForce:ccp(resistance, 0)];
    
    // Hack to prevent player body from merging with walls, causing the game to freeze
    // No noticeable effect on game physics
    float anti_gravity = [CCDirector is_iPad] ? IPAD_TO_IPHONE_HEIGHT_RATIO : 1;
    [self.physicsBody applyImpulse:ccp(0, anti_gravity)];
    
}


@end
