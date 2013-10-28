//
//  LevelSelectionScene.m
//  Puzzle
//
//  Created by slava on 14.10.13.
//  Copyright 2013 Vyacheslav Khlichkin. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "CCScrollLayer.h"
#import "GameScene.h"

static LevelSelectionScene* sharedScene;

@implementation LevelSelectionScene

+ (LevelSelectionScene*) sharedScene
{
    return sharedScene;
}

+(CCScene*)scene {
    return  [[[self alloc] init] autorelease];
}

-(id) init{
    self = [super init];
    if (self != nil){
    
        // get screen size
        CGSize screenSize = [CCDirector sharedDirector].winSize;

        // create a blank layer for page 1
        CCLayer *pageOne = [[CCLayer alloc] init];
        
       
        CCMenuItem *packOneButton = [CCMenuItemImage
                                     itemWithNormalImage:@"face.png"
                                     selectedImage:@"face.png"
                                     target:self
                                     selector:@selector(startGame)];
        packOneButton.scale = 0.3;
        packOneButton.position = ccp(0, 0);
        packOneButton = [CCMenu menuWithItems:packOneButton, nil];
        [pageOne addChild:packOneButton];
    
        
        CCLayer *pageTwo = [[CCLayer alloc] init];
        
        CCMenuItem *packTwoButton = [CCMenuItemImage
                                     itemWithNormalImage:@"face.png"
                                     selectedImage:@"face.png"
                                     target:self
                                     selector:@selector(startGame)];
        packTwoButton.scale = 0.2;
        packTwoButton.position = ccp(0, 0);
        packTwoButton = [CCMenu menuWithItems:packTwoButton, nil];
        // add menu to page 2
        [pageTwo addChild:packTwoButton];
        
        CCLayer *pageThree = [[CCLayer alloc] init];
        
        CCMenuItem *packThreeButton = [CCMenuItemImage
                                     itemWithNormalImage:@"face.png"
                                     selectedImage:@"face.png"
                                     target:self
                                     selector:@selector(startGame)];
        packThreeButton.scale = 0.4;
        packThreeButton.position = ccp(0, 0);
        packThreeButton = [CCMenu menuWithItems:packThreeButton, nil];
        // add menu to page 2
        [pageThree addChild:packThreeButton];
        
        // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: pageOne,pageTwo,pageThree, nil] widthOffset: screenSize.width/2];
        
        // finally add the scroller to your scene
        [self addChild:scroller];
        
        sharedScene = self;
        
        
        
    }
    return self;
}

-(void) startGame{
    
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene: [GameScene sceneWithLevel:@"L101"] withColor:ccWHITE]];
    
}

@end
