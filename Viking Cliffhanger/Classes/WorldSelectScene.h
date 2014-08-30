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
@property double levelDepletion;
@property int maxHelmets;
@property int totalHelmets;

// -----------------------------------------------------------------------

+ (WorldSelectScene *)sharedWorldSelectScene;
+ (void)returnToSelection;
+ (WorldSelectScene *)scene;

- (void)playScene: (NSString*)levelName worldNum:(int)worldNum levelNum:(int)levelNum maxHelmets:(int)maxHelmets depletionRate:(double)levelDepletion;
- (void)resetScene;
- (void)nextScene;
- (BOOL) atLastLevel;

- (void) setNewLevelScore: (int)score;
- (int) getMaxHelmets;
- (BOOL) hasUpdated;

// -----------------------------------------------------------------------

@end
