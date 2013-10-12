//
//  Level.h
//  kidmm
//
//  Created by slxl on 17.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//
#import "GameManager.h"

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
