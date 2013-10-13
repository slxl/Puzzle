//
//  GameControlsLayer.m
//  Puzzle
//
//  Created by slava on 13.10.13.
//  Copyright 2013 Vyacheslav Khlichkin. All rights reserved.
//

#import "GameControlsLayer.h"


@implementation GameControlsLayer
{
    CCMenu* restartButtonMenu;
}

- (id) init{
    self = [super init];
    if (self != nil){
        
        CCMenuItem *restartButton = [CCMenuItemImage
                                     itemWithNormalImage:@"retry.png"
                                     selectedImage:@"retry_pressed.png"
                                     target:self
                                     selector:@selector(restartButtonTapped)];
        restartButton.position = ccp(120, 130);
        restartButtonMenu = [CCMenu menuWithItems:restartButton, nil];
        restartButtonMenu.position = CGPointZero;
        [self addChild:restartButtonMenu];
    }
    return self;
}

- (void) restartButtonTapped{

#warning add an alert view
    
    PLAYSOUNDEFFECT(S2);
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:@"L101"]];
}


@end
