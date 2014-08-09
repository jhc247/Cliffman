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

static const float PLAYER_MASS = 1.0f;
static const float PLAYER_SHOOT_SPEED = 450;
static const float PLAYER_ARM_LENGTH = 40;

static const float ROPE_ACCEL = 3000;
static const float ROPE_THICKNESS = 10;
static const float ROPE_MINMAX_LENGTH = 50;
static const float ROPE_BUFFER = 50;
static const float ROPE_PULL_FORCE = 1000;
static const float ROPE_MIN_LENGTH = 0;
static const float ROPE_HOOK_RADIUS = 10;

static const float GRAVITY_X = 0;
static const float GRAVITY_Y = -450;
//static const float GRAVITY_X = 0;
//static const float GRAVITY_Y = 0;
static const float AIR_RESISTANCE = 0.01f;
//static const float GRAVITY_Y = -5;

static const float CAMERA_PANNING_PERCENT = 0.5f;