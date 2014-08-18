//
//  Star.m
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Star.h"


@implementation Star {
    BOOL collected;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Star *)createStar:(CGPoint)position {
    return [[self alloc] init:position];
}

- (id)init: (CGPoint)position {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
 
    // Initialize sprite
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star.png"]];
    self.position = position;
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(self.contentSize.width,self.contentSize.height)} cornerRadius:0.0f];
    self.physicsBody.collisionGroup = @"starGroup";
    self.physicsBody.collisionType = @"starCollision";
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    collected = NO;
    
    return self;
}

- (BOOL)canCollect {
    return collected;
}

- (BOOL)collect {
    if (collected) {
        return NO;
    }
    collected = YES;
    [_parent removeChild:self];
}

@end
