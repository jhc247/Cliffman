//
//  Spike.m
//  Ropeman
//
//  Created by Jcard on 8/13/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Spike.h"


@implementation Spike {
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Spike *)createSpike: (CGPoint)position orientation:(SpikeOrientation)orientation {
    return [[self alloc] init:position orientation:orientation];
}

- (id)init: (CGPoint)position orientation:(SpikeOrientation)orientation; {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    // Initialize sprite
    //self = [super initWithImageNamed:@"spikes.png"];
    
    self.position = position;
    self.rotation = 90 * orientation;
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(10,10)} cornerRadius:0.0f];
    self.physicsBody.collisionGroup = @"spikeGroup";
    self.physicsBody.collisionType = @"spikeCollision";
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    return self;
}

- (void)dealloc
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------


- (void)update:(CCTime)delta {
    
}

@end
