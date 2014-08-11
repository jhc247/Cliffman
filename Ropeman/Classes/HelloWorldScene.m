//
//  HelloWorldScene.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright JCard 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "TouchLayer.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    Player *_player;
    CCPhysicsNode *_physicsWorld;
    Rope* _currentRope;
    float cameraLeft;
    
    TouchLayer *touchLayer;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = NO;
    
    /*// Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    */
    
    float width = self.contentSize.width;
    float height = self.contentSize.height;
    
    if (width == 480) { // 3.5" iPhone
        CCLOG(@"3.5 iPhone");
        width = 426 + (2/3);
    }
    else if (width == 568) { // 4" iPhone
        CCLOG(@"4 iPhone");
        width = 426 + (2/3);
    }
    else {
        CCLOG(@"iPad");
    }
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [_physicsWorld setGravity:CGPointMake(GRAVITY_X, GRAVITY_Y)];
    [self addChild:_physicsWorld];
    
    // Add a player
    _player = [Player createPlayer:width*.2 initialY:height *.5];
    [_physicsWorld addChild:_player];
    
    // Create walls
    Wall *ceiling = [Wall createWall:0 y:height*.9 width:width*3 height:height*.1];
    Wall *divider =[Wall createWall:width y:height*.7 width:width*.3 height:height*.3];
    //Wall *floater = [Wall createWall:width * 1.5 y:self.contentSize.height*.7 width:100 height:100];
    [_physicsWorld addChild: ceiling];
    [_physicsWorld addChild: divider];
    //[_physicsWorld addChild: floater];
    _currentRope = NULL;
    
    // Initialize camera
    touchLayer = [TouchLayer createTouchLayer:self.contentSize];
    [self addChild:touchLayer];
    cameraLeft = 0;
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void)update:(CCTime)delta {
    float currentX = _player.position.x - cameraLeft;
    float leftThreshhold = CAMERA_PANNING_PERCENT_LEFT * self.contentSize.width;
    float rightThreshhold = CAMERA_PANNING_PERCENT_RIGHT * self.contentSize.width;
    if (currentX >= rightThreshhold) {
        float delta = currentX - rightThreshhold;
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    else if (currentX <= leftThreshhold) {
        float delta = currentX - leftThreshhold;
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    [_currentRope detach];
    
    _currentRope = [Rope createRope:_player origin:&touchLoc];
    [_physicsWorld addChild:_currentRope];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //[_currentRope doneRising];
}

// -----------------------------------------------------------------------


- (void)pull {
    
    if (_currentRope == NULL) {
        return;
    }
    [_currentRope activatePulling];
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair wallCollision:(Wall *)wall ropeCollision:(Rope *)rope {
    [_currentRope attach:wall.position.x y:wall.position.y width:wall.getWidth height:wall.getHeight];
    return YES;
}

/*
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(Player *)player ropeCollision:(Rope *)rope {
    if ([_currentRope isAttached]) {
        [_currentRope stopPulling];
    }
    return YES;
}*/

@end
