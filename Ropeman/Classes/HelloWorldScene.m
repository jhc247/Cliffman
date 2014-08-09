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
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [_physicsWorld setGravity:CGPointMake(GRAVITY_X, GRAVITY_Y)];
    [self addChild:_physicsWorld];
    
    // Add a player
    _player = [Player createPlayer:self.contentSizeInPoints.width*.2 initialY:self.contentSizeInPoints.height *.8];
    [_physicsWorld addChild:_player];
    
    // Create walls
    Wall *ceiling = [Wall createWall:0 y:self.contentSize.height-50 width:self.contentSize.width*2 height:50];
    Wall *divider =[Wall createWall:self.contentSize.width/2-100 y:self.contentSize.height*.7 width:200 height:self.contentSize.height*.3];
    //Wall *floor = [Wall createWall:0 y:100 width:self.contentSize.width height:50];
    [_physicsWorld addChild: ceiling];
    [_physicsWorld addChild: divider];
    //[_physicsWorld addChild: floor];
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
    float threshholdX = CAMERA_PANNING_PERCENT * self.contentSize.width;
    if (currentX >= threshholdX) {
        float delta = currentX - threshholdX;
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
