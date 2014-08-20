//
//  WorldSelectScene.h
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "Carousel.h"
#import "Constants.h"

@interface WorldSelectScene : CCScene

// -----------------------------------------------------------------------

+ (WorldSelectScene *)sharedWorldSelectScene;
+ (WorldSelectScene *)scene;

- (void)playScene: (NSString*)levelName;
- (void)resetScene;

// -----------------------------------------------------------------------

@end
