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
    
    int collected;
    int maxHelmets;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene: (NSString*)level_name depletionRate:(double)levelDepletion
{
    return [[self alloc] initLevel:level_name depletionRate:levelDepletion];
}

// -----------------------------------------------------------------------

- (id)initLevel: (NSString*)level_name depletionRate:(double)levelDepletion
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
    CCColor *startColor = [CCColor colorWithRed:254.0/255.0f green:254.0f/255.0f blue:254.0f/255.0f];
    CCColor *endColor = [CCColor colorWithRed:149.0f/255.0f green:179.0f/255.0f blue:254.0f/255.0f];
    
    CCNodeGradient *background = [CCNodeGradient nodeWithColor:startColor fadingTo:endColor];
    [background setContentSize:CGSizeMake(level_width, height)];
    [self addChild:background];
    
    // Create background
    CCTexture *backgroundTexture = [CCTexture textureWithFile:@"mountain.png"];
    int numRepetitions = random() % (int)(3*ceilf(level_width / backgroundTexture.contentSize.width));
    numRepetitions = numRepetitions < 1 ? 1 : numRepetitions;
    for (int i = 0; i < numRepetitions; i++) {
        CCSprite* background = [CCSprite spriteWithTexture:backgroundTexture];
        background.anchorPoint = ccp(0.5,0);
        float x = random() % (int)level_width;
        float y = random() % (int)backgroundTexture.contentSize.height*.8;
        background.flipX = (random() % 2 > 0);
        background.position = ccp(x, -y);
        [self addChild:background];
    }
    
    
    float coordinateMultiplier;
    switch ([CCDirector sharedDirector].device) {
        case iPadRetina:
            //[tilemap setScale:1.0f];
            coordinateMultiplier = 0.5f;
            break;
        case iPadNonRetina:
            //[tilemap setScale:0.5f];
            coordinateMultiplier = 0.5f;
            break;
        case iPhoneRetina:
            //[tilemap setScale:(100.0f/240.0f)];
            coordinateMultiplier = (50.0f/240.0f);
            break;
        case iPhoneNonRetina:
            //[tilemap setScale:(50.0f/240.0f)];
            coordinateMultiplier = (50.0f/240.0f);
            break;
        default:
            break;
    }
    
    //[tilemap setScale:coordinateMultiplier];
    [self addChild:tilemap];
    
    // Create physics
    _physicsWorld = [CCPhysicsNode node];
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    float x_grav = [CCDirector is_iPad] ? GRAVITY_X : GRAVITY_X / IPAD_TO_IPHONE_HEIGHT_RATIO;
    float y_grav = [CCDirector is_iPad] ? GRAVITY_Y : GRAVITY_Y / IPAD_TO_IPHONE_HEIGHT_RATIO;
    _physicsWorld.gravity = ccp(x_grav, y_grav);
    [self addChild:_physicsWorld];
    
    CCSpriteBatchNode *charactersBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"Characters.png"];
    [_physicsWorld addChild:charactersBatchNode z:Z_ORDER_SPRITES];
    
    // Create the player
    CCTiledMapObjectGroup *playerGroup = [tilemap objectGroupNamed:@"player"];
    NSMutableDictionary *p = [[playerGroup objects] objectAtIndex:0];
    float x = ([[p valueForKey:@"x"] floatValue] + 48) * coordinateMultiplier;
    float y = ([[p valueForKey:@"y"] floatValue] + 116) * coordinateMultiplier;
    BOOL shoot = (![[p valueForKey:@"dontshoot"] intValue] > 0);
    _player = [Player createPlayer:ccp(x,y) shoot:shoot];
    [charactersBatchNode addChild:_player];
    
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
        [charactersBatchNode addChild:b];
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
    touchLayer = [TouchLayer createTouchLayer:self.contentSize depletionRate:levelDepletion];
    [self addChild:touchLayer z:Z_ORDER_MENU];
    
    
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
        float delta = (currentX - rightThreshhold);
        if (cameraLeft + self.contentSize.width > level_width) {
            delta = 0;
        }
        cameraLeft += delta;
        self.position = ccp(self.position.x - delta, 0);
        touchLayer.position = ccp(touchLayer.position.x + delta, touchLayer.position.y);
    }
    else if (currentX <= leftThreshhold) {
        float delta = (currentX - leftThreshhold);
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
    if (game_over) {
        return;
    }
    
    game_over = YES;
    [touchLayer startMakingMenu:died collected:collected];
    if (!died) {
        [[WorldSelectScene sharedWorldSelectScene] setNewLevelScore:collected];
    }
    [_player.physicsBody setSleeping:YES];
    if (died) {
        [_player killPlayer];
    }
    else {
        [_player levelWon];
    }
    
}

- (BOOL)pull {
    return game_over ? NO : [_player pull];
}

// Player-Sensor
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sensorCollision:(Sensor *)sensor playerCollision:(Player *)player {
    //CCLOG(@"Sensor-Player collision");
    switch ([sensor type]) {
        case Spike:
            [self endLevel:YES];
            return NO;
            
        case Helmet:
            if (game_over) {
                return NO;
            }
            collected = [sensor collectHelmet] ? collected + 1 : collected;
            return NO;
            
        case Wall:
            
            return YES;
        case Win:
            [self endLevel:NO];
            return NO;
        default:
            return YES;
            
    }
}


// Spear-Sensor
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sensorCollision:(Sensor *)sensor spearCollision:(Spear *)spear {
    switch ([sensor type]) {
        case Spike:
            if (spear.state == Attached) {
                return YES;
            }
            //[spear detach];
            return YES;

        case Helmet:
            return NO;
    
        case Wall: {
            if (game_over) {
                return YES;
            }
            [self parent];
            // Create the physics joint
            /*float angle1 = _player.flipX ? _player.rotation + 45 : -_player.rotation + 45;
            
            float deltaX = cosf(CC_DEGREES_TO_RADIANS(angle1)) * _player.contentSize.width*.10 * sqrtf(2);
            float deltaY = sinf(CC_DEGREES_TO_RADIANS(angle1)) * _player.contentSize.width*.10 * sqrtf(2);
            
            float orig_x = _player.flipX ? _player.position.x - deltaX : self.position.x + deltaX;
            float orig_y = _player.position.y + deltaY;
            CGPoint orig = ccp(orig_x, orig_y);*/
            
            float angle1 = _player.flipX ? _player.rotation : -_player.rotation;
            
            float deltaX = sinf(CC_DEGREES_TO_RADIANS(angle1)) * _player.contentSize.height*.15;
            float deltaY = cosf(CC_DEGREES_TO_RADIANS(angle1)) * _player.contentSize.height*.15;
            
            float orig_x = _player.flipX ? _player.position.x + deltaX : _player.position.x - deltaX;
            float orig_y = _player.position.y + deltaY;
            CGPoint orig = ccp(orig_x, orig_y);
            
            float ropeLength = ccpDistance(orig, spear.position);
            
            if (![spear attach:ropeLength]) {
                return YES;
            }
            [[_player jointLock] lock];
            for (CCPhysicsJoint* joint in [_player.physicsBody joints]) {
                if (joint.valid) {
                    [joint invalidate];
                }
            }
            float minMax = [CCDirector is_iPad] ? ROPE_MINMAX_LENGTH : ROPE_MINMAX_LENGTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
            ropeLength = (ropeLength > minMax) ? ropeLength : minMax;
            [CCPhysicsJoint connectedDistanceJointWithBodyA:_player.physicsBody bodyB:spear.physicsBody anchorA:ccp(_player.contentSize.width*.55, _player.contentSize.height*.60) anchorB:ccp(spear.contentSize.width*.5,spear.contentSize.height*.17) minDistance:0 maxDistance:ropeLength];
            [[_player jointLock] unlock];
            [spear setOriginalLength:ropeLength];
            //_player.physicsBody.affectedByGravity = NO;
            //_player.physicsBody.velocity = ccp(0,-30);
            return YES;
        }
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
