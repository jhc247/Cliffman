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
#import "VerticalElement.h"
#import "HorizontalElement.h"

@interface WorldSelectScene : CCScene

@property NSString* currentLevelFile;
@property int worldNum;
@property int levelNum;
@property int maxHelmets;
@property int totalHelmets;

// -----------------------------------------------------------------------

+ (WorldSelectScene *)sharedWorldSelectScene;
+ (WorldSelectScene *)scene;

- (void)playScene: (NSString*)levelName worldNum:(int)worldNum levelNum:(int)levelNum maxHelmets:(int)maxHelmets;
- (void)resetScene;

- (void) setNewLevelScore: (int)score;
- (int) getMaxHelmets;
- (BOOL) hasUpdated;
- (int) getTotalHelmets;

// -----------------------------------------------------------------------

@end
