//
//  HelloWorldScene.m
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright JCard 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    Player *_player;
    CCPhysicsNode *_physicsWorld;
    Rope* _currentRope;
    float cameraLeft;
    float width, height;
    TouchLayer *touchLayer;
    
    float level_width;
    
    BOOL game_over;
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
    
    width = [CCDirector is_iPad] ? self.contentSize.width : (426 + (2/3));
    height = self.contentSize.height;
    level_width = width * 3;
    
    CCTexture *backgroundTexture = [CCTexture textureWithFile:@"background.png"];
    int numRepetitions = (int)(ceilf(level_width / backgroundTexture.contentSize.width));
    numRepetitions = numRepetitions < 1 ? 1 : numRepetitions;
    
    for (int i = 0; i < numRepetitions; i++) {
        CCSprite* background = [CCSprite spriteWithTexture:backgroundTexture];
        background.anchorPoint = ccp(0,0);
        background.position = ccp(background.contentSize.width * i, 0);
        [self addChild:background];
    }
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    float x_grav = [CCDirector is_iPad] ? GRAVITY_X : GRAVITY_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float y_grav = [CCDirector is_iPad] ? GRAVITY_Y : GRAVITY_Y / IPAD_TO_IPHONE_HEIGHT_RATIO;
    _physicsWorld.gravity = ccp(x_grav, y_grav);
    [self addChild:_physicsWorld];
    
    // Add a player
    _player = [Player createPlayer:0 initialY:height*.8];
    [_physicsWorld addChild:_player];
    
    // Create walls
    Wall *ceiling = [Wall createWall:0 y:height*.9 width:2.1*backgroundTexture.contentSize.width height:height*.1];
    Wall *divider =[Wall createWall:width*.6 y:height*.7 width:width*.3 height:height*.3];
    Wall *floater = [Wall createWall:width * 1.5 y:self.contentSize.height*.5 width:width*.1 height:height*.1];
    [_physicsWorld addChild: ceiling];
    [_physicsWorld addChild: divider];
    [_physicsWorld addChild: floater];
    _currentRope = NULL;
    
    // Initialize camera
    touchLayer = [TouchLayer createTouchLayer:self.contentSize];
    [self addChild:touchLayer];
    cameraLeft = 0;
    
    CCLOG(@"To y: %f", height*.9);
    
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
        if (cameraLeft + self.contentSize.width > level_width) {
            delta = 0;
        }
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    else if (currentX <= leftThreshhold) {
        float delta = currentX - leftThreshhold;
        if (cameraLeft + delta < 0) {
            delta = -cameraLeft;
        }
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    
    if (_player.position.y + _player.contentSize.height/2 < 0) {
        //CCLOG(@"Died");
        game_over = YES;
    }
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (game_over) {
        return;
    }
    CGPoint touchLoc = [touch locationInNode:self];
    
    [_currentRope detach];
    
    _currentRope = [Rope createRope:_player target:&touchLoc];
    [_physicsWorld addChild:_currentRope];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //[_currentRope doneRising];
}

// -----------------------------------------------------------------------


- (void)pull {
    
    if (_currentRope == NULL || game_over) {
        return;
    }
    [_currentRope activatePulling];
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair wallCollision:(Wall *)wall ropeCollision:(Rope *)rope {
    [_currentRope attach:wall.position.x y:wall.position.y width:wall.getWidth height:wall.getHeight];
    CCLOG(@"Speed: %@", NSStringFromCGPoint(rope.physicsBody.velocity));
    return YES;
}


/*- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(Player *)player ropeCollision:(Rope *)rope {
    if ([_currentRope isAttached]) {
    //    [_currentRope stopPulling];
    }
    return YES;
}*/

@end
