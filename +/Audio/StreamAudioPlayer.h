#import <Foundation/Foundation.h>

@protocol StreamAudioPlayerDelegate <NSObject>

@required
-(void)onFailed;

@required
-(void)onPreparing;

@required
-(void)onBuffering;

@required
-(void)onProgressChanged;

@required
-(void)onFinished;

@end

@interface StreamAudioPlayer : NSObject

typedef enum Status {
    STREAM_AUDIO_PLAYER_STATUS_INIT,
    STREAM_AUDIO_PLAYER_STATUS_ERROR,
    STREAM_AUDIO_PLAYER_STATUS_PREPARING,
    STREAM_AUDIO_PLAYER_STATUS_PLAYING,
    STREAM_AUDIO_PLAYER_STATUS_PAUSED,
    STREAM_AUDIO_PLAYER_STATUS_FINISHED,
    STREAM_AUDIO_PLAYER_STATUS_CANCELED
}StreamAudioPlayerStatus;

@property (nonatomic,weak) id<StreamAudioPlayerDelegate> delegate;
@property (nonatomic,assign) BOOL loop;

-(instancetype)initWithUrl:(NSString*)url;

-(void)start;

-(void)pause;

-(void)resume;

-(void)restart;

-(void)destroy;

-(NSInteger)totalTime;

-(NSInteger)currentTime;

-(void)seekToTime:(NSInteger)time autoPlay:(BOOL)autoPlay;

-(StreamAudioPlayerStatus)status;

@end
