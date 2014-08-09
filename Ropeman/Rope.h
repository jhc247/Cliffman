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

@interface Rope : CCSprite {
    
}



+ (Rope *)createRope: (Player*)player origin:(CGPoint*)origin;
- (id)init: (Player*)player origin:(CGPoint*)origin;

- (void)attach: (float)x y:(float)y width:(float)width height:(float)height;
- (void)detach;
- (void)stopPulling;
- (BOOL)isAttached;
//- (void)rising;
//- (void)doneRising;

@end
