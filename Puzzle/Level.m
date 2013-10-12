//
//  Level.m
//  kidmm
//
//  Created by slxl on 17.12.12.
//  Copyright (c) 2012 slxl. All rights reserved.
//

#import "Level.h"
#import "GameScene.h"

@implementation Level
{
    CCLayer* levelLayer;
    
    int partsQuantity;
}

#pragma mark - Initialization

- (id) initWithLevel:(NSString*)level{
    self = [super init];
    if (self != nil) {
    
        // get level variables from plist

        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"LevelSettings.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSDictionary *levelsDict = [NSDictionary dictionaryWithDictionary:[plistData objectForKey:@"Levels"]];
        NSDictionary *levelDict = [NSDictionary dictionaryWithDictionary:[levelDict objectForKey:level]];
                                   
        
        partsQuantity = [[plistData objectForKey:@"partsQuantity"] integerValue];
        
        // Load the level
        levelLayer = [CCBReader nodeGraphFromFile:level];
       
        
        // And add it to the game scene
        [self addChild:levelLayer];
        
    
    }
    return self;
}


- (void) onEnter{
    
    [super onEnter];
    
    // Array init
    won = FALSE;
    winTest = [[NSMutableArray alloc] init];
    for(int i = 0; i<partsQuantity; i++)
        [winTest addObject:[NSNumber numberWithInt:0]];

   
    // Schedule a selector that is called every frame
    [self schedule:@selector(update:)];

    [[[CCDirector sharedDirector] touchDispatcher]  addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
}

- (void) onExit{
    [super onExit];
    
    // Remove the scheduled selector
    [self unscheduleAllSelectors];
}

- (void)selectObjectForTouch:(CGPoint)touchLocation {
    
    CCNode* child;
    
    for (child in self.children)
        if ((child.tag>0)&&(child.tag<=partsQuantity)&&(CGRectContainsPoint([child boundingBox], touchLocation))){
           
            selObject = child;
            //CCLOG(@"Child = %d",child.tag);
                PLAYSOUNDEFFECT(S1);
            
                tempZ = selObject.zOrder;
                [self.parent reorderChild:selObject z:100];
                
                xStart = selObject.position.x;
                yStart = selObject.position.y;
        
                CCSprite* tempSprite = (CCSprite*)[self getChildByTag:(selObject.tag+partsQuantity)];
                xTarget = tempSprite.position.x;
                yTarget = tempSprite.position.y;
                
                //CCLOG(@"%@",selObject);
                break;
            }
     
           
}

#pragma mark - Touch logic


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //CCLOG(@"touch started at: %f,%f", touchLocation.x, touchLocation.y);
    [self selectObjectForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (selObject){
        if ((abs(selObject.position.x - xTarget) < TOLERANCE) && (abs(selObject.position.y - yTarget) < TOLERANCE)) {
            id actionMove = [CCMoveTo actionWithDuration:0.3 position:ccp(xTarget,yTarget)];
            CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:actionMove period:0.6f];
            [selObject runAction:ease];
            [winTest replaceObjectAtIndex:selObject.tag-1 withObject:[NSNumber numberWithInt:1] ];
            //CCLOG(@"winTest after adding = %@", winTest);
        } else{
            id actionMove = [CCMoveTo actionWithDuration:0.6 position:ccp(xStart,yStart)];
            CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:actionMove period:0.6f];
            [selObject runAction:ease];
        }
        
        
        PLAYSOUNDEFFECT(S2);
        [self.parent reorderChild:selObject z:tempZ];
        selObject = NULL;
        //CCLOG(@"touch ended at: %f,%f", touchLocation.x, touchLocation.y);
        
        //check for the end
        int sum = 0;
        for( NSNumber *i in winTest)
        {
            sum = sum + [i intValue];
            //CCLOG(@"sum = %d", sum);
        }
        //CCLOG(@"winTest = %@", winTest);
        if ((!won)&&(sum  == partsQuantity))
        {
            won = TRUE;
            PLAYSOUNDEFFECT(S3);
            [[GameScene sharedScene] handleLevelComplete];
        }
    }
}


- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, winSize.width);
    retval.y = self.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (selObject) {
        CGPoint newPos = ccpAdd(selObject.position, translation);
        selObject.position = newPos;
    } else {
        // do nothing
    }
}




@end
