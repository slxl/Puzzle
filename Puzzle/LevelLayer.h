//
//  Level.h
//  kidmm
//
//  Created by slxl on 17.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//
#import "GameManager.h"
#import "CCBAnimationManager.h"

@interface LevelLayer : CCLayer
{
    CCBAnimationManager* animationManager;
    SpriteType spriteType;

}

@property (nonatomic, assign) int elementsQuantity;
@property (nonatomic, retain) NSString *levelID;

@end
