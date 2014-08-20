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
    
    NSString* levelFile;
    NSString* levelPreview;
}

+ (HorizontalElement*) createHorizontalElement: (CGPoint)position levelData:(NSDictionary *)levelData {
    return [[self alloc] init:position levelData:levelData];
}

- (id) init: (CGPoint)position levelData:(NSDictionary *)levelData {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCColor *whiteColor = [CCColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f];
    
    NSString* levelName = [levelData objectForKey:@"levelName"];
    levelFile = [levelData objectForKey:@"levelFile"];
    levelPreview = [levelData objectForKey:@"levelPreview"];
    int levelScore = [[levelData objectForKey:@"levelScore"] intValue];
    int levelScoreMax = [[levelData objectForKey:@"levelScoreMax"] intValue];
    
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
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:levelName fontName:@"Viking-Normal" fontSize:font_size dimensions:CGSizeMake(font_width, font_height)];
    [title setHorizontalAlignment:CCTextAlignmentCenter];
    [title setVerticalAlignment:CCVerticalTextAlignmentCenter];
    title.adjustsFontSizeToFit = YES;
    title.positionType = CCPositionTypeNormalized;
    title.color = whiteColor;
    title.position = ccp(0.5f, 1.05); // Middle of screen
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
    
    // Add level count
    /*
    CCLabelTTF *count = [CCLabelTTF labelWithString:@"3 / 42" fontName:@"Chalkduster" fontSize:font_size dimensions:CGSizeMake(font_width*.75, font_height)];
    [count setHorizontalAlignment:CCTextAlignmentCenter];
    [count setVerticalAlignment:CCVerticalTextAlignmentCenter];
    count.adjustsFontSizeToFit = YES;
    count.positionType = CCPositionTypeNormalized;
    count.color = [CCColor redColor];
    count.position = ccp((5.0f/8.0f), 0.1f); // Middle of screen
    count.anchorPoint = ccp(0.5f, 1);
    [self addChild:count];
    */
    
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
        return NO;
    }
    [[WorldSelectScene sharedWorldSelectScene] playScene:levelFile];
    return YES;
}

@end