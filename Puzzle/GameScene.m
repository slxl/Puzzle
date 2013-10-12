#import "GameScene.h"
#import "CCBAnimationManager.h"

static GameScene* sharedScene;

@implementation GameScene

+ (GameScene*) sharedScene
{
    return sharedScene;
}

- (void) pressedReplay:(id)sender
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"];
    PLAYSOUNDEFFECT(S2);
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void) didLoadFromCCB
{
    sharedScene = self;
    
    // Load the level
    level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
    animationManager = level.userObject;

    // And add it to the game scene
    [levelLayer addChild:level];
}

- (void) handleLevelComplete
{
    //NSLog(@"animationManager: %@", animationManager);
    [animationManager runAnimationsForSequenceNamed:@"win"];
}

@end
