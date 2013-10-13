//
//  Level.h
//  kidmm
//
//  Created by slxl on 16.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//

#import "cocos2d.h"
#import "CommonProtocols.h"
#import "GameManager.h"
#import "CCBAnimationManager.h"
#import "GameControlsLayer.h"
#import "LevelLayer.h"

@interface GameScene : CCLayer
{
    CCBAnimationManager* animationManager;
    GameControlsLayer* gameControlsLayer;
    LevelLayer* levelLayer;
}

+ (GameScene*) sharedScene;
+ (CCScene*)sceneWithLevel:(NSString*)levelID;


@end

