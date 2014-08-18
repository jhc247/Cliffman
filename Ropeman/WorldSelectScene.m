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

@implementation WorldSelectScene 

static WorldSelectScene *_sharedWorldSelectScene = nil;

+ (WorldSelectScene *)sharedWorldSelectScene
{
	if (!_sharedWorldSelectScene) {
        _sharedWorldSelectScene = [self scene];
	}
    
	return _sharedWorldSelectScene;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (WorldSelectScene *)scene
{
    NSAssert(_sharedWorldSelectScene == nil, @"Attempted to allocate a second instance WorldSelectScene of a singleton.");
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCColor *startColor = [CCColor colorWithRed:76.0/255.0f green:180.0f/255.0f blue:224.0f/255.0f];
    CCColor *endColor = [CCColor colorWithRed:42.0f/255.0f green:117.0f/255.0f blue:166.0f/255.0f];
    
    CCNodeGradient *background = [CCNodeGradient nodeWithColor:startColor fadingTo:endColor];
    [self addChild:background];
    
    CCNodeColor *opaqueBox = [CCNodeColor nodeWithColor:[CCColor blackColor] width:self.contentSize.width height:self.contentSize.height*.9];
    opaqueBox.position = ccp(0, self.contentSize.height*.05);
    opaqueBox.opacity = 0.8f;
    [self addChild:opaqueBox];
    
    // Hello world
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"WORLD SELECT" fontName:@"Chalkduster" fontSize:36.0f];
    title.positionType = CCPositionTypeNormalized;
    title.color = [CCColor redColor];
    title.position = ccp(0.5f, 0.9f); // Middle of screen
    [self addChild:title];
    
    // Return button
    CCButton *returnButton = [CCButton buttonWithTitle:@"<--" fontName:@"Verdana-Bold" fontSize:36.0f];
    returnButton.positionType = CCPositionTypeNormalized;
    returnButton.position = ccp(0.1f, 0.9f);
    [returnButton setTarget:self selector:@selector(onReturnClicked:)];
    [self addChild:returnButton];
    
    // Level 1 button
    CCButton *playButton = [CCButton buttonWithTitle:@"Level 1" fontName:@"Verdana-Bold" fontSize:18.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.25f, 0.35f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [playButton setName:@"w1-level1.tmx"];
    [self addChild:playButton];
    
    // Level 2 button
    CCButton *play2Button = [CCButton buttonWithTitle:@"Level 2" fontName:@"Verdana-Bold" fontSize:18.0f];
    play2Button.positionType = CCPositionTypeNormalized;
    play2Button.position = ccp(0.75f, 0.35f);
    [play2Button setTarget:self selector:@selector(onPlayClicked:)];
    [play2Button setName:@"w1-level2.tmx"];
    [self addChild:play2Button];

    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onReturnClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene sharedIntroScene]];
}

- (void)onPlayClicked:(id)sender
{
    CCButton *button = (CCButton*)sender;
    NSString *name = [button name];
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene:[button name]]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}


@end
