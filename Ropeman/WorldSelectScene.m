//
//  WorldSelectScene.m
//  Ropeman
//
//  Created by Jcard on 8/17/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "WorldSelectScene.h"

// -----------------------------------------------------------------------
#pragma mark - WorldSelectScene
// -----------------------------------------------------------------------

@implementation WorldSelectScene {
    
    Carousel* verticalCarousel;
    CCSprite* topArrow;
    CCSprite* bottomArrow;

    
    BOOL hasUpdated;
}

static WorldSelectScene *_sharedWorldSelectScene = nil;

+ (WorldSelectScene *)sharedWorldSelectScene
{
	if (!_sharedWorldSelectScene) {
        _sharedWorldSelectScene = [self scene];
	}
	return _sharedWorldSelectScene;
}

+ (void)returnToSelection {
    WorldSelectScene* scene = [WorldSelectScene sharedWorldSelectScene];
    if ([scene hasUpdated]) {
        NSString* file = [scene currentLevelFile];
        int w = [scene worldNum];
        int l = [scene levelNum];
        int m = [scene maxHelmets];
        double d = [scene levelDepletion];
        scene = [self scene];
        scene.currentLevelFile = file;
        scene.worldNum = w;
        scene.levelNum = l;
        scene.maxHelmets = m;
        scene.levelDepletion = d;
        _sharedWorldSelectScene = scene;
    }
    
    [[CCDirector sharedDirector] replaceScene:scene
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (WorldSelectScene *)scene
{
    //NSAssert(_sharedWorldSelectScene == nil, @"Attempted to allocate a second instance WorldSelectScene of a singleton.");
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = NO;
    
    // Create a colored background (Dark Grey)
    CCColor *startColor = [CCColor colorWithRed:138.0/255.0f green:100.0f/255.0f blue:34.0f/255.0f];
    CCColor *endColor = [CCColor colorWithRed:25.0f/255.0f green:6.0f/255.0f blue:11.0f/255.0f];
    CCColor *backgroundColor = [CCColor colorWithRed:34.0f/255.0f green:41.0f/255.0f blue:48.0f/255.0f];
    CCColor *whiteColor = [CCColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f];
    CCColor *blueColor = [CCColor colorWithRed:78.0f/255.0f green:177.0f/255.0f blue:186.0f/255.0f];
    
    
    CCNodeColor *background = [CCNodeColor nodeWithColor:backgroundColor];
    [self addChild:background];
    /*CCNodeGradient *background = [CCNodeGradient nodeWithColor:startColor fadingTo:endColor];
    [self addChild:background];*/
    
    //CCNodeGradient *topCover = [CCNodeGradient nodeWithColor:endColor fadingTo:startColor];
    CCNodeColor *topCover = [CCNodeColor nodeWithColor:backgroundColor width:self.contentSize.width height:self.contentSize.height * (1-CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT)];
    //[topCover setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height * (1-CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT))];
    topCover.positionType = CCPositionTypeNormalized;
    topCover.anchorPoint = ccp(0,0);
    topCover.position = ccp(0, CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT);
    [self addChild:topCover z:3];
    
    // Top border
    float thickness = [CCDirector is_iPad] ? LEVEL_SCREEN_BORDER_THICKNESS : LEVEL_SCREEN_BORDER_THICKNESS / IPAD_TO_IPHONE_HEIGHT_RATIO;
    CCNodeColor *topBorder = [CCNodeColor nodeWithColor:blueColor width:self.contentSize.width height:thickness];
    topBorder.anchorPoint = ccp(0, 0.5f);
    topBorder.positionType = CCPositionTypeNormalized;
    topBorder.position = ccp(0, CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT);
    topBorder.opacity = 0.6;
    [self addChild:topBorder z:3];
    
    // Middle border
    CCNodeColor *middleBorder = [CCNodeColor nodeWithColor:blueColor width:thickness height:self.contentSize.height * .8];
    middleBorder.anchorPoint = ccp (0.5, 0);
    float x = CAROUSEL_VERTICAL_OFFSET_X + CAROUSEL_VERTICAL_WIDTH + CAROUSEL_HORIZONTAL_OFFSET_X/2;
    x = [CCDirector is_iPad] ? x : x / IPAD_TO_IPHONE_HEIGHT_RATIO;
    middleBorder.position = ccp(x, self.contentSize.height*.05);
    middleBorder.opacity = 0.6;
    [self addChild:middleBorder z:3];
    
    // Level Selection title
    float font_size = [CCDirector is_iPad] ? FONT_SIZE_LEVEL_SELECTION : FONT_SIZE_LEVEL_SELECTION / IPAD_TO_IPHONE_HEIGHT_RATIO;
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Level Selection" fontName:@"UnZialish" fontSize:font_size];
    title.positionType = CCPositionTypeNormalized;
    title.color = whiteColor;
    title.position = ccp(0.5f, 0); // Middle of screen
    title.anchorPoint = ccp(0.5,0);
    [topCover addChild:title];
    
    // Return button
    CCButton *returnButton = [CCButton buttonWithTitle:@"XX" fontName:@"UnZialish" fontSize:font_size*2];
    returnButton.positionType = CCPositionTypeNormalized;
    returnButton.position = ccp(0, 0);
    returnButton.anchorPoint = ccp(0,0);
    [returnButton setTarget:self selector:@selector(onReturnClicked:)];
    [topCover addChild:returnButton z:-1];
    

    int numWorlds = [[[[CCDirector sharedDirector] getLevelStructure] objectForKey:@"numWorlds"] intValue];

    float verticalWidth = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_WIDTH : CAROUSEL_VERTICAL_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float verticalHeight = (CAROUSEL_VERTICAL_ELEMENT_HEIGHT + CAROUSEL_VERTICAL_ELEMENT_BUFFER) * numWorlds + 2*CAROUSEL_VERTICAL_ELEMENT_BUFFER;
    verticalHeight = [CCDirector is_iPad] ? verticalHeight : verticalHeight / IPAD_TO_IPHONE_HEIGHT_RATIO;
    
    float vertical_offsetX = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_OFFSET_X : CAROUSEL_VERTICAL_OFFSET_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float vertical_offsetY = self.contentSize.height * CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT;
    CGPoint position = ccp(vertical_offsetX,vertical_offsetY);
    
    verticalCarousel = [Carousel createCarousel:position vertical:YES width:verticalWidth height:verticalHeight numElements:numWorlds elements:NULL worldNum:0];
    [self addChild:verticalCarousel z:1];
    
    // Total Helmet Count
    _totalHelmets = [verticalCarousel getTotalHelmets];
    CCSprite *helmet = [CCSprite spriteWithImageNamed:@"helmet_preview.png"];
    helmet.positionType = CCPositionTypeNormalized;
    helmet.anchorPoint = ccp(1, 0);
    helmet.position = ccp(0.91f, 0.1f);
    [topCover addChild:helmet];
    NSString *countString = [NSString stringWithFormat:@"%d",_totalHelmets];
    CCLabelTTF *count = [CCLabelTTF labelWithString:countString fontName:@"UnZialish" fontSize:font_size *0.5 dimensions:CGSizeMake(self.contentSize.width *.07, self.contentSize.height*.04)];
    [count setHorizontalAlignment:CCTextAlignmentLeft];
    [count setVerticalAlignment:CCVerticalTextAlignmentCenter];
    count.adjustsFontSizeToFit = YES;
    count.positionType = CCPositionTypeNormalized;
    count.color = blueColor;
    count.position = ccp(0.92f, 0.1f); // Middle of screen
    count.anchorPoint = ccp(0, 0);
    [topCover addChild:count];
    

    
    // Left and middle covers
    CCNodeColor* leftCover = [CCNodeColor nodeWithColor:backgroundColor width:vertical_offsetX height:self.contentSize.height];
    [self addChild:leftCover z:2];
    
    float horizontal_offsetX = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_OFFSET_X : CAROUSEL_HORIZONTAL_OFFSET_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float middle_x = CAROUSEL_VERTICAL_OFFSET_X + CAROUSEL_VERTICAL_WIDTH;
    middle_x = [CCDirector is_iPad] ? middle_x : middle_x / IPAD_TO_IPHONE_HEIGHT_RATIO;
    CCNodeColor* middleCover = [CCNodeColor nodeWithColor:backgroundColor width:horizontal_offsetX height:self.contentSize.height];
    middleCover.position = ccp(middle_x, 0);
    [self addChild:middleCover z:2];

    topArrow = [CCSprite spriteWithImageNamed:@"arrows.png"];
    float xArrowPos = (vertical_offsetX - topArrow.contentSize.width) / 2.0f;
    float buffer = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_ELEMENT_BUFFER : CAROUSEL_VERTICAL_ELEMENT_BUFFER / IPAD_TO_IPHONE_HEIGHT_RATIO;
    topArrow.position = ccp(xArrowPos, vertical_offsetY - buffer);
    topArrow.anchorPoint = ccp(0,1);
    topArrow.opacity = 0.0f;
    [self addChild:topArrow z:2];
    
    bottomArrow = [CCSprite spriteWithImageNamed:@"arrows.png"];
    bottomArrow.flipY = YES;
    bottomArrow.position = ccp(xArrowPos, 2.5*buffer);
    bottomArrow.anchorPoint = ccp(0,1);
    [self addChild:bottomArrow z:2];
    
    CCSprite* back = [CCSprite spriteWithImageNamed:@"backarrow.png"];
    back.anchorPoint = ccp(0,0);
    back.position = ccp(0, self.contentSize.height * .91);
    
    [self addChild:back z:4];
    
    _currentLevelFile = @"";
    hasUpdated = NO;
    
    // done
	return self;
}

- (void)update:(CCTime)delta {
    topArrow.opacity = [verticalCarousel topArrow] ? 1.0f : 0.0f;
    bottomArrow.opacity = [verticalCarousel bottomArrow] ? 1.0f : 0.0f;
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onReturnClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene sharedIntroScene]];
}

- (void)playScene: (NSString*)levelName worldNum:(int)worldNum levelNum:(int)levelNum maxHelmets:(int)maxHelmets depletionRate:(double)levelDepletion
{
    _currentLevelFile = levelName;
    _worldNum = worldNum;
    _levelNum = levelNum;
    _levelDepletion = levelDepletion;
    _maxHelmets = maxHelmets;
    CCLOG(@"Current level: %@", _currentLevelFile);
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene:_currentLevelFile depletionRate:_levelDepletion]];
}

- (void)resetScene {
    if (![self.currentLevelFile isEqual: @""]) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene:_currentLevelFile depletionRate:_levelDepletion]];
    }
}

- (void) setNewLevelScore: (int)score {
    NSString* worldKey = [NSString stringWithFormat:@"World %d",_worldNum];
    NSMutableDictionary* world = [[[CCDirector sharedDirector] getLevelStructure] objectForKey:worldKey];
    NSMutableDictionary* levelData = [[world objectForKey:@"levels"] objectAtIndex:_levelNum];
    NSString* saveFilePath = [[CCDirector sharedDirector] getLevelStructurePath];
    int previousNum = [[levelData objectForKey:@"levelScore"] intValue];
    if (score > previousNum) {
        [levelData setValue:[NSNumber numberWithInt:score] forKey:@"levelScore"];
        [[[CCDirector sharedDirector] getLevelStructure] writeToFile:saveFilePath atomically:YES];
        hasUpdated = YES;
    }
    
}


- (BOOL) hasUpdated {
    return hasUpdated;
}

@end
