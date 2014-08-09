//
//  Wall.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Wall : CCNode {
    
}

+ (Wall*)createWall: (float)x y:(float)y width:(float)width height:(float)height;
- (id)init: (float)x y:(float)y width:(float)width height:(float)height;

- (float)getWidth;
- (float)getHeight;
@end
