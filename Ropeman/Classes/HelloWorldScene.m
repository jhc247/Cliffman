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
    
    // Set-up game elements extraction from TiledMap
    CCTiledMap *tilemap = [CCTiledMap tiledMapWithFile:@"testlevel.tmx"];
    
    // Create background
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
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    float x_grav = [CCDirector is_iPad] ? GRAVITY_X : GRAVITY_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float y_grav = [CCDirector is_iPad] ? GRAVITY_Y : GRAVITY_Y / IPAD_TO_IPHONE_HEIGHT_RATIO;
    _physicsWorld.gravity = ccp(x_grav, y_grav);
    [self addChild:_physicsWorld];
    
    CCSpriteBatchNode *playerBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"playersprites.pvr.ccz"];
    [_physicsWorld addChild:playerBatchNode];
    
    // Create walls
    CCTiledMapObjectGroup *wallGroup = [tilemap objectGroupNamed:@"walls"];
    NSMutableArray *walls = [wallGroup objects];
    for (NSMutableDictionary *wall in walls) {
        float x = [[wall valueForKey:@"x"] floatValue];
        float y = [[wall valueForKey:@"y"] floatValue];
        float wid = [[wall valueForKey:@"width"] floatValue];
        float hei = [[wall valueForKey:@"height"] floatValue];
        if (![CCDirector is_iPad]) {
            x = x / IPAD_TO_IPHONE_HEIGHT_RATIO;
            y = y / IPAD_TO_IPHONE_HEIGHT_RATIO;
            wid = wid / IPAD_TO_IPHONE_HEIGHT_RATIO;
            hei = hei / IPAD_TO_IPHONE_HEIGHT_RATIO;
        }
        
        Wall* w = [Wall createWall:x y:y width:wid height:hei];
        [_physicsWorld addChild:w z:Z_ORDER_WALL];
    }
    
    // Create spikes
    CCTiledMapObjectGroup *spikesGroup = [tilemap objectGroupNamed:@"spikes"];
    NSMutableArray *spikes = [spikesGroup objects];
    for (NSMutableDictionary *spike in spikes) {
        float x = [[spike valueForKey:@"x"] floatValue];
        float y = [[spike valueForKey:@"y"] floatValue];
        SpikeOrientation orientation = [[Spike valueForKey:@"orientation"] intValue];
        if (![CCDirector is_iPad]) {
            x = x / IPAD_TO_IPHONE_HEIGHT_RATIO;
            y = y / IPAD_TO_IPHONE_HEIGHT_RATIO;
        }
        Spike *s = [Spike createSpike:ccp(x, y) orientation:orientation];
        [_physicsWorld addChild:s];
    }
    
    // Create the player
    CCTiledMapObjectGroup *playerGroup = [tilemap objectGroupNamed:@"player"];
    NSMutableDictionary *p = [[playerGroup objects] objectAtIndex:0];
    float x = [[p valueForKey:@"x"] floatValue] + 23;
    float y = [[p valueForKey:@"y"] floatValue] + 57;
    if (![CCDirector is_iPad]) {
        x = x / IPAD_TO_IPHONE_HEIGHT_RATIO;
        y = y / IPAD_TO_IPHONE_HEIGHT_RATIO;
    }
    _player = [Player createPlayer:ccp(x,y)];
    
    [playerBatchNode addChild:_player z:Z_ORDER_PLAYER];
    
    // Set-up camera
    touchLayer = [TouchLayer createTouchLayer:self.contentSize];
    [self addChild:touchLayer];
    cameraLeft = 0;
    
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
        //game_over = YES;
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
    [_player throwSpear:touchLoc];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //[_currentRope doneRising];
}

// -----------------------------------------------------------------------


- (BOOL)pull {
    return game_over ? NO : [_player pull];
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair wallCollision:(Wall *)wall spearCollision:(Spear *)spear {
    [spear attach:wall.position.x y:wall.position.y width:wall.getWidth height:wall.getHeight];
    
    // Create the physics joint
    float ropeLength = ccpDistance(_player.position, spear.position) + ROPE_INITIAL_SLACK;
    ropeLength = (ropeLength >= ROPE_MINMAX_LENGTH) ? ropeLength : ROPE_MINMAX_LENGTH;
    [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:spear.physicsBody anchorA:ccp(_player.contentSize.width*.5, _player.contentSize.height*.5) anchorB:ccp(spear.contentSize.width/2,spear.contentSize.height*.2) minDistance:ROPE_MIN_LENGTH maxDistance:ropeLength];
    
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair spikeCollision:(Spike *)spike playerCollision:(Player *)player {
    CCLOG(@"Hit spike");
    
    //[_currentRope attach:wall.position.x y:wall.position.y width:wall.getWidth height:wall.getHeight];
    //CCLOG(@"Speed: %@", NSStringFromCGPoint(rope.physicsBody.velocity));
    return NO;
}


/*- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(Player *)player ropeCollision:(Rope *)rope {
    if ([_currentRope isAttached]) {
    //    [_currentRope stopPulling];
    }
    return YES;
}*/

@end
