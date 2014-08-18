//
//  Bat.h
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"

typedef NS_ENUM(NSInteger, BatState)
{
    BAT_HANGING,
    BAT_FLYING,
    BAT_DYING
    
};

@interface Bat : CCSprite {
    
}

+ (Bat *)createBat: (CGPoint)position orientation:(Orientation)orientation player:(CCNode*)player;

- (void)killBat;

+ (float)getAngle: (CGPoint)origin target:(CGPoint)target;
@end
