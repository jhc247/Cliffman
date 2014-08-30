//
//  AppDelegate.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright JCard 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
#import "CCAnimation.h"
#import "CCAnimationCache.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
    
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(YES),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
//		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/15.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
	
    // -----------------------------------------------------------------------
    #pragma mark - Add Sprite Frames To Cache
    // -----------------------------------------------------------------------
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites_player.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UIElements.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Characters.plist"];
    
    // -----------------------------------------------------------------------
    #pragma mark - Add Animations To Cache
    // -----------------------------------------------------------------------
    
    // Player throw animation
    NSMutableArray *throwFrames = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"obj_SpearThrow00%d.png", i]];
        [throwFrames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:throwFrames delay:PLAYER_THROW_ANIMATION_DELAY];
    [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:PLAYER_THROW_ANIMATION_NAME];
    
    // Player run animation
    NSMutableArray *runFrames = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"obj_Run00%d.png", i]];
        [runFrames addObject:frame];
    }
    animation = [CCAnimation animationWithSpriteFrames:runFrames delay:PLAYER_RUN_ANIMATION_DELAY];
    [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:PLAYER_RUN_ANIMATION_NAME];
    
    // Bat Fly animation animation
    NSMutableArray *batFlyFrames = [NSMutableArray array];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly000.png"]];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly001.png"]];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly002.png"]];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly003.png"]];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly002.png"]];
    [batFlyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_fly001.png"]];
    animation = [CCAnimation animationWithSpriteFrames:batFlyFrames delay:BAT_FLY_ANIMATION_DELAY];
    [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:BAT_FLY_ANIMATION_NAME];
    
    // Bat Fly animation animation
    NSMutableArray *batDieFrames = [NSMutableArray array];
    [batDieFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_hit.png"]];
    [batDieFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bat_dead.png"]];
    animation = [CCAnimation animationWithSpriteFrames:batDieFrames delay:BAT_DIE_ANIMATION_DELAY];
    [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:BAT_DIE_ANIMATION_NAME];
    
    
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [IntroScene sharedIntroScene];
}

@end
