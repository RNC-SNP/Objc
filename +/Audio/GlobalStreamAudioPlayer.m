#import "GlobalStreamAudioPlayer.h"
#import "StreamAudioInfo.h"
#import <AVFoundation/AVFoundation.h>

@interface GlobalStreamAudioPlayer()<StreamAudioPlayerDelegate>
@property (nonatomic,strong) StreamAudioPlayer* player;
@property (nonatomic,strong) NSMutableDictionary* audioInfoDict;
@property (nonatomic,assign) NSInteger currentGroupId;
@property (nonatomic,assign) NSInteger currentItemIndex;
@property (nonatomic,strong) AVAudioSession* session;
@property (nonatomic,assign) BOOL interrupted;
@end

static GlobalStreamAudioPlayer* instance;

@implementation GlobalStreamAudioPlayer

NSString* const NOTIFY_STREAM_AUDIO_PLAYER = @"NOTIFY_STREAM_AUDIO_PLAYER";
NSString* const EXTRA_ACTION = @"EXTRA_ACTION";
NSString* const EXTRA_GROUP_ID = @"EXTRA_GROUP_ID";
NSString* const EXTRA_ITEM_INDEX = @"EXTRA_ITEM_INDEX";
NSString* const ACTION_STARTED = @"ACTION_STARTED";
NSString* const ACTION_PAUSED = @"ACTION_PAUSED";
NSString* const ACTION_RESUMED = @"ACTION_RESUMED";
NSString* const ACTION_RESTARTED = @"ACTION_RESTARTED";
NSString* const ACTION_DESTROYED = @"ACTION_CANCELED";
NSString* const ACTION_FAILED = @"ACTION_FAILED";
NSString* const ACTION_PREPARING = @"ACTION_PREPARING";
NSString* const ACTION_PREPARED = @"ACTION_PREPARED";
NSString* const ACTION_BUFFERING = @"ACTION_BUFFERING";
NSString* const ACTION_PROGRESS_CHANGED = @"ACTION_PROGRESS_CHANGED";
NSString* const ACTION_FINISHED = @"ACTION_FINISHED";

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[GlobalStreamAudioPlayer alloc]init];
        }
    });
    return instance;
}

-(instancetype)init {
    if (self = [super init]) {
        _audioInfoDict = [[NSMutableDictionary alloc]init];
        _currentGroupId = -1;
        _currentItemIndex = -1;
        
        _session = [AVAudioSession sharedInstance];
        [_session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                        error:nil];
        [_session setMode:AVAudioSessionModeDefault error:nil];
        [_session setActive:YES error:nil];
        
        _player = [StreamAudioPlayer new];
        
        [self observeAudioSessionNotification:AVAudioSessionInterruptionNotification Selector:@selector(handleAudioSessionInterruption:)];
        [self observeAudioSessionNotification:AVAudioSessionRouteChangeNotification Selector:@selector(handleAudioSessionRouteChanged:)];
        [self observeAudioSessionNotification:AVAudioSessionMediaServicesWereResetNotification Selector:@selector(handleAudioSessionMediaServicesReset:)];
        [self observeAudioSessionNotification:AVAudioSessionMediaServicesWereLostNotification Selector:@selector(handleAudioSessionMediaServicesLost:)];
    }
    return self;
}

-(void)observeAudioSessionNotification:(NSString*)notify Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notify object:_session];
}

-(NSString*)keyWithGroupId:(NSUInteger)groupId {
    return [NSString stringWithFormat:@"%d", groupId];
}

-(void)addAudioInfoArray:(NSArray<StreamAudioInfo*>*)audioInfoArray withGroupId:(NSInteger)groupId {
    NSString* key = [self keyWithGroupId:groupId];
    if ([_audioInfoDict valueForKey:key] == nil) {
        [_audioInfoDict setValue:audioInfoArray forKey:key];
        [self clickAtGroupId:groupId ItemIndex:0];
    }
}

-(void)clickAtGroupId:(NSInteger)groupId ItemIndex:(NSInteger)itemIndex {
    NSMutableArray* array = [_audioInfoDict valueForKey:[self keyWithGroupId:groupId]];
    StreamAudioInfo* audioInfo = [array objectAtIndex:itemIndex];
    if (_currentGroupId == groupId && _currentItemIndex == itemIndex) {
        StreamAudioPlayerStatus status = [_player status];
        if (status == StreamAudioPlayerStatusInit) {
            [_player start];
            [self notifyAction:ACTION_STARTED];
        } else if (status == StreamAudioPlayerStatusPreparing || status == StreamAudioPlayerStatusPlaying) {
            [_player pause];
            [self notifyAction:ACTION_PAUSED];
        } else if (status == StreamAudioPlayerStatusPaused) {
            [_player resume];
            [self notifyAction:ACTION_RESUMED];
        } else if (status == StreamAudioPlayerStatusFinished) {
            [_player restart];
            [self notifyAction:ACTION_RESTARTED];
        } else if (status == StreamAudioPlayerStatusError) {
            //TODO
        }
    } else {
        [self notifyAction:ACTION_CANCELED];
        _currentGroupId = groupId;
        _currentItemIndex = itemIndex;
        [_player loadUrl:audioInfo.sourceUrl];
        _player.delegate = self;
        [_player start];
        [self notifyAction:ACTION_STARTED];
    }
}

-(void)clickAtItemIndex:(NSInteger)itemIndex {
    [self clickAtGroupId:_currentGroupId ItemIndex:itemIndex];
}

-(void)click {
    [self clickAtItemIndex:_currentItemIndex];
}

-(NSInteger)totalTime {
    if (_player != nil) {
        return [_player totalTime];
    }
    return -1;
}

-(NSInteger)currentTime {
    if (_player != nil) {
        return [_player currentTime];
    }
    return -1;
}

-(void)seekToTime:(NSUInteger)time {
    if (_player != nil) {
        [_player seekToTime:time autoPlay:[_player status] == StreamAudioPlayerStatusPlaying];
    }
}

-(StreamAudioPlayerStatus)status {
    if (_player != nil) {
        return [_player status];
    }
    return StreamAudioPlayerStatusError;
}

-(NSInteger)currentGroupId {
    return _currentGroupId;
}

-(NSInteger)currentItemIndex {
    return _currentItemIndex;
}

-(NSArray*)currentArray {
    return [_audioInfoDict objectForKey:[self keyWithGroupId:_currentGroupId]];
}

-(void)notifyAction:(NSString*)action {
    NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
    [data setValue:action forKey:EXTRA_ACTION];
    [data setValue:[NSNumber numberWithLong:_currentGroupId] forKey:EXTRA_GROUP_ID];
    [data setValue:[NSNumber numberWithLong:_currentItemIndex] forKey:EXTRA_ITEM_INDEX];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_STREAM_AUDIO_PLAYER object:self userInfo:data];
}

-(void)prev {
    NSInteger first = [self firstItemIndex], last = [self lastItemIndex];
    if (_currentItemIndex > first) {
        [self clickAtItemIndex:_currentItemIndex - 1];
    } else {
        if (last > first) {
            [self clickAtItemIndex:last];
        } else {
            [_player restart];
            [self notifyAction:ACTION_RESTARTED];
        }
    }
}

-(void)next {
    NSInteger first = [self firstItemIndex], last = [self lastItemIndex];
    if (_currentItemIndex < last) {
        [self clickAtItemIndex:_currentItemIndex + 1];
    } else {
        if (last > first) {
            [self clickAtItemIndex:first];
        } else {
            [_player restart];
            [self notifyAction:ACTION_RESTARTED];
        }
    }
}

-(NSInteger)firstItemIndex {
    if (_isAlbum) {
        NSArray* audioInfoArray = [self currentArray];
        for (NSInteger i = _currentItemIndex; i > 0; i--) {
            if (![((StreamAudioInfo*)[audioInfoArray objectAtIndex:i]).album isEqualToString:((StreamAudioInfo*)[audioInfoArray objectAtIndex:_currentItemIndex]).album]) {
                return i + 1;
            }
        }
    }
    return 0;
}

-(NSInteger)lastItemIndex {
    NSArray* audioInfoArray = [self currentArray];
    if (_isAlbum) {
        for (NSInteger i = _currentItemIndex; i < audioInfoArray.count; i++) {
            if (![((StreamAudioInfo*)[audioInfoArray objectAtIndex:i]).album isEqualToString:((StreamAudioInfo*)[audioInfoArray objectAtIndex:_currentItemIndex]).album]) {
                return i - 1;
            }
        }
    }
    return audioInfoArray.count - 1;
}

-(void)pause {
    if (_player != nil && [_player status] == StreamAudioPlayerStatusPlaying) {
        [self click];
    }
}

-(void)resume {
    if (_player != nil && [_player status] == StreamAudioPlayerStatusPaused) {
        [self click];
    }
}

-(void)destroy {
    if (_player != nil && [_player status] == StreamAudioPlayerStatusPlaying) {
        [_player destroy];
        _player = nil;
    }
    if ([_audioInfoDict count] > 0) {
        [_audioInfoDict removeAllObjects];
    }
    _currentGroupId = -1;
    _currentItemIndex = -1;
}

-(StreamAudioInfo*)nowPlayingAudioInfo {
    return [[self currentArray] objectAtIndex:_currentItemIndex];
}

-(void)handleRemoteControlEvent:(UIEvent*)event {
    if (_player != nil && event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                [self click];
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                [self resume];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self pause];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [self prev];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [self next];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark StreamAudioPlayerDelegate

-(void)onFailed {
    [self notifyAction:ACTION_FAILED];
    [self next];
}

-(void)onPreparing {
    [self notifyAction:ACTION_PREPARING];
}

-(void)onPrepared {
    StreamAudioInfo* audioInfo = [[self currentArray] objectAtIndex:_currentItemIndex];
    [audioInfo setNowPlayingWithDuration:[_player totalTime]];
}

-(void)onBuffering {
    [self notifyAction:ACTION_BUFFERING];
}

-(void)onProgressChanged {
    [self notifyAction:ACTION_PROGRESS_CHANGED];
}

-(void)onFinished {
    [self notifyAction:ACTION_FINISHED];
    [self next];
}

#pragma mark Handle Interrupt & Reset

-(void)handleAudioSessionInterruption:(NSNotification*)notification {
    NSNumber* type = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber* option = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    switch(type.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan: {
            [self handleAudioSessionInteruption];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded: {
            switch (option.unsignedIntegerValue) {
                case AVAudioSessionInterruptionOptionShouldResume: {
                    [self resumeAudioSessionInterruption];
                    break;
                }
            }
        }
    }
}

-(void)handleAudioSessionMediaServicesReset:(NSNotification*)notification {
    //Audio streaming objects are invalidated (zombies)
    //Handle this notification by fully reconfiguring audio
}

-(void)handleAudioSessionMediaServicesLost:(NSNotification*)notification {
    //TODO
}

-(void)handleAudioSessionRouteChanged:(NSNotification*)notification {
    NSNumber *reason = [notification.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey];
    switch (reason.unsignedIntegerValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
            break;
        }
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            [self handleAudioSessionInteruption];
            break;
        }
        case AVAudioSessionRouteChangeReasonWakeFromSleep: {
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange: {
            break;
        }
        case AVAudioSessionRouteChangeReasonOverride: {
            break;
        }
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange: {
            break;
        }
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory: {
            break;
        }
        case AVAudioSessionRouteChangeReasonUnknown: {
            break;
        }
    }
}

-(void)handleAudioSessionInteruption {
    if (_player != nil) {
        StreamAudioPlayerStatus status = [_player status];
        if (status == StreamAudioPlayerStatusPreparing || status == StreamAudioPlayerStatusPlaying) {
            [self pause];
            _interrupted = true;
        }
    }
    [_session setActive:NO error:nil];
}

-(void)resumeAudioSessionInterruption {
    [_session setActive:YES error:nil];
    if (_interrupted) {
        [self resume];
        _interrupted = NO;
    }
}

@end
