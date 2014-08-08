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

@interface Rope : CCNodeColor {
    
}

+ (Rope *)createRope: (Player*)player origin:(CGPoint*)origin;
- (id)init: (Player*)player origin:(CGPoint*)origin;

@end
