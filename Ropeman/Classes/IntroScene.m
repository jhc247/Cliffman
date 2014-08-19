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
    // 91-89-60 = dirt color
    // 48-102-70 = green color
    CCColor *startColor = [CCColor colorWithRed:76.0/255.0f green:180.0f/255.0f blue:224.0f/255.0f];
    CCColor *endColor = [CCColor colorWithRed:42.0f/255.0f green:117.0f/255.0f blue:166.0f/255.0f];
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"introscreen.png"];
    background.anchorPoint = ccp(0,0);
    [self addChild:background];
    
    CCColor *brown = [CCColor colorWithRed:0.54f green:0.39f blue:0.13f];
    
    // Play button
    CCButton *playButton = [CCButton buttonWithTitle:@"Play" fontName:@"Verdana-Bold" fontSize:40.0f];
    playButton.positionType = CCPositionTypeNormalized;
    [playButton setColor:brown];
    playButton.position = ccp(0.85f, 0.05f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playButton];
    
    // Mute button
    CCButton *mute = [CCButton buttonWithTitle:@"Mute [  ]" fontName:@"Verdana-Bold" fontSize:30.0f];
    mute.positionType = CCPositionTypeNormalized;
    mute.position = ccp(0.1f, 0.05f);
    [mute setColor:brown];
    [mute setTarget:self selector:@selector(onMuteButtonClicked:)];
    [self addChild:mute];
    
    // Credits button
    CCButton *credits = [CCButton buttonWithTitle:@"Credits" fontName:@"Verdana-Bold" fontSize:30.0f];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.5f, 0.05f);
    [credits setColor:brown];
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
    [[CCDirector sharedDirector] replaceScene:[WorldSelectScene sharedWorldSelectScene]];
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
