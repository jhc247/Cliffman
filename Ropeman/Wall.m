//
//  Wall.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Wall.h"

@implementation Wall {
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Wall*)createWall: (float)x y:(float)y width:(float)width height:(float)height {
    return [[self alloc] init:x y:y width:width height:height];
}

- (id)init: (float)x y:(float)y width:(float)width height:(float)height {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.position = ccp(x,y);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(width,height)} cornerRadius:0.0f];
    self.physicsBody.collisionGroup = @"wallGroup";
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    return self;
}

-(void)dealloc
{
    
}

@end
