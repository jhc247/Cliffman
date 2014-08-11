//
//  Player.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

// -----------------------------------------------------------------------
// Types of effects applied to the spheres
typedef NS_ENUM(NSInteger, PlayerState)
{
    Starting,
    Falling,
    Rising,
    Hanging,
    Dying
};

@interface Player : CCSprite {
    
}


+ (Player*)createPlayer: (float)x initialY:(float)y;
- (id)init: (float)x initialY:(float)y;

@end
