#import "AudioSettings.h"

#import <MediaPlayer/MPVolumeView.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>

static AudioSettings *sharedObj = nil;

@interface AudioSettings()
@property (nonatomic,retain) MPVolumeView* volumeView;
@property (nonatomic,retain) UISlider* volumeSlider;
@end

@implementation AudioSettings

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedObj == nil)
            sharedObj = [[AudioSettings alloc] init];
    });
    return sharedObj;
}

-(instancetype)init {
    if (self = [super init]) {
        _volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider*)view;
                break;
            }
        }
    }
    return self;
}

-(void)outputToSpeaker {
    //UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    //AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

-(void)vibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)setVolume:(float)volume {
    if (_volumeSlider != nil) {
        [_volumeSlider setValue:MAX(0, MIN(volume, 1.0f))];
    }
}

-(float)getVolume {
    if (_volumeSlider != nil) {
        return [_volumeSlider value];
    }
    return 0;
}

@end
