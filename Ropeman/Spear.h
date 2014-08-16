//
//  Rope.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

// Types of effects applied to the spheres
typedef NS_ENUM(NSInteger, SpearState)
{
    Flying,
    Attached,
    Detaching
};

typedef NS_ENUM(NSInteger, PullingState)
{
    NotPulling,
    Pulling,
    Pulled
};

@interface Spear : CCSprite {
    
}

@property SpearState state;
@property PullingState pullState;

+ (Spear *)createSpear: (CGPoint)playerPosition target:(CGPoint)target;
- (id)init: (CGPoint)playerPosition target:(CGPoint)target;

- (void)attach: (float)x y:(float)y width:(float)width height:(float)height;
- (void)detach;
- (CGPoint)activatePulling: (CGPoint)playerPosition;

- (BOOL)isAttached;


+ (float)getAngle: (CGPoint)origin target:(CGPoint)target;

@end
