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

+ (Player *)createPlayer:(float)x initialY:(float)y {
    return [[self alloc] init:x initialY:y];
}

- (id)init: (float)x initialY:(float)y {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self = [super initWithImageNamed:@"Icon-72.png"];
    self.position  = ccp(x,y);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
    self.physicsBody.collisionGroup = @"playerGroup"; // 2
    self.physicsBody.sensor = YES;
    self.physicsBody.mass = PLAYER_MASS;
    self.physicsBody.affectedByGravity = NO;
    _TensionX= 0;
    _TensionY = 0;
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
    
    [self.physicsBody applyForce:ccp(_TensionX, GRAVITY_Y + _TensionY)];
    CCLOG(@"Velocity: %@",NSStringFromCGPoint(self.physicsBody.velocity));
    CCLOG(@"Forces: %f, %f",_TensionX, GRAVITY_Y + _TensionY);
    
}
@end
