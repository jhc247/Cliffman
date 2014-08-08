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

@interface Player : CCSprite {
    
}

@property (nonatomic, readwrite) float TensionX;
@property (nonatomic, readwrite) float TensionY;

+ (Player*)createPlayer: (float)x initialY:(float)y;
- (id)init: (float)x initialY:(float)y;

@end
