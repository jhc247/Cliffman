//
//  Carousel.h
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "VerticalElement.h"
#import "HorizontalElement.h"

@interface Carousel : CCNodeColor {
    
}

+ (Carousel*) createCarousel: (CGPoint)position vertical:(BOOL)vertical width:(float)width height:(float)height numElements:(int)numElements elements:(NSArray*)elements worldNum:(int)worldNum;

- (BOOL) topArrow;
- (BOOL) bottomArrow;
- (int) getTotalHelmets;

@end
