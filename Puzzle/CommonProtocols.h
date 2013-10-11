//  CommonProtocols.h

#ifndef CommonProtocols_h
#define CommonProtocols_h

typedef enum {
    kNone,
    kHair,
    kEyebrow_left,
    kEyebrow_right,
    kEye_left,
    kEye_Right,
    kNose,
    kMouth,
    kHair_black,
    kEyebrow_left_black,
    kEyebrow_right_black,
    kEye_left_black,
    kEye_Right_black,
    kNose_black,
    kMouth_black
} SpriteType;

#define AUDIO_MAX_WAIT_TIME 150

typedef enum{
    kAudioManagerUnitialized = 0,
    kAudioManagerFailed = 1,
    kAudioManagerInitializing = 2,
    kAudioManagerInitialized = 100,
    kAudioManagerLoading = 200,
    kAudioManagerReady = 300
} GameManagerSoundState;

typedef enum {
    kNoSceneUninitialized = 0,
    kMainScene = 1,
} SceneTypes;

#define NumberOfParts 7
#define TOLERANCE 10.0

// Audio constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) [[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
#define STOPSOUNDEFFECT(...) [[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]

#endif
