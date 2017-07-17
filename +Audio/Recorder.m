#import "Recorder.h"

@interface Recorder()
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSMutableDictionary* settings;
@end

@implementation Recorder

-(instancetype)init {
    if (self = [super init]) {
        _settings = [[NSMutableDictionary alloc] init];
        [_settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [_settings setValue:[NSNumber numberWithFloat:16000.0f] forKey:AVSampleRateKey];
        //[_settings setValue:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [_settings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [_settings setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
        [_settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [_settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    return self;
}

-(void)dealloc {
    if (_recorder) {
        [_recorder deleteRecording];
    }
}

-(NSURL*)URL {
    return _recorder ? _recorder.url : nil;
}

-(NSData*)data {
    if (!_recorder) return nil;
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:_recorder.url options:NSDataReadingUncached error:&err];
    if (err) {
        NSLog(@"Recorder readData failed: %@", err.localizedDescription);
    }
    return data;
}

- (AVAudioSession*)activeSession{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError *err;
    if (![session setCategory:AVAudioSessionCategoryRecord /*withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker*/ error:&err]) {
        NSLog(@"Recorder setSessionCategory error: %@", err.localizedFailureReason);
    }
    if (![session setMode:AVAudioSessionModeSpokenAudio error:&err]) {
        NSLog(@"Recorder setSessionMode failed: %@", err.localizedFailureReason);
    }
    [session setActive:YES error:&err];
    if (err) {
        NSLog(@"Recorder setSessionActive failed: %@", err.localizedFailureReason);
    }
    return session;
}

-(void)start {
    [[self activeSession]requestRecordPermission:^(BOOL granted) {
        BOOL success = NO;
        if (granted) {
            [self stop];
            NSError *err;
            if (_recorder != nil) [_recorder deleteRecording];
            _recorder = [[AVAudioRecorder alloc] initWithURL:[self newUrl] settings:_settings error:&err];
            if (err) {
                NSLog(@"Recorder init failed: %@", err.localizedDescription);
            }
            _recorder.delegate = self;
            success = [_recorder record];
        } else {
            NSLog(@"Recorder permission not granted");
        }
    }];
}

-(NSURL*)newUrl {
    long timestamp = [[NSDate date] timeIntervalSince1970];
    NSString* timestampStr = [NSString stringWithFormat:@"%ld.wav", timestamp];
    NSString* dir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* path = [dir stringByAppendingPathComponent:timestampStr];
    return [NSURL fileURLWithPath:path];
}

-(void)stop {
    if (_recorder && _recorder.isRecording) {
        [_recorder stop];
        NSLog(@"Recorder stopped");
    }
}

-(void)deleteFile {
    if (_recorder) {
        [_recorder deleteRecording];
    }
}

# pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)flag {
    NSLog(@"Recorder finished: %d", flag);
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"Recorder encode Error: %@", error.localizedDescription);
}

@end
