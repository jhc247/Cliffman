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

static const float IPAD_TO_IPHONE_HEIGHT_RATIO = 2.4;

static const float PLAYER_MASS = 1.0f;
static const float PLAYER_SHOOT_SPEED = 450;
static const float PLAYER_ARM_LENGTH = 30;

static const float ROPE_ACCEL = 3000;
static const float ROPE_THICKNESS = 10;
static const float ROPE_MINMAX_LENGTH = 50;
static const float ROPE_BUFFER = 50;
static const float ROPE_PULL_FORCE = 500;
static const float ROPE_MIN_LENGTH = 0;
static const float ROPE_HOOK_RADIUS = 10;
static const float ROPE_INITIAL_SLACK = 0;
static const float ROPE_ADDITIONAL_GRAVITY = -3000;

static const float GRAVITY_X = 0;
static const float GRAVITY_Y = -450;
static const float AIR_RESISTANCE = 0.01f;

static const float CAMERA_PANNING_PERCENT_RIGHT = 0.60f;
//static const float CAMERA_PANNING_RIGHT_AREA =
static const float CAMERA_PANNING_PERCENT_LEFT = 0.1042f;