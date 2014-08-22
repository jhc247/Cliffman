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

// Star Constants
static const float STAR_WIDTH = 70;
static const float STAR_HEIGHT = 70;

static const float ROPE_ACCEL = 1500;
static const float ROPE_THICKNESS = 5;
static const float ROPE_MINMAX_LENGTH = 50;
static const float ROPE_BUFFER = 50;
static const float ROPE_PULL_FORCE = 1000;
static const float ROPE_MIN_LENGTH = 0;
static const float ROPE_HOOK_RADIUS = 5;
static const float ROPE_INITIAL_SLACK = 0;
static const float ROPE_ADDITIONAL_GRAVITY = -3000;
static const int SPEAR_MAX_LIFE = 50;

static const float GRAVITY_X = 0;
static const float GRAVITY_Y = -450;
static const int AIR_RESISTANCE_DELAY = 350;
static const float AIR_RESISTANCE = 0.000f;

static const float CAMERA_PANNING_PERCENT_RIGHT = 0.60f;
//static const float CAMERA_PANNING_RIGHT_AREA =
static const float CAMERA_PANNING_PERCENT_LEFT = 0.1042f;

// Carousel constants
static const float CAROUSEL_MAX_VELOCITY = 5;
static const float CAROUSEL_VERTICAL_WIDTH = 240;
static const float CAROUSEL_VERTICAL_ELEMENT_HEIGHT = 300;
static const float CAROUSEL_VERTICAL_ELEMENT_BUFFER = 25;
static const float CAROUSEL_VERTICAL_MAX_HEIGHT_PERCENT = 0.90f;
static const float CAROUSEL_VERTICAL_OFFSET_X = 60;

static const float CAROUSEL_HORIZONTAL_HEIGHT = 240;
static const float CAROUSEL_HORIZONTAL_ELEMENT_WIDTH = 180;
static const float CAROUSEL_HORIZONTAL_ELEMENT_BUFFER = 30;
static const float CAROUSEL_HORIZONTAL_OFFSET_X = 60;

static const float VERTICAL_ELEMENT_TEXT_HEIGHT = 40.0f;

// Z-Orders
static const int Z_ORDER_PLAYER = 5;
static const int Z_ORDER_SPEAR = 1;
static const int Z_ORDER_TILEMAP = 0;

// Level Select Screen
static const float LEVEL_SCREEN_BORDER_THICKNESS = 3.0f;
static const float MAX_DELTA_LEVEL_SELECTION = 50;
static const float LEVEL_SCREEN_ARROW_BUFFER = 30;

// TouchLayer
static const float ENERGY_BAR_WIDTH = 200;
static const float ENERGY_BAR_HEIGHT = 30;
static const float ENERGY_BAR_INITIAL_ENERGY = 100;
static const float ENERGY_BAR_DEPLETION_RATE = 0.5;
static const float MENU_SCREEN_BOX_WIDTH = 210;
static const float MENU_SCREEN_COUNT_FONT_SIZE = 40;
static const float MENU_SCREEN_MESSAGE_FONT_SIZE = 60;

// Fonts Sizes
static const float FONT_SIZE_WORLD_NAME = 48.0f;
static const float FONT_SIZE_LEVEL_SELECTION = 60.0f;
static const float FONT_SIZE_INTRO_SCENE = 60.0f;
static const float FONT_SIZE_INTRO_SCENE_PLAY = 110.0f;

