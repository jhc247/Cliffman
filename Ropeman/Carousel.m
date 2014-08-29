//
//  Carousel.m
//  Ropeman
//
//  Created by Jcard on 8/19/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Carousel.h"


@implementation Carousel {
    BOOL _vertical;
    float _velocity;
    CGPoint lastTouch;
    CGPoint firstTouch;
    
    float _maxHeight;
    float _minHeight;
    float _maxWidth;
    float _minWidth;
    float _height;
    float _width;
    
    HorizontalElement* firstClicked;
    float maxDistance;
    
    BOOL topArrow;
    BOOL bottomArrow;
    
    int totalHelmets;
}

+ (Carousel*) createCarousel: (CGPoint)position vertical:(BOOL)vertical width:(float)width height:(float)height numElements:(int)numElements elements:(NSArray*)elements worldNum:(int)worldNum {
    return [[self alloc] init:position vertical:vertical width:width height:height numElements:numElements elements:elements worldNum:worldNum ];
}

- (id) init: (CGPoint)position vertical:(BOOL)vertical width:(float)width height:(float)height numElements:(int)numElements elements:(NSArray*)elements worldNum:(int)worldNum {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    CCColor *backgroundColor = [CCColor colorWithRed:34.0f/255.0f green:41.0f/255.0f blue:48.0f/255.0f];

    self = [super initWithColor:backgroundColor];
    
    [self setContentSize:CGSizeMake(width, height)];
    self.userInteractionEnabled = YES;
    self.position = position;
    self.anchorPoint = ccp(0, 1);
    
    _vertical = vertical;
    
    _maxHeight = [CCDirector is_iPad] ? 768 : 320;
    _maxHeight = _maxHeight * CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT;
    _minHeight = 0;
    _minWidth = position.x;
    _maxWidth = [CCDirector sharedDirector].viewSize.width;
    
    _height = height;
    _width = width;
    totalHelmets = 0;
    
    if (_vertical) {
        float offset = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_ELEMENT_HEIGHT + CAROUSEL_VERTICAL_ELEMENT_BUFFER : (CAROUSEL_VERTICAL_ELEMENT_HEIGHT + CAROUSEL_VERTICAL_ELEMENT_BUFFER) / IPAD_TO_IPHONE_HEIGHT_RATIO;
        float buffer = [CCDirector is_iPad] ? CAROUSEL_VERTICAL_ELEMENT_BUFFER : CAROUSEL_VERTICAL_ELEMENT_BUFFER / IPAD_TO_IPHONE_HEIGHT_RATIO;
        
        for (int i = 0; i < numElements; i++) {
            VerticalElement* element = [VerticalElement createVerticalElement:ccp(0, height - buffer - i*offset) worldNumber:i+1 totalHelmets:totalHelmets];
            [self addChild:element z:1];
            totalHelmets += [element getNumHelmets];
        }
    }
    else {
        self.userInteractionEnabled = YES;
        float offset = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_ELEMENT_WIDTH + CAROUSEL_HORIZONTAL_ELEMENT_BUFFER : (CAROUSEL_HORIZONTAL_ELEMENT_WIDTH + CAROUSEL_HORIZONTAL_ELEMENT_BUFFER) / IPAD_TO_IPHONE_HEIGHT_RATIO;
        for (int i = 0; i < numElements; i++) {
            HorizontalElement* element = [HorizontalElement createHorizontalElement:ccp(0 + i*offset,0) levelData:[elements objectAtIndex:i] worldNum:worldNum levelNum:i];
            [self addChild:element z:1];
        }
    }
    
    topArrow = NO;
    bottomArrow = NO;
    
    return self;
}

- (void)update:(CCTime)delta {
    
    float buffer = [CCDirector is_iPad] ? LEVEL_SCREEN_ARROW_BUFFER : LEVEL_SCREEN_ARROW_BUFFER / IPAD_TO_IPHONE_HEIGHT_RATIO;
    if (_vertical) {
        topArrow = (self.position.y > _maxHeight + buffer);
        bottomArrow = ((self.position.y - _height) < _minHeight - buffer);
        
        
        //newY = newY < _maxHeight ? _maxHeight : newY;
        //newY = newY - _height > _minHeight ? self.position.y : newY;
    }
    /*
    if (_vertical) {
        self.position = ccp(self.position.x, self.position.y + _velocity);
    }
    else {
        self.position = ccp(self.position.x + _velocity, self.position.y);
    }
    _velocity = _velocity * 1;
     */
    
    
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    lastTouch = [touch locationInNode:_parent];
    firstTouch = [touch locationInNode:_parent];
    if (firstClicked != NULL) {
        [firstClicked undim];
    }
    firstClicked = NULL;
    maxDistance = 0;
    if (_vertical) {
        
    }
    
    else {
        CGPoint parentTouch = [touch locationInNode:[[_parent parent] parent]];
        float xlimit = CAROUSEL_VERTICAL_OFFSET_X + CAROUSEL_VERTICAL_WIDTH;
        xlimit = [CCDirector is_iPad] ? xlimit : xlimit / IPAD_TO_IPHONE_HEIGHT_RATIO;
        if (parentTouch.x < xlimit) {
            [_parent touchBegan:touch withEvent:event];
        }
        else {
            for (HorizontalElement* el in [self children]) {
                //CCLOG(@"x: %f", self.position.x);
                float buffer = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_OFFSET_X : CAROUSEL_HORIZONTAL_OFFSET_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
                float xMin = el.position.x + self.position.x + buffer;
                float width = [CCDirector is_iPad] ? CAROUSEL_HORIZONTAL_ELEMENT_WIDTH : CAROUSEL_HORIZONTAL_ELEMENT_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
                float xMax = xMin + width;
                if (parentTouch.x >= xMin && parentTouch.x <= xMax) {
                    firstClicked = el;
                    [firstClicked dim];
                }
                
            }
        }
        
    }
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint currentLoc = [touch locationInNode:_parent];
    if (_vertical) {
        float delta = (currentLoc.y - lastTouch.y);
        float newY = self.position.y + delta;
        newY = newY < _maxHeight ? _maxHeight : newY;
        newY = newY - _height > _minHeight ? self.position.y : newY;
        self.position = ccp(self.position.x, newY);
        
        //float origDelta = abs(currentLoc.y - firstTouch.y);
        //maxDistance = origDelta > maxDistance ? origDelta : maxDistance;
    }
    else {
        float delta = (currentLoc.x - lastTouch.x);
        float newX = self.position.x + delta;
        newX = newX > _minWidth ? _minWidth : newX;
        newX = newX + _width < _maxWidth ? self.position.x : newX;
        self.position = ccp(newX, self.position.y);
        
        float origDelta = abs(currentLoc.x - firstTouch.x);
        maxDistance = origDelta > maxDistance ? origDelta : maxDistance;
        float limit = [CCDirector is_iPad] ? MAX_DELTA_LEVEL_SELECTION : MAX_DELTA_LEVEL_SELECTION / IPAD_TO_IPHONE_HEIGHT_RATIO;
        if (maxDistance > limit && firstClicked != NULL ) {
            [firstClicked undim];
        }
    }
    lastTouch = currentLoc;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLoc = [touch locationInNode:self];
    float delta;
    if (_vertical) {
        CCLOG(@"Ended vertical");
        //delta = (touchLoc.y - firstTouch.y);
    }
    else {
        CCLOG(@"Ended horizontal");
        float limit = [CCDirector is_iPad] ? MAX_DELTA_LEVEL_SELECTION : MAX_DELTA_LEVEL_SELECTION / IPAD_TO_IPHONE_HEIGHT_RATIO;
        if (maxDistance <= limit && firstClicked != NULL) {
            
            if (![firstClicked enterLevel]) {
                [firstClicked undim];
            }
        }
    }
    //_velocity = delta > CAROUSEL_MAX_VELOCITY ? CAROUSEL_MAX_VELOCITY : delta;
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    //CCLOG(@"Touched TouchLayer");
    //[_parent touchCancelled:touch withEvent:event];
}

- (BOOL) topArrow {
    return topArrow;
}

- (BOOL) bottomArrow {
    return bottomArrow;
}

- (int) getTotalHelmets {
    return totalHelmets;
}

@end
