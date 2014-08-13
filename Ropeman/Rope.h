//
//  Rope.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Constants.h"

// Types of effects applied to the spheres
typedef NS_ENUM(NSInteger, RopeState)
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

@interface Rope : CCSprite {
    
}



+ (Rope *)createRope: (Player*)player target:(CGPoint)target;
- (id)init: (Player*)player target:(CGPoint)target;

- (void)attach: (float)x y:(float)y width:(float)width height:(float)height;
- (void)detach;
- (BOOL)activatePulling;

- (BOOL)isAttached;
//- (void)rising;
//- (void)doneRising;

@end
