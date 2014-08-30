//
//  Spike.h
//  Ropeman
//
//  Created by Jcard on 8/13/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

typedef NS_ENUM(NSInteger, SensorType)
{
    Spike,
    Helmet,
    Wall,
    Win,
};

@interface Sensor : CCSprite {
    
}

@property (assign) SensorType type;

+ (Sensor *)createSensor: (CGPoint)position type:(SensorType)type width:(float)width height:(float)height points:(NSString*)points mult:(float)mult;

- (BOOL)collectHelmet;
- (float)getWallWidth;
- (float)getWallHeight;

@end
