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

@interface TouchLayer : CCNodeColor {
    
}

// -----------------------------------------------------------------------

+ (instancetype) createTouchLayer:(CGSize)size;
- (instancetype)initTouchLayer:(CGSize)size;

@end

