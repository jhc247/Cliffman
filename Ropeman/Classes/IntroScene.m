//
//  IntroScene.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright JCard 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

static IntroScene *_sharedIntroScene = nil;

+ (IntroScene *)sharedIntroScene
{
	if (!_sharedIntroScene) {
        _sharedIntroScene = [self scene];
	}
    
	return _sharedIntroScene;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
    NSAssert(_sharedIntroScene == nil, @"Attempted to allocate a second instance IntroScene of a singleton.");
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
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"S VIKING" fontName:@"Verdana-Bold" fontSize:36.0f];
    title.positionType = CCPositionTypeNormalized;
    title.position = ccp(0.5f, 0.9f); // Middle of screen
    [self addChild:title];
    
    // Play button
    CCButton *playButton = [CCButton buttonWithTitle:@"Play" fontName:@"Verdana-Bold" fontSize:40.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.35f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playButton];
    
    // Mute button
    CCButton *mute = [CCButton buttonWithTitle:@"Mute [  ]" fontName:@"Verdana-Bold" fontSize:30.0f];
    mute.positionType = CCPositionTypeNormalized;
    mute.position = ccp(0.9f, 0.05f);
    [mute setTarget:self selector:@selector(onMuteButtonClicked:)];
    [self addChild:mute];
    
    // Credits button
    CCButton *credits = [CCButton buttonWithTitle:@"Credits" fontName:@"Verdana-Bold" fontSize:30.0f];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.1f, 0.05f);
    [credits setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:credits];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[WorldSelectScene sharedWorldSelectScene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// Callback for the Mute button
- (void)onMuteButtonClicked:(id)sender
{
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    if ([audio muted]) {
        [audio setMuted:NO];
        CCButton *button = (CCButton*) sender;
        [button setTitle:@"Mute [ ]"];
    }
    else {
        [audio setMuted:YES];
        CCButton *button = (CCButton*) sender;
        [button setTitle:@"Mute [X]"];
    }
}

// Callback for the Credits button
- (void)onCreditButtonClicked:(id)sender
{
    // go to credits scene with transition
    //[[CCDirector sharedDirector] replaceScene:[CreditsScene scene]
                               //withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
