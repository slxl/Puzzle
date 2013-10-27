
#import "LevelLayer.h"
#import "GameScene.h"

@implementation LevelLayer
{
    CCSprite* choosenElement;
    NSMutableArray *elementsState;              // depict the state of each element: 1 - placed, 0 - not yet
    
    BOOL won;
    int elementZOrder;
    
    CGPoint startPoint, targetPoint;
}

@synthesize elementsQuantity, levelID;


#pragma mark - Initialization

- (id) init{
    self = [super init];
    if (self != nil) {
        // this is 14:43 version
        
        //change 1
        
        // get level variables from plist
//        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LevelSettings.plist"];
//        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
//        NSDictionary *levelsDict = [NSDictionary dictionaryWithDictionary:[plistData objectForKey:@"Levels"]];
//        NSDictionary *levelDict = [NSDictionary dictionaryWithDictionary:[levelsDict objectForKey:level]];
//        
    }
    return self;
}


- (void) onEnter{
    [super onEnter];
    
    won = FALSE;
    animationManager = [self userObject];
    
    // array initialisation
    elementsState = [[NSMutableArray alloc] init];
    for(int i = 0; i < elementsQuantity; i++)
        [elementsState addObject:[NSNumber numberWithInt:0]];
    // allow touches
    [self schedule:@selector(update:)];
    [[[CCDirector sharedDirector] touchDispatcher]  addTargetedDelegate:self priority:0 swallowsTouches:YES];

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
            [self reorderChild:choosenElement z:100];
            
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
//      if ((abs(choosenElement.position.x - targetPoint.x) < TOLERANCE) && (abs(choosenElement.position.y - targetPoint.y) < TOLERANCE)) {
        if (ccpDistance(choosenElement.position, targetPoint) < TOLERANCE){
            id actionMove = [CCMoveTo actionWithDuration:0.3 position:targetPoint];
            CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:actionMove period:0.6f];
            [choosenElement runAction:ease];
            [elementsState replaceObjectAtIndex:choosenElement.tag-1 withObject:[NSNumber numberWithInt:1] ];
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
            [self handleLevelComplete];
        }
    }
}

- (void) handleLevelComplete
{
    //NSLog(@"animationManager: %@", animationManager);
    [animationManager runAnimationsForSequenceNamed:@"win"];
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
