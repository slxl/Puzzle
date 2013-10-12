
#import "LevelLayer.h"
#import "GameScene.h"

@implementation LevelLayer
{
    CCLayer* levelLayer;
    CCSprite* choosenElement;
    NSMutableArray *elementsState;              // depict the state of each element: 1 - placed, 0 - not yet
    
    int elementsQuantity;                          // amount of puzzle elements in current level
    BOOL won;
    int elementZOrder;
    
    CGPoint startPoint, targetPoint;
}

#pragma mark - Initialization

- (id) initWithLevel:(NSString*)level{
    self = [super init];
    if (self != nil) {
    
        // get level variables from plist
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LevelSettings.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDictionary *levelsDict = [NSDictionary dictionaryWithDictionary:[plistData objectForKey:@"Levels"]];
        NSDictionary *levelDict = [NSDictionary dictionaryWithDictionary:[levelsDict objectForKey:level]];
        
        elementsQuantity = [[levelDict objectForKey:@"elementsQuantity"] integerValue];
        won = FALSE;
        
        // array initialisation
        elementsState = [[NSMutableArray alloc] init];
        for(int i = 0; i < elementsQuantity; i++)
            [elementsState addObject:[NSNumber numberWithInt:0]];
        
        // load background
        CCSprite *background = [CCSprite spriteWithFile:[[levelDict objectForKey:@"bgImageName"] stringValue]];
        [background setAnchorPoint:ccp(0, 0)];
        background.position = ccp(0, 0);
        [self addChild:background z:0];
        
        // Load the level
        levelLayer = (CCLayer*)[CCBReader nodeGraphFromFile:level];
        [self addChild:levelLayer];
       
        // allow touches
        [[[CCDirector sharedDirector] touchDispatcher]  addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}


- (void) onEnter{
    [super onEnter];
}

- (void) onExit{
    [super onExit];
}


#pragma mark - Touch logic

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    for (CCNode* child in self.children)
        if ((child.tag > 0) && (child.tag <= elementsQuantity) && (CGRectContainsPoint([child boundingBox], touchLocation))){
            
            choosenElement = (CCSprite*)child;
            PLAYSOUNDEFFECT(S1);
            
            elementZOrder = choosenElement.zOrder;
            [self.parent reorderChild:choosenElement z:100];
            
            startPoint = choosenElement.position;
            
            CCSprite* tempSprite = (CCSprite*)[self getChildByTag:(choosenElement.tag+elementsQuantity)];
            
            targetPoint = tempSprite.position;
            break;
        }
    
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint currentTouchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
#warning try to simplify this
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];

    CGPoint offset = ccpSub(currentTouchLocation, oldTouchLocation);
    if (choosenElement) {
        choosenElement.position = ccpAdd(choosenElement.position, offset);;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (choosenElement){
        if ((abs(choosenElement.position.x - targetPoint.x) < TOLERANCE) && (abs(choosenElement.position.y - targetPoint.y) < TOLERANCE)) {
            id actionMove = [CCMoveTo actionWithDuration:0.3 position:targetPoint];
            CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:actionMove period:0.6f];
            [choosenElement runAction:ease];
            [elementsState replaceObjectAtIndex:choosenElement.tag-1 withObject:[NSNumber numberWithInt:1] ];
            //CCLOG(@"elementsState after adding = %@", elementsState);
        } else{
            id actionMove = [CCMoveTo actionWithDuration:0.6 position:startPoint];
            CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:actionMove period:0.6f];
            [choosenElement runAction:ease];
        }
        
        
        PLAYSOUNDEFFECT(S2);
        [self.parent reorderChild:choosenElement z:elementZOrder];
        choosenElement = NULL;
        
        //check for the end
        int sum = 0;
        for(NSNumber *i in elementsState)
            sum = sum + [i intValue];

        if ((!won) && (sum == elementsQuantity))
        {
            won = TRUE;
            PLAYSOUNDEFFECT(S3);
            [[GameScene sharedScene] handleLevelComplete];
        }
    }
}

#warning delete
- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, winSize.width);
    retval.y = self.position.y;
    return retval;
}


@end
