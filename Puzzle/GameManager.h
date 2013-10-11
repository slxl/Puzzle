#import <Foundation/Foundation.h>
#import "CommonProtocols.h"
#import "SimpleAudioEngine.h"

@interface GameManager : NSObject{
    
    BOOL isMusicON;
    BOOL isSoundEffectsON;

    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}    

@property (readwrite) BOOL isMusicOn;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) GameManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

+(GameManager*)sharedGameManager;

-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;

@end;