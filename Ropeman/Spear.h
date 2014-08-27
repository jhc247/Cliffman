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
@property float originalLength;


+ (Spear *)createSpear: (CGPoint)playerPosition target:(CGPoint)target;

- (BOOL)attach: (float)length;
- (void)detach;
- (CGPoint)activatePulling: (CGPoint)playerPosition;

- (BOOL)isAttached;


+ (float)getAngle: (CGPoint)origin target:(CGPoint)target;

@end
