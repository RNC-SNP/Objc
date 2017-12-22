#import <Foundation/Foundation.h>
#import "StreamAudioPlayer.h"
#import "StreamAudioInfo.h"

#define EXTREN_STR extern NSString* const

EXTREN_STR NOTIFY_STREAM_AUDIO_PLAYER;
EXTREN_STR EXTRA_ACTION;
EXTREN_STR EXTRA_GROUP_ID;
EXTREN_STR EXTRA_ITEM_INDEX;
EXTREN_STR ACTION_STARTED;
EXTREN_STR ACTION_PAUSED;
EXTREN_STR ACTION_RESUMED;
EXTREN_STR ACTION_RESTARTED;
EXTREN_STR ACTION_CANCELED;
EXTREN_STR ACTION_FAILED;
EXTREN_STR ACTION_PREPARING;
EXTREN_STR ACTION_PREPARED;
EXTREN_STR ACTION_BUFFERING;
EXTREN_STR ACTION_PROGRESS_CHANGED;
EXTREN_STR ACTION_FINISHED;

@interface GlobalStreamAudioPlayer : NSObject

+(instancetype)sharedInstance;

@property (nonatomic,assign) BOOL isAlbum;

-(void)addAudioInfoArray:(NSArray<StreamAudioInfo*>*)audioInfoArray withGroupId:(NSInteger)groupId;

-(void)clickAtGroupId:(NSInteger)groupId ItemIndex:(NSInteger)itemIndex;

-(void)clickAtItemIndex:(NSInteger)itemIndex;

-(void)click;

-(NSInteger)totalTime;

-(NSInteger)currentTime;

-(StreamAudioPlayerStatus)status;

-(NSInteger)currentGroupId;

-(NSInteger)currentItemIndex;

-(void)seekToTime:(NSUInteger)time;

-(void)prev;

-(void)next;

-(void)pause;

-(void)resume;

-(void)destroy;

-(NSInteger)firstItemIndex;

-(NSInteger)lastItemIndex;

-(StreamAudioInfo*)nowPlayingAudioInfo;

-(void)handleRemoteControlEvent:(UIEvent*)event;

@end
