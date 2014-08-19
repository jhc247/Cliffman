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

@interface WorldSelectScene : CCScene

// -----------------------------------------------------------------------

+ (WorldSelectScene *)sharedWorldSelectScene;
+ (WorldSelectScene *)scene;

- (void)resetScene;

// -----------------------------------------------------------------------

@end
