//
//  Spike.h
//  Ropeman
//
//  Created by Jcard on 8/13/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface Spike : CCSprite {
    
}

+ (Spike *)createSpike: (CGPoint)position orientation:(Orientation)orientation;

@end
