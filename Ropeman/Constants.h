//
//  Constants.h
//  Ropeman
//
//  Created by Jcard on 8/7/14.
//  Copyright (c) 2014 JCard. All rights reserved.
//

/*
 A collection of constants used in the game. Allows for easy tuning of playtesting variables.
 */

#import "cocos2d.h"

typedef NS_ENUM(NSInteger, Orientation)
{
    FacingUp,
    FacingRight,
    FacingDown,
    FacingLeft
};

static const float IPAD_TO_IPHONE_HEIGHT_RATIO = 2.4;

static const float PLAYER_MASS = 1.0f;
static const float PLAYER_SHOOT_SPEED = 700;


// Player throwing animation
static NSString* const PLAYER_THROW_ANIMATION_NAME = @"player_throw";
static const float PLAYER_THROW_ANIMATION_DELAY = 0.05f;
static const float PLAYER_ARM_LENGTH = 20;

// Player start Sequence
static const float PLAYER_RUN_SPEED = 300;
static const float PLAYER_RUN_DISTANCE = 530;
static const float PLAYER_JUMP_IMPULSE = 300;
static const float PLAYER_JUMP_ANGLE = 0;

static NSString* const PLAYER_RUN_ANIMATION_NAME = @"player_run";
static const float PLAYER_RUN_ANIMATION_DELAY = 0.05f;

// Bat Constants
static const float BAT_AGGRESIVE_RADIUS = 250.0f;
static const float BAT_CHASE_SPEED = 400.0f;
static NSString* const BAT_FLY_ANIMATION_NAME = @"bat_fly";
static const float BAT_FLY_ANIMATION_DELAY = 0.075f;
static NSString* const BAT_DIE_ANIMATION_NAME = @"bat_die";
static const float BAT_DIE_ANIMATION_DELAY = 0.3f;

static const float ROPE_ACCEL = 3000;
static const float ROPE_THICKNESS = 10;
static const float ROPE_MINMAX_LENGTH = 50;
static const float ROPE_BUFFER = 50;
static const float ROPE_PULL_FORCE = 500;
static const float ROPE_MIN_LENGTH = 0;
static const float ROPE_HOOK_RADIUS = 5;
static const float ROPE_INITIAL_SLACK = 0;
static const float ROPE_ADDITIONAL_GRAVITY = -3000;

static const float GRAVITY_X = 0;
static const float GRAVITY_Y = -450;
static const float AIR_RESISTANCE = 0.01f;

static const float CAMERA_PANNING_PERCENT_RIGHT = 0.60f;
//static const float CAMERA_PANNING_RIGHT_AREA =
static const float CAMERA_PANNING_PERCENT_LEFT = 0.1042f;

// Z-Orders
static const int Z_ORDER_PLAYER = 5;
static const int Z_ORDER_SPEAR = 1;
static const int Z_ORDER_TILEMAP = 0;
