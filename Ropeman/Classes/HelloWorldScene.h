//
//  HelloWorldScene.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright JCard 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Player.h"
#import "Rope.h"
#import "Wall.h"
#import "Constants.h"
#import "IntroScene.h"
#import "TouchLayer.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate>


// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;
- (void)pull;

// -----------------------------------------------------------------------
@end