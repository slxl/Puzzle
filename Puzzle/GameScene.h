//
//  Level.h
//  kidmm
//
//  Created by slxl on 16.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//


@class Level;

#import "cocos2d.h"
#import "CommonProtocols.h"
#import "GameManager.h"
#import "CCBAnimationManager.h"

@interface GameScene : CCLayer
{
    CCLayer* levelLayer;
    CCNode* level;
    CCBAnimationManager* animationManager;

}

+ (GameScene*) sharedScene;

- (void) handleLevelComplete;

@end

