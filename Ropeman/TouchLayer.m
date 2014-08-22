//
//  TouchLayer.m
//  Ropeman
//
//  Created by Jcard on 8/8/14.
//  Copyright 2014 JCard. All rights reserved.
//

#import "TouchLayer.h"

/*
  This class represents a "transparent layer" is always at the exact dimensions and position of what players currently view on their device while in a level. This layer does not interact with any physics objects, but does receive touch events. This layer contains the "Menu" button and the "death" message.
  
*/

@implementation TouchLayer {
    CCSprite *pullButton;
    CCNodeColor* pullEnergyBar;
    
    BOOL pulling;
    float currentEnergy;
    
    float energyBarWidth;
    float energyBarHeight;
}

// Creates and initializes a TouchLayer instance
+ (instancetype) createTouchLayer:(CGSize) size {
    return [[TouchLayer alloc] initTouchLayer:size];
}

// Initializes a TouchLayer instance
- (instancetype)initTouchLayer:(CGSize) size {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //self = [CCNodeColor nodeWithColor:[CCColor blueColor] width:size.width height:size.height];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    self.anchorPoint = ccp(0.5,0.5);
    self.position = ccp(size.width/2,size.height/2);
    [self setContentSize: size];
    
    // Create a pull button
    //CCButton *pullButton = [CCButton buttonWithTitle:@"Pull" fontName:@"Verdana-Bold" fontSize:26.0f];
    pullButton = [CCSprite spriteWithImageNamed:@"pullButton.png"];
    pullButton.positionType = CCPositionTypeNormalized;
    pullButton.position = ccp(0.0f, 0.0f); // Bottom Right of screen
    pullButton.anchorPoint = ccp(0,0);
    //[pullButton setTarget:self selector:@selector(onPullClicked:)];
    [self addChild:pullButton];
    
    // Create pull energy bar
    energyBarWidth = [CCDirector is_iPad] ? ENERGY_BAR_WIDTH : ENERGY_BAR_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    energyBarHeight = [CCDirector is_iPad] ? ENERGY_BAR_HEIGHT : ENERGY_BAR_HEIGHT / IPAD_TO_IPHONE_HEIGHT_RATIO;
    
    pullEnergyBar = [CCNodeColor nodeWithColor:[CCColor greenColor] width:energyBarWidth height:energyBarHeight];
    pullEnergyBar.anchorPoint = ccp(0,1);
    pullEnergyBar.positionType = CCPositionTypeNormalized;
    pullEnergyBar.position = ccp(0, 0.95f);
    currentEnergy = ENERGY_BAR_INITIAL_ENERGY;
    [self addChild:pullEnergyBar];
    
    
    // Create a pull button
    //CCButton *pullButton = [CCButton buttonWithTitle:@"Pull" fontName:@"Verdana-Bold" fontSize:26.0f];
    /*CCSprite *pullButton2 = [CCSprite spriteWithImageNamed:@"pullButtonBlue.png"];
    pullButton2.positionType = CCPositionTypeNormalized;
    pullButton2.position = ccp(0.02f, 0.3f); // Bottom Right of screen
    pullButton2.anchorPoint = ccp(0,0);
    //[pullButton setTarget:self selector:@selector(onPullClicked:)];
    [self addChild:pullButton2];
    */
    return self;
}

- (void)update:(CCTime)delta {
    HelloWorldScene *scene = (HelloWorldScene*)_parent;
    if (pulling && currentEnergy > 0 && [scene pull]) {
        currentEnergy -= ENERGY_BAR_DEPLETION_RATE;
        currentEnergy = currentEnergy < 0 ? 0 : currentEnergy;
        
        [pullEnergyBar setContentSize:CGSizeMake((currentEnergy / ENERGY_BAR_INITIAL_ENERGY)*energyBarWidth, energyBarHeight)];
    }
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onReturnClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[WorldSelectScene sharedWorldSelectScene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onRetryClicked:(id)sender
{
    [[WorldSelectScene sharedWorldSelectScene] resetScene];
}

- (void)onNextClicked:(id)sender
{
    //[[WorldSelectScene sharedWorldSelectScene] resetScene];
    CCLOG(@"Next");
}

- (void)createMenu: (BOOL)died collected:(int)collected {
    
    CCColor *borderColor = [CCColor colorWithRed:191.0f/255.0f green:169.0f/255.0f blue:133.0f/255.0f];
    CCColor *brown = [CCColor colorWithRed:0.54f green:0.39f blue:0.13f];
    
    CCNodeColor *blackCover = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    blackCover.opacity = 0.6;
    [self addChild:blackCover];
    
    // Return button
    float width = self.contentSize.width*.75;
    float height = self.contentSize.height*.75;
    CCSprite* menu = [CCSprite spriteWithImageNamed:@"popupMenu.png"];
    //CCNodeColor *menu = [CCNodeColor nodeWithColor:borderColor width:width height:height];
    menu.anchorPoint = ccp(0.5, 0.5);
    menu.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:menu];
    CCButton *returnButton = [CCButton buttonWithTitle:@" "];
    float boxWidth = [CCDirector is_iPad] ? MENU_SCREEN_BOX_WIDTH : MENU_SCREEN_BOX_WIDTH / IPAD_TO_IPHONE_HEIGHT_RATIO;
    [returnButton setPreferredSize:CGSizeMake(boxWidth, boxWidth)];
    returnButton.position = ccp(self.contentSize.width/2 - menu.contentSize.width/2, self.contentSize.height/2 + menu.contentSize.height/2);
    returnButton.anchorPoint = ccp(0,1);
    [returnButton setTarget:self selector:@selector(onReturnClicked:)];
    [self addChild:returnButton];
    
    // Helmet count
    float font_size = [CCDirector is_iPad] ? MENU_SCREEN_COUNT_FONT_SIZE : MENU_SCREEN_COUNT_FONT_SIZE / IPAD_TO_IPHONE_HEIGHT_RATIO;
    NSString *countString = [NSString stringWithFormat:@"%d / %d",collected, [[WorldSelectScene sharedWorldSelectScene] maxHelmets]];
    CCLabelTTF *count = [CCLabelTTF labelWithString:countString fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(boxWidth * 0.50, boxWidth * 0.4)];
    [count setHorizontalAlignment:CCTextAlignmentCenter];
    [count setVerticalAlignment:CCVerticalTextAlignmentCenter];
    count.adjustsFontSizeToFit = YES;
    count.color = brown;
    count.position = ccp(self.contentSize.width/2 - menu.contentSize.width/2 + boxWidth*0.45, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.025);
    count.anchorPoint = ccp(0, 0);
    [self addChild:count];
    
    if (died) {
        // Death message
        NSString *deathString = @"Were you expecting fluffy \npillows?";
        font_size = [CCDirector is_iPad] ? MENU_SCREEN_MESSAGE_FONT_SIZE : MENU_SCREEN_MESSAGE_FONT_SIZE / IPAD_TO_IPHONE_HEIGHT_RATIO;
        CCLabelTTF *death = [CCLabelTTF labelWithString:deathString fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(boxWidth * 1.8, boxWidth * 0.6)];
        [death setHorizontalAlignment:CCTextAlignmentCenter];
        [death setVerticalAlignment:CCVerticalTextAlignmentTop];
        death.adjustsFontSizeToFit = YES;
        death.color = brown;
        death.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - boxWidth, self.contentSize.height/2 + menu.contentSize.height/2 - boxWidth *.05);
        death.anchorPoint = ccp(0.5, 1);
        
        CCSprite* deadImage = [CCSprite spriteWithImageNamed:@"deadPlayer.png"];
        deadImage.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - boxWidth, self.contentSize.height/2 + menu.contentSize.height/2 - boxWidth *.6);
        deadImage.anchorPoint = ccp(0.5, 1);
        
        [self addChild:death];
        [self addChild:deadImage];
        
        // Retry button
        //float width = self.contentSize.width*.75;
        //float height = self.contentSize.height*.75;
        CCSprite* retry = [CCSprite spriteWithImageNamed:@"retryArrow.png"];
        retry.anchorPoint = ccp(0.5, 0);
        retry.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - boxWidth, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.1);
        CCButton *retryButton = [CCButton buttonWithTitle:@" "];
        [retryButton setPreferredSize:retry.contentSize];
        retryButton.position = retry.position;
        retryButton.anchorPoint = ccp(0.5,0);
        [retryButton setTarget:self selector:@selector(onRetryClicked:)];
        CCLabelTTF *retryText = [CCLabelTTF labelWithString:@"Replay" fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(retry.contentSize.width, boxWidth * .2)];
        [retryText setHorizontalAlignment:CCTextAlignmentCenter];
        [retryText setVerticalAlignment:CCVerticalTextAlignmentCenter];
        retryText.adjustsFontSizeToFit = YES;
        retryText.color = brown;
        retryText.position = ccp(retry.position.x, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.8);
        retryText.anchorPoint = ccp(0.5, 0);
        [self addChild:retryText];
        [self addChild:retry];
        [self addChild:retryButton];
    }
    else {
        // Win message
        NSString *winString = @"Good work!\nOnto the next level";
        font_size = [CCDirector is_iPad] ? MENU_SCREEN_MESSAGE_FONT_SIZE : MENU_SCREEN_MESSAGE_FONT_SIZE / IPAD_TO_IPHONE_HEIGHT_RATIO;
        CCLabelTTF *win = [CCLabelTTF labelWithString:winString fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(boxWidth * 1.8, boxWidth * 0.6)];
        [win setHorizontalAlignment:CCTextAlignmentCenter];
        [win setVerticalAlignment:CCVerticalTextAlignmentTop];
        win.adjustsFontSizeToFit = YES;
        win.color = brown;
        win.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - boxWidth, self.contentSize.height/2 + menu.contentSize.height/2 - boxWidth *.05);
        win.anchorPoint = ccp(0.5, 1);
        
        CCSprite* winImage = [CCSprite spriteWithImageNamed:@"winPlayer.png"];
        winImage.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - boxWidth, self.contentSize.height/2 + menu.contentSize.height/2 - boxWidth *.6);
        winImage.anchorPoint = ccp(0.5, 1);
        
        [self addChild:win];
        [self addChild:winImage];
        
        // Retry button
        //float width = self.contentSize.width*.75;
        //float height = self.contentSize.height*.75;
        CCSprite* retry = [CCSprite spriteWithImageNamed:@"retryArrow.png"];
        CCSprite* next = [CCSprite spriteWithImageNamed:@"nextarrow.png"];
        retry.anchorPoint = ccp(0.5, 0);
        retry.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - 1.5*boxWidth, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.1);
        CCButton *retryButton = [CCButton buttonWithTitle:@" "];
        [retryButton setPreferredSize:retry.contentSize];
        retryButton.position = retry.position;
        retryButton.anchorPoint = ccp(0.5,0);
        [retryButton setTarget:self selector:@selector(onRetryClicked:)];
        CCLabelTTF *retryText = [CCLabelTTF labelWithString:@"Replay" fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(next.contentSize.width*.9, boxWidth * .2)];
        [retryText setHorizontalAlignment:CCTextAlignmentCenter];
        [retryText setVerticalAlignment:CCVerticalTextAlignmentCenter];
        retryText.adjustsFontSizeToFit = YES;
        retryText.color = brown;
        retryText.position = ccp(retry.position.x, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.8);
        retryText.anchorPoint = ccp(0.5, 0);
        [self addChild:retryText];
        [self addChild:retry];
        [self addChild:retryButton];
        
        // Next button
        next.anchorPoint = ccp(0.5, 0);
        next.position = ccp(self.contentSize.width/2 + menu.contentSize.width/2 - 0.5*boxWidth, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.27);
        CCButton *nextButton = [CCButton buttonWithTitle:@" "];
        [nextButton setPreferredSize:CGSizeMake(next.contentSize.width, retry.contentSize.height)];
        nextButton.position = next.position;
        nextButton.anchorPoint = ccp(0.5,0.25);
        [nextButton setTarget:self selector:@selector(onNextClicked:)];
        CCLabelTTF *nextText = [CCLabelTTF labelWithString:@"Next Level" fontName:@"UnZialish" fontSize:font_size dimensions:CGSizeMake(next.contentSize.width*1.5, boxWidth * .2)];
        [nextText setHorizontalAlignment:CCTextAlignmentCenter];
        [nextText setVerticalAlignment:CCVerticalTextAlignmentCenter];
        nextText.adjustsFontSizeToFit = YES;
        nextText.color = brown;
        nextText.position = ccp(next.position.x, self.contentSize.height/2 - menu.contentSize.height/2 + boxWidth *.8);
        nextText.anchorPoint = ccp(0.5, 0);
        [self addChild:nextText];
        [self addChild:next];
        [self addChild:nextButton];

    
    }
    
}

/*
 Touch events are all handled by the parent: LevelScene
 */

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    CCLOG(@"Touched TouchLayer at %@", NSStringFromCGPoint([touch locationInNode:self]));
    if (touchLoc.x <= pullButton.contentSize.width && touchLoc.y <= pullButton.contentSize.height) {
        CCLOG(@"PUlling");
        pulling = YES;
    }
    else {
        //CCLOG(@"Touched TouchLayer at %@", NSStringFromCGPoint([touch locationInNode:_parent]));
        [_parent touchBegan:touch withEvent:event];
    }
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (pulling) {
        if (touchLoc.x > 1.5*pullButton.contentSize.width || touchLoc.y > 1.5*pullButton.contentSize.height) {
            pulling = NO;
        }
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (touchLoc.x <= pullButton.contentSize.width && touchLoc.y <= pullButton.contentSize.height) {
        CCLOG(@"Pulling Stopped");
        
    }
    pulling = NO;
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (touchLoc.x <= pullButton.contentSize.width && touchLoc.y <= pullButton.contentSize.height) {
        CCLOG(@"PUlling Cancelled");
    }
    pulling = NO;
}

@end
