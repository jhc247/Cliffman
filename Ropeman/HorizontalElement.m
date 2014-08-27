//
//  HorizontalElement.m
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "HorizontalElement.h"


@implementation HorizontalElement {
    CCSprite* preview;
    
    int _worldNum;
    int _levelNum;
    int _maxHelmets;
    double _levelDepletion;
    
    NSString* levelFile;
    NSString* levelPreview;
}

+ (HorizontalElement*) createHorizontalElement: (CGPoint)position levelData:(NSDictionary *)levelData worldNum:(int)worldNum levelNum:(int)levelNum {
    return [[self alloc] init:position levelData:levelData worldNum:worldNum levelNum:levelNum];
}

- (id) init: (CGPoint)position levelData:(NSDictionary *)levelData worldNum:(int)worldNum levelNum:(int)levelNum {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCColor *whiteColor = [CCColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f];
    CCColor *blueColor = [CCColor colorWithRed:78.0f/255.0f green:177.0f/255.0f blue:186.0f/255.0f];
    
    _worldNum = worldNum;
    _levelNum = levelNum;
    
    NSString* levelName = [levelData objectForKey:@"levelName"];
    levelFile = [levelData objectForKey:@"levelFile"];
    levelPreview = [levelData objectForKey:@"levelPreview"];
    int levelScore = [[levelData objectForKey:@"levelScore"] intValue];
    _maxHelmets = [[levelData objectForKey:@"levelScoreMax"] intValue];
    _levelDepletion = [[levelData objectForKey:@"levelDepletion"] doubleValue];
    
    self.position = position;
    self.anchorPoint = ccp(0,0);
    float width = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_ELEMENT_WIDTH : CAROUSEL_HORIZONTAL_ELEMENT_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float height = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_HEIGHT : CAROUSEL_HORIZONTAL_HEIGHT / IPAD_TO_IPHONE_HEIGHT_RATIO;
    [self setContentSize:CGSizeMake(width,height)];
    
    // Add level title
    float font_size = [CCDirector is_iPad] ? FONT_SIZE_WORLD_NAME : FONT_SIZE_WORLD_NAME / IPAD_TO_IPHONE_HEIGHT_RATIO;
    font_size = font_size * (3.0f/6.0f);
    float font_width = width;
    float font_height = height * (1.0f/6.0f);
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:levelName fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(font_width, font_height)];
    [title setHorizontalAlignment:CCTextAlignmentCenter];
    [title setVerticalAlignment:CCVerticalTextAlignmentCenter];
    title.adjustsFontSizeToFit = YES;
    title.positionType = CCPositionTypeNormalized;
    title.color = whiteColor;
    title.position = ccp(0.5f, 1.02); // Middle of screen
    title.anchorPoint = ccp(0.5f, 1);
    [self addChild:title];
    
    // Add level preview image
    //NSString* thumbNailString = [NSString stringWithFormat:@"%@_thumbnail.png", levelName];
    NSString* thumbNailString = levelPreview;
    preview = [CCSprite spriteWithImageNamed:thumbNailString];
    preview.positionType = CCPositionTypeNormalized;
    preview.position = ccp(0.5,0.5);
    preview.anchorPoint = ccp(0.5,0.5);
    [self addChild:preview];
    
    // Add helmet icon
    CCSprite *helmet = [CCSprite spriteWithImageNamed:@"helmet_preview_level.png"];
    helmet.positionType = CCPositionTypeNormalized;
    helmet.anchorPoint = ccp(0.5f, 1);
    helmet.position = ccp(0.2f, 0.10f);
    [self addChild:helmet];
    
    // Add level count
    NSString *countString = [NSString stringWithFormat:@"%d / %d",levelScore, _maxHelmets];
    CCLabelTTF *count = [CCLabelTTF labelWithString:countString fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(font_width*.6, font_height)];
    [count setHorizontalAlignment:CCTextAlignmentCenter];
    [count setVerticalAlignment:CCVerticalTextAlignmentCenter];
    count.adjustsFontSizeToFit = YES;
    count.positionType = CCPositionTypeNormalized;
    count.color = (levelScore >= _maxHelmets) ? blueColor : whiteColor;
    count.position = ccp(0.7f, 0.13f); // Middle of screen
    count.anchorPoint = ccp(0.5f, 1);
    [self addChild:count];
    
    
    return self;
}

- (void) dim {
    preview.opacity = 0.5;
}

- (void) undim {
    preview.opacity = 1.0;
}

- (BOOL) enterLevel {
    if ([levelPreview  isEqual: @"levelpreview.png"]) {
        //return NO;
    }
    [[WorldSelectScene sharedWorldSelectScene] playScene:levelFile worldNum:_worldNum levelNum:_levelNum maxHelmets:_maxHelmets depletionRate:_levelDepletion];
    return YES;
}

@end
