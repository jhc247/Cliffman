//
//  VerticalElement.h
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "cocos2d-ui.h"
#import "Carousel.h"
#import "WorldSelectScene.h"

@interface VerticalElement : CCNode {
    
}

+ (VerticalElement*) createVerticalElement: (CGPoint)position worldNumber:(int)worldNumber;

@end
