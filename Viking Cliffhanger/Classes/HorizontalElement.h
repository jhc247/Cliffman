//
//  HorizontalElement.h
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "WorldSelectScene.h"

@interface HorizontalElement : CCNode {
    
}

+ (HorizontalElement*) createHorizontalElement: (CGPoint)position levelData:(NSDictionary*)levelData worldNum:(int)worldNum levelNum:(int)levelNum;

- (BOOL) enterLevel;
- (void) dim;
- (void) undim;

@end
