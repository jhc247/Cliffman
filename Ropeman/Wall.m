//
//  Wall.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Wall.h"

@implementation Wall {
    float _height;
    float _width;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Wall*)createWall: (float)x y:(float)y width:(float)width height:(float)height points:(NSString*) points mult:(float)mult{
    return [[self alloc] init:x y:y width:width height:height points:points mult:mult];
}

- (id)init: (float)x y:(float)y width:(float)width height:(float)height points:(NSString*) points mult:(float)mult {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    _height = height;
    _width = width;
    self.position = ccp(x,y);
    
    //self = [super initWithColor:[CCColor blackColor] width:width height:height];
    if (points == NULL) {
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(width,height)} cornerRadius:0.0f];
    }
    else {
        NSArray *pairs = [points componentsSeparatedByString:@" "];
        int count = pairs.count;
        CGPoint points[count];
        int i = 0;
        for (NSString* pair in pairs) {
            NSArray *xy = [pair componentsSeparatedByString:@","];
            int x = [[xy objectAtIndex:0] intValue] * mult;
            int y = -[[xy objectAtIndex:1] intValue] * mult;
            
            CGPoint point = ccp(x,y);
            points[i] = point;
            i++;
        }
        
        self.physicsBody = [CCPhysicsBody bodyWithPolygonFromPoints:points count:count cornerRadius:0];
    }
    
    self.physicsBody.collisionGroup = @"wallGroup";
    self.physicsBody.collisionType = @"wallCollision";
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.type = CCPhysicsBodyTypeStatic;
    

    return self;
}

-(void)dealloc
{
    
}

- (float)getWidth {
    return _width;
}

- (float)getHeight {
    return _height;
}

@end
