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
    
    CCNodeColor* rope;
    
    float level_width;
    
    BOOL game_over;
    
    int collected;
    int maxHelmets;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene: (NSString*)level_name
{
    return [[self alloc] initLevel:level_name];
}

// -----------------------------------------------------------------------

- (id)initLevel: (NSString*)level_name
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = NO;
    
    // Set-up game elements extraction from TiledMap
    CCTiledMap *tilemap = [CCTiledMap tiledMapWithFile:level_name];
    
    width = [CCDirector is_iPad] ? self.contentSize.width : (426 + (2/3));
    height = [tilemap mapSize].height * [tilemap tileSize].height / 2;
    level_width = [tilemap mapSize].width * [tilemap tileSize].width / 2;
    if (![CCDirector is_iPad]) {
        height = height / IPAD_TO_IPHONE_HEIGHT_RATIO;
        level_width = level_width / IPAD_TO_IPHONE_HEIGHT_RATIO;
    }
    
    // Create a colored background (Dark Grey)
    // 91-89-60 = dirt color
    // 48-102-70 = green color
    CCColor *startColor = [CCColor colorWithRed:76.0/255.0f green:180.0f/255.0f blue:224.0f/255.0f];
    CCColor *endColor = [CCColor colorWithRed:42.0f/255.0f green:117.0f/255.0f blue:166.0f/255.0f];
    
    CCNodeGradient *background = [CCNodeGradient nodeWithColor:startColor fadingTo:endColor];
    [background setContentSize:CGSizeMake(level_width, height)];
    [self addChild:background];
    /*
    // Create background
    CCTexture *backgroundTexture = [CCTexture textureWithFile:@"snow_background.png"];
    int numRepetitions = (int)(ceilf(level_width / backgroundTexture.contentSize.width));
    numRepetitions = numRepetitions < 1 ? 1 : numRepetitions;
    for (int i = 0; i < numRepetitions; i++) {
        CCSprite* background = [CCSprite spriteWithTexture:backgroundTexture];
        background.anchorPoint = ccp(0,0);
        background.position = ccp(background.contentSize.width * i, 0);
        [self addChild:background];
    }
    */
    
    rope = [CCNodeColor nodeWithColor:[CCColor blackColor] width:10 height:50];
    rope.opacity = 0;
    [self addChild:rope];
    
    float coordinateMultiplier;
    switch ([CCDirector sharedDirector].device) {
        case iPadRetina:
            [tilemap setScale:1.0f];
            coordinateMultiplier = 0.5f;
            break;
        case iPadNonRetina:
            [tilemap setScale:0.5f];
            coordinateMultiplier = 0.5f;
            break;
        case iPhoneRetina:
            [tilemap setScale:(100.0f/240.0f)];
            coordinateMultiplier = (50.0f/240.0f);
            break;
        case iPhoneNonRetina:
            [tilemap setScale:(50.0f/240.0f)];
            coordinateMultiplier = (50.0f/240.0f);
            break;
        default:
            break;
    }
    
    [tilemap setScale:coordinateMultiplier];
    [self addChild:tilemap];
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    float x_grav = [CCDirector is_iPad] ? GRAVITY_X : GRAVITY_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float y_grav = [CCDirector is_iPad] ? GRAVITY_Y : GRAVITY_Y / IPAD_TO_IPHONE_HEIGHT_RATIO;
    _physicsWorld.gravity = ccp(x_grav, y_grav);
    [self addChild:_physicsWorld];
    
    CCSpriteBatchNode *spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sprites.pvr.ccz"];
    [_physicsWorld addChild:spritesBatchNode z:Z_ORDER_PLAYER];
    
    // Create the player
    CCTiledMapObjectGroup *playerGroup = [tilemap objectGroupNamed:@"player"];
    NSMutableDictionary *p = [[playerGroup objects] objectAtIndex:0];
    float x = ([[p valueForKey:@"x"] floatValue] + 48) * coordinateMultiplier;
    float y = ([[p valueForKey:@"y"] floatValue] + 116) * coordinateMultiplier;
    _player = [Player createPlayer:ccp(x,y) rope:rope];
    [spritesBatchNode addChild:_player];
    
    // Create walls
    CCTiledMapObjectGroup *wallGroup = [tilemap objectGroupNamed:@"walls"];
    NSMutableArray *walls = [wallGroup objects];
    for (NSMutableDictionary *wall in walls) {
        float x = [[wall valueForKey:@"x"] floatValue];
        float y = [[wall valueForKey:@"y"] floatValue];
        float wid = [[wall valueForKey:@"width"] floatValue];
        float hei = [[wall valueForKey:@"height"] floatValue];
        NSString *points = [wall valueForKey:@"polygonPoints"];
        Sensor* w = [Sensor createSensor:ccp(x,y) type:Wall width:wid height:hei points:points mult:coordinateMultiplier];
        [_physicsWorld addChild:w];
    }
    
    // Create spikes
    CCTiledMapObjectGroup *spikeGroup = [tilemap objectGroupNamed:@"spikes"];
    NSMutableArray *spikes = [spikeGroup objects];
    for (NSMutableDictionary *spike in spikes) {
        float x = [[spike valueForKey:@"x"] floatValue];
        float y = [[spike valueForKey:@"y"] floatValue];
        float wid = [[spike valueForKey:@"width"] floatValue];
        float hei = [[spike valueForKey:@"height"] floatValue];

        Sensor *s = [Sensor createSensor:ccp(x,y) type:Spike width:wid height:hei points:NULL mult:coordinateMultiplier];
        [_physicsWorld addChild:s];
    }
    
    // Create bats
    CCTiledMapObjectGroup *batGroup = [tilemap objectGroupNamed:@"bats"];
    NSMutableArray *bats = [batGroup objects];
    for (NSMutableDictionary *bat in bats) {
        float x = [[bat valueForKey:@"x"] floatValue] * coordinateMultiplier;
        float y = [[bat valueForKey:@"y"] floatValue] * coordinateMultiplier;
        Orientation orientation = [[bat valueForKey:@"orientation"] intValue];
        
        Bat *b = [Bat createBat:ccp(x, y) orientation:orientation player:(CCNode*)_player];
        [spritesBatchNode addChild:b];
    }
    
    // Create helmets
    CCTiledMapObjectGroup *helmetGroup = [tilemap objectGroupNamed:@"helmets"];
    NSMutableArray *helmets = [helmetGroup objects];
    for (NSMutableDictionary *helmet in helmets) {
        float x = [[helmet valueForKey:@"x"] floatValue];
        float y = [[helmet valueForKey:@"y"] floatValue];
        
        Sensor *h = [Sensor createSensor:ccp(x,y) type:Helmet width:0 height:0 points:NULL mult:coordinateMultiplier];
        [_physicsWorld addChild:h];
    }
    
    // Create win-zone(s)
    CCTiledMapObjectGroup *winZoneGroup = [tilemap objectGroupNamed:@"winZones"];
    NSMutableArray *winZones = [winZoneGroup objects];
    for (NSMutableDictionary *winZone in winZones) {
        float x = [[winZone valueForKey:@"x"] floatValue];
        float y = [[winZone valueForKey:@"y"] floatValue];
        float wid = [[winZone valueForKey:@"width"] floatValue];
        float hei = [[winZone valueForKey:@"height"] floatValue];
        
        Sensor *w = [Sensor createSensor:ccp(x,y) type:Win width:wid height:hei points:NULL mult:coordinateMultiplier];
        [_physicsWorld addChild:w];
    }
    
    // Set-up camera
    touchLayer = [TouchLayer createTouchLayer:self.contentSize];
    [self addChild:touchLayer];
    
    
    collected = 0;
    maxHelmets = 3;
    
    cameraLeft = 0;
    game_over = NO;
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
    if (game_over) {
        return;
    }
    float currentX = _player.position.x - cameraLeft;
    float leftThreshhold = CAMERA_PANNING_PERCENT_LEFT * self.contentSize.width;
    float rightThreshhold = CAMERA_PANNING_PERCENT_RIGHT * self.contentSize.width;
    if (currentX >= rightThreshhold) {
        int delta = roundf(currentX - rightThreshhold);
        if (cameraLeft + self.contentSize.width > level_width) {
            delta = 0;
        }
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    else if (currentX <= leftThreshhold) {
        int delta = roundf(currentX - leftThreshhold);
        if (cameraLeft + delta < 0) {
            delta = -cameraLeft;
        }
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    
    if (_player.position.y + _player.contentSize.height/2 < 0) {
        [self endLevel:YES];
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

// -----------------------------------------------------------------------

- (void) endLevel: (BOOL)died {
    game_over = YES;
    [touchLayer createMenu:died collected:collected];
    if (!died) {
        [[WorldSelectScene sharedWorldSelectScene] setNewLevelScore:collected];
    }
    [_player.physicsBody setSleeping:YES];
}

- (BOOL)pull {
    return game_over ? NO : [_player pull];
}

// Player-Sensor
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sensorCollision:(Sensor *)sensor playerCollision:(Player *)player {
    CCLOG(@"Sensor-Player collision");
    switch ([sensor type]) {
        case Spike:
            CCLOG(@"Player hit spike");
            return NO;
            
        case Helmet:
            CCLOG(@"Player hit helmet");
            collected = [sensor collectHelmet] ? collected + 1 : collected;
            return NO;
            
        case Wall:
            CCLOG(@"Player hit wall");
            self.physicsBody.collisionGroup = @"wallGroup";
            self.physicsBody.collisionType = @"wallCollision";
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.type = CCPhysicsBodyTypeStatic;
            return YES;
        case Win:
            CCLOG(@"Player hit win sensor");
            [self endLevel:NO];
            return NO;
        default:
            return YES;
            
    }
}

// Spear-Sensor
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sensorCollision:(Sensor *)sensor spearCollision:(Spear *)spear {
    CCLOG(@"Sensor-spear collision");
    switch ([sensor type]) {
        case Spike:
            CCLOG(@"Spear hit spike");
            return YES;
            
        case Helmet:
            CCLOG(@"Spear hit helmet");
            return NO;
    
        case Wall:
            CCLOG(@"Spear hit wall");
            [spear attach:sensor.position.x y:sensor.position.y width:sensor.getWallWidth height:sensor.getWallHeight];
            // Create the physics joint
            float ropeLength = ccpDistance(_player.position, spear.position) + ROPE_INITIAL_SLACK;
            ropeLength = (ropeLength >= ROPE_MINMAX_LENGTH) ? ropeLength : ROPE_MINMAX_LENGTH;
            [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:spear.physicsBody anchorA:ccp(_player.contentSize.width*.5, _player.contentSize.height*.5) anchorB:ccp(spear.contentSize.width/2,spear.contentSize.height*.2) minDistance:ROPE_MIN_LENGTH maxDistance:ropeLength];
            return YES;
            
        case Win:
            return NO;
        default:
            return YES;
            
    }
}

// Spear-Bat
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair batCollision:(Bat *)bat spearCollision:(Spear *)spear {
    
    [bat killBat];
    return NO;
}
@end
