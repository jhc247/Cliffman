//
//  TouchLayer.h
//  Ropeman
//
//  Created by Jcard on 8/8/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "WorldSelectScene.h"

@interface TouchLayer : CCNodeColor {
    
}

// -----------------------------------------------------------------------

+ (TouchLayer*) createTouchLayer:(CGSize)size;

- (void) createMenu: (BOOL)died collected:(int)collected;

@end

