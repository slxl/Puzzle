#import "GameScene.h"
#import "CCBAnimationManager.h"

static GameScene* sharedScene;

@implementation GameScene

+ (GameScene*) sharedScene
{
    return sharedScene;
}

+(CCScene*)sceneWithLevel:(NSString*)levelID{
    return  [[[self alloc] initWithLevel:levelID] autorelease];
}

- (id) initWithLevel:(NSString*)levelID{
    self = [super init];
    if (self != nil){
        
        // LOAD SPRITESHEET
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"BitmapAtlas.plist"];
//        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"BitmapAtlas.png"];
//        [self addChild:spriteSheet];
        
        CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", levelID ]];
        [background setAnchorPoint:ccp(0,0)];
        [background setPosition:ccp(0,0)];
        [self addChild:background z:-1];
        
        levelLayer = (LevelLayer*)[CCBReader nodeGraphFromFile:[NSString stringWithFormat:@"%@.ccbi", levelID ]];
        [self addChild:levelLayer];
        
        gameControlsLayer = [GameControlsLayer node];
        [self addChild:gameControlsLayer];
    }
    return self;
}

#warning replace L101 with levelID
- (void) pressedReplay:(id)sender
{
    PLAYSOUNDEFFECT(S2);
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:@"L101"]];
}

- (void) didLoadFromCCB
{
//    sharedScene = self;
//    
//    // Load the level
//    level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
//    animationManager = level.userObject;
//
//    // And add it to the game scene
//   [self addChild:level];

}



@end
