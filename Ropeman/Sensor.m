//
//  Spike.m
//  Ropeman
//
//  Created by Jcard on 8/13/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "Sensor.h"


@implementation Sensor {
    float _height;
    float _width;
    
    BOOL collected;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Sensor *)createSensor: (CGPoint)position type:(SensorType)type width:(float)width height:(float)height points:(NSString*)points mult:(float)mult {
    return [[self alloc] init:position type:type width:width height:height points:points mult:mult];
}

- (id)init: (CGPoint)position type:(SensorType)type width:(float)width height:(float)height points:(NSString*)points mult:(float)mult {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    _height = height * mult;
    _width = width * mult;
    
    if (type == Helmet) {
        //self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star.png"]];
        self = [super initWithImageNamed:@"helmet.png"];
        _height = self.contentSize.height;
        _width = self.contentSize.width;
        self.anchorPoint = ccp(0,0);
    }
    
    
    self.position = ccp(position.x * mult, position.y * mult);
    
    // Create physicsbody
    if (points == NULL) {
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(_width,_height)} cornerRadius:0.0f];
    }
    else {
        NSArray *pairs = [points componentsSeparatedByString:@" "];
        int count = pairs.count;
        CGPoint points[count];
        int i = 0;
        for (NSString* pair in pairs) {
            NSArray *xy = [pair componentsSeparatedByString:@","];
            int x = [[xy objectAtIndex:0] intValue] * mult;
            int y = -[[xy objectAtIndex:1] intValue] * mult;
            
            CGPoint point = ccp(x,y);
            points[i] = point;
            i++;
        }
        
        self.physicsBody = [CCPhysicsBody bodyWithPolygonFromPoints:points count:count cornerRadius:0];
    }
    
    _type = type;
    self.physicsBody.collisionType = @"sensorCollision";
    switch (type) {
        case Spike:
            self.physicsBody.collisionGroup = @"spikeGroup";
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.type = CCPhysicsBodyTypeStatic;
            break;
        case Helmet:
            self.physicsBody.collisionGroup = @"helmetGroup";
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.type = CCPhysicsBodyTypeStatic;
            collected = NO;
            break;
        case Wall:
            //self.physicsBody.sleeping = YES;
            self.physicsBody.collisionGroup = @"wallGroup";
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.type = CCPhysicsBodyTypeStatic;
            break;
        case Win:
            self.physicsBody.collisionGroup = @"winGroup";
            break;
        default:
            break;
            
    }
    
    return self;
}

- (void)dealloc
{
    
}

// -----------------------------------------------------------------------
#pragma mark - Update
// -----------------------------------------------------------------------


- (void)update:(CCTime)delta {
    
}

- (BOOL)collectHelmet {
    if (collected || _type != Helmet) {
        return NO;
    }
    collected = YES;
    [_parent removeChild:self];
    return YES;
}

- (float)getWallWidth {
    return _width;
}

- (float)getWallHeight {
    return _height;
}

@end
