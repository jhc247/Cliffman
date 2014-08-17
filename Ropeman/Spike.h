//
//  Spike.h
//  Ropeman
//
//  Created by Jcard on 8/13/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSInteger, SpikeOrientation)
{
    FacingUp,
    FacingRight,
    FacingDown,
    FacingLeft
};

@interface Spike : CCSprite {
    
}

+ (Spike *)createSpike: (CGPoint)position orientation:(SpikeOrientation)orientation;

@end
