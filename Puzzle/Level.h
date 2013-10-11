//
//  Level.h
//  kidmm
//
//  Created by slxl on 17.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//
#import "cocos2d.h"
#import "CommonProtocols.h"
#import "GameManager.h"


@class MovableObject;

@interface Level : CCLayer
{

    SpriteType spriteType;
    CCNode * selObject;
    int tempZ;
    float xStart;
    float yStart;
    float xTarget;
    float yTarget;
    BOOL won;
    NSMutableArray* winTest;
    
}

@end
