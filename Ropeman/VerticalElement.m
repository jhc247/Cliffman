//
//  VerticalElement.m
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "VerticalElement.h"


@implementation VerticalElement {
    
}


+ (VerticalElement*) createVerticalElement: (CGPoint)position worldNumber:(int)worldNumber {
    return [[self alloc] init:position worldNumber:worldNumber];
}

- (id) init: (CGPoint)position worldNumber:(int)worldNumber {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.position = position;
    self.anchorPoint = ccp(0,1);
    float width = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_WIDTH : CAROUSEL_VERTICAL_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float height = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_ELEMENT_HEIGHT : CAROUSEL_VERTICAL_ELEMENT_HEIGHT / IPAD_TO_IPHONE_HEIGHT_RATIO;
    [self setContentSize:CGSizeMake(width,height)];
    CCColor *backgroundColor = [CCColor colorWithRed:34.0f/255.0f green:41.0f/255.0f blue:48.0f/255.0f];

    CCColor *blueColor = [CCColor colorWithRed:78.0f/255.0f green:177.0f/255.0f blue:186.0f/255.0f];
    CCColor *whiteColor = [CCColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f];
    
    NSDictionary* world = [[[CCDirector sharedDirector] getLevelStructure] objectForKey:[NSString stringWithFormat:@"World %d", worldNumber]];
    NSString* worldName = [world objectForKey:@"worldName"];
    NSString* worldPreviewFile = [world objectForKey:@"worldPreviewFile"];
    NSArray* levels = [world objectForKey:@"levels"];
    
    // Add cover
    CCNodeColor *cover = [CCNodeColor nodeWithColor:backgroundColor width:width height:height];
    [self addChild:cover];
    
    // Add world title
    float font_size = [CCDirector is_iPad] ? FONT_SIZE_WORLD_NAME : FONT_SIZE_WORLD_NAME / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float font_width = width;
    float font_height = (height * 0.1f);
    font_height = [CCDirector is_iPad] ? font_height + 5 : font_height + (5.0f/IPAD_TO_IPHONE_HEIGHT_RATIO);
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:worldName fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(font_width, font_height)];
    [title setHorizontalAlignment:CCTextAlignmentCenter];
    [title setVerticalAlignment:CCVerticalTextAlignmentCenter];
    title.adjustsFontSizeToFit = YES;
    title.positionType = CCPositionTypeNormalized;
    title.color = blueColor;
    title.position = ccp(0.5f, 1.02); // Middle of screen
    title.anchorPoint = ccp(0.5f, 1);
    [self addChild:title];
    
    // Add world preview image
    CCSprite *preview = [CCSprite spriteWithImageNamed:worldPreviewFile];
    preview.positionType = CCPositionTypeNormalized;
    preview.position = ccp(0,0.9f);
    preview.anchorPoint = ccp(0,1);
    [self addChild:preview];
    
    // Add helmet icon
    CCSprite *helmet = [CCSprite spriteWithImageNamed:@"helmet_preview.png"];
    helmet.positionType = CCPositionTypeNormalized;
    helmet.anchorPoint = ccp(0.5f, 1);
    helmet.position = ccp(0.2f, 0.1f);
    [self addChild:helmet];
    
    // Add world count
    int currentNum = 3;
    int maxNum = 42;
    NSString *countString = [NSString stringWithFormat:@"%d / %d",currentNum, maxNum];
    CCLabelTTF *count = [CCLabelTTF labelWithString:countString fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(font_width*.6, font_height)];
    [count setHorizontalAlignment:CCTextAlignmentCenter];
    [count setVerticalAlignment:CCVerticalTextAlignmentCenter];
    count.adjustsFontSizeToFit = YES;
    count.positionType = CCPositionTypeNormalized;
    count.color = (currentNum >= maxNum) ? blueColor : whiteColor;
    count.position = ccp(0.7f, 0.1f); // Middle of screen
    count.anchorPoint = ccp(0.5f, 1);
    [self addChild:count];
    
    // Add level previews
    int numLevels = [levels count];
    float horizontalHeight = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_HEIGHT : CAROUSEL_HORIZONTAL_HEIGHT / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float horizontalWidth = (CAROUSEL_HORIZONTAL_ELEMENT_WIDTH + CAROUSEL_HORIZONTAL_ELEMENT_BUFFER) * numLevels + 2*CAROUSEL_HORIZONTAL_ELEMENT_BUFFER;
    horizontalWidth = [CCDirector is_iPad] ? horizontalWidth : horizontalWidth / IPAD_TO_IPHONE_HEIGHT_RATIO;
    
    float horizontal_offsetX = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_OFFSET_X : CAROUSEL_HORIZONTAL_OFFSET_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    
    
    //float vertical_offsetY = self.contentSize.height * CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT;
    CGPoint horizontal_position = ccp(position.x + width + horizontal_offsetX, height*.9);
    
    Carousel *horizontalCarousel = [Carousel createCarousel:horizontal_position vertical:NO width:horizontalWidth height:horizontalHeight numElements:numLevels elements:levels];
    [self addChild:horizontalCarousel z:-1];

    
    /*
    // Level 1 button
    CCButton *playButton = [CCButton buttonWithTitle:@"Level 1" fontName:@"Verdana-Bold" fontSize:18.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.25f, 0.35f);
    playButton.color = [CCColor grayColor];
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [playButton setName:@"w1-level2.tmx"];
    [self addChild:playButton];
    */
    return self;
}


@end
