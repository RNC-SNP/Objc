#import "StreamAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface StreamAudioPlayer()
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, assign) StreamAudioPlayerStatus status;
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic, assign) NSTimeInterval lastStop;
@end

@implementation StreamAudioPlayer

-(instancetype)init {
    if (self == [super init]) {
        _player = [AVPlayer new];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishPlaying)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_player currentItem]];
        [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
    }
    return self;
}

-(void)loadUrl:(NSString*)url {
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    [_player replaceCurrentItemWithPlayerItem:playerItem];
    _status = StreamAudioPlayerStatusInit;
}

-(void)start {
    if (_status == STREAM_AUDIO_PLAYER_STATUS_INIT || _status == STREAM_AUDIO_PLAYER_STATUS_PREPARING) {
        if (_player.status == AVPlayerStatusReadyToPlay && _player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self play];
            [self checkProgress];
            NSLog(@"StreamAudioPlayer started");
        } else if (_player.status == AVPlayerStatusUnknown || _player.currentItem.status == AVPlayerItemStatusUnknown) {
            _status = STREAM_AUDIO_PLAYER_STATUS_PREPARING;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self start];
            });
            if (_delegate != nil) {
                [_delegate onPreparing];
            }
            NSLog(@"StreamAudioPlayer preparing...");
        } else {
            [self onError];
        }
    }
}

-(void)pause {
    if (_status == STREAM_AUDIO_PLAYER_STATUS_PLAYING) {
        _status = STREAM_AUDIO_PLAYER_STATUS_PAUSED;
        [_player setRate:0.0];
        NSLog(@"StreamAudioPlayer paused");
    }
}

-(void)resume {
    if (_status == STREAM_AUDIO_PLAYER_STATUS_PAUSED) {
        [self activeSession];
        [_player setRate:1.0];
        _status = STREAM_AUDIO_PLAYER_STATUS_PLAYING;
        NSLog(@"StreamAudioPlayer resumed");
    }
}

-(void)restart {
    if (_status == STREAM_AUDIO_PLAYER_STATUS_PLAYING || _status == STREAM_AUDIO_PLAYER_STATUS_PAUSED || _status == STREAM_AUDIO_PLAYER_STATUS_FINISHED) {
        [self seekToTime:0 autoPlay:YES];
    }
}

-(void)destroy {
    if (_status < STREAM_AUDIO_PLAYER_STATUS_DESTROYED && _player != nil) {
        [_player replaceCurrentItemWithPlayerItem:nil];
        [_player removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        _status = STREAM_AUDIO_PLAYER_STATUS_DESTROYED;
        NSLog(@"StreamAudioPlayer destroyed");
    }
}

-(NSInteger)totalTime {
    if (_player != nil && _player.currentItem != nil) {
        return CMTimeGetSeconds(_player.currentItem.duration);
    }
    return -1;
}

-(NSInteger)currentTime {
    if (_player != nil && _player.currentItem != nil) {
        return CMTimeGetSeconds(_player.currentItem.currentTime);
    }
    return -1;
}

-(void)seekToTime:(NSInteger)time autoPlay:(BOOL)autoPlay {
    if (_player != nil && _player.currentItem != nil) {
        time = MIN([self totalTime], MAX(0, time));
        if ([self currentTime] != time) {
            CMTime cmTime = CMTimeMakeWithSeconds(time, _player.currentItem.currentTime.timescale);
            [_player seekToTime:cmTime];
            [_player.currentItem seekToTime:cmTime];
            if (autoPlay && _status != STREAM_AUDIO_PLAYER_STATUS_PLAYING) {
                [self play];
            }
        }
    }
}

-(StreamAudioPlayerStatus)status {
    return _status;
}

-(void)dealloc {
    [self destroy];
    [super dealloc];
}

-(void)activeSession {
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* err;
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&err];
    if (err) {
        //NSLog(@"StreamAudioPlayer setSessionCategory error: %@", err.localizedDescription);
    }
    [session setActive:YES error:&err];
    if (err) {
        //NSLog(@"StreamAudioPlayer setSessionActive error: %@", err.localizedDescription);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerStatusFailed) {
            [self onError];
        } else if (_player.status == AVPlayerStatusReadyToPlay) {
            //NSLog(@"StreamAudioPlayer status: ReadyToPlay");
        } else if (_player.status == AVPlayerItemStatusUnknown) {
            //NSLog(@"StreamAudioPlayer status: preparing");
        }
    }
}

-(void)didFinishPlaying {
    BOOL success = _status == STREAM_AUDIO_PLAYER_STATUS_PLAYING && [self currentTime] == [self totalTime];
    if (success) {
        _status = STREAM_AUDIO_PLAYER_STATUS_FINISHED;
        if (_delegate != nil) {
            [_delegate onFinished];
        }
        NSLog(@"StreamAudioPlayer finished");
    } else {
        [self onError];
    }
    if (success && _loop) {
        [self restart];
    }
}

-(void)checkProgress {
    if (_status >= STREAM_AUDIO_PLAYER_STATUS_PLAYING && _status < STREAM_AUDIO_PLAYER_STATUS_DESTROYED) {
        NSTimeInterval currentTimeMills = [[NSDate date] timeIntervalSince1970];
        NSInteger currentTime = [self currentTime];
        NSInteger totalTime = [self totalTime];
        if (currentTime != _lastTime) {
            _lastStop = 0;
            if (_delegate != nil) {
                [_delegate onProgressChanged];
            }
            NSLog(@"StreamAudioPlayer progress: %ld/%ld", currentTime, totalTime);
        } else {
            if (_status == STREAM_AUDIO_PLAYER_STATUS_PLAYING && currentTime < totalTime
                && (_lastStop > 0 && currentTimeMills - _lastStop > 1.0)) {
                if (_delegate != nil) {
                    [_delegate onBuffering];
                }
                NSLog(@"StreamAudioPlayer buffering...");
            }
            if (_lastStop == 0) {
                _lastStop = currentTimeMills;
            }
        }
        _lastTime = currentTime;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkProgress];
        });
    }
}

-(void)play {
    [self activeSession];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [_player playImmediatelyAtRate:1.0];
    } else {
        [_player play];
    }
    _status = STREAM_AUDIO_PLAYER_STATUS_PLAYING;
}

-(void)onError {
    _status = STREAM_AUDIO_PLAYER_STATUS_ERROR;
    if (_delegate != nil) {
        [_delegate onFailed];
    }
    NSLog(@"StreamAudioPlayer failed");
}

@end
