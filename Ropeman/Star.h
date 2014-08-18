//
//  Star.h
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Star : CCSprite {
    
}

+ (Star *)createStar: (CGPoint)position;

- (BOOL)collect;

@end
