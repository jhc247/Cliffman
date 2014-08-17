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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
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
    [playButton setName:@"level-1.tmx"];
    [self addChild:playButton];
    
    // Level 2 button
    CCButton *play2Button = [CCButton buttonWithTitle:@"Level 2" fontName:@"Verdana-Bold" fontSize:18.0f];
    play2Button.positionType = CCPositionTypeNormalized;
    play2Button.position = ccp(0.75f, 0.35f);
    [play2Button setTarget:self selector:@selector(onPlayClicked:)];
    [play2Button setName:@"level-2.tmx"];
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
    [[CCDirector sharedDirector] replaceScene:[IntroScene sharedIntroScene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
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
