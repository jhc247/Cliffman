//
//  TouchLayer.m
//  Ropeman
//
//  Created by Jcard on 8/8/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "TouchLayer.h"

/*
  This class represents a "transparent layer" is always at the exact dimensions and position of what players currently view on their device while in a level. This layer does not interact with any physics objects, but does receive touch events. This layer contains the "Menu" button and the "death" message.
  
*/

@implementation TouchLayer

// Creates and initializes a TouchLayer instance
+ (instancetype) createTouchLayer:(CGSize) size {
    return [[TouchLayer alloc] initTouchLayer:size];
}

// Initializes a TouchLayer instance
- (instancetype)initTouchLayer:(CGSize) size {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //self = [CCNodeColor nodeWithColor:[CCColor blueColor] width:size.width height:size.height];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    self.anchorPoint = ccp(0.5,0.5);
    self.position = ccp(size.width/2,size.height/2);
    [self setContentSize: size];
    
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.45f, 0.05f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // Create a pull button    
    CCButton *pullButton = [CCButton buttonWithTitle:@"Pull" fontName:@"Verdana-Bold" fontSize:26.0f];
    pullButton.positionType = CCPositionTypeNormalized;
    pullButton.position = ccp(0.1f, 0.05f); // Bottom Right of screen
    [pullButton setTarget:self selector:@selector(onPullClicked:)];
    [self addChild:pullButton];
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[WorldSelectScene sharedWorldSelectScene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onPullClicked:(id)sender
{
    HelloWorldScene *scene = (HelloWorldScene*)_parent;
    [scene pull];
}

/*
 Touch events are all handled by the parent: LevelScene
 */

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //CCLOG(@"Touched TouchLayer at %@", NSStringFromCGPoint([touch locationInNode:_parent]));
    [_parent touchBegan:touch withEvent:event];
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //CCLOG(@"Touched TouchLayer");
    [_parent touchMoved:touch withEvent:event];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //CCLOG(@"Touched TouchLayer");
    [_parent touchEnded:touch withEvent:event];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    //CCLOG(@"Touched TouchLayer");
    [_parent touchCancelled:touch withEvent:event];
}

@end
