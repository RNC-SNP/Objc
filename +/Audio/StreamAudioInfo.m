#import "StreamAudioInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+AFNetworking.h"

@interface StreamAudioInfo()
@property (nonatomic,strong) MPMediaItemArtwork* artwork;
@end

@implementation StreamAudioInfo

-(void)setNowPlayingWithDuration:(NSTimeInterval)duration {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        
        if (_artwork == nil && _coverUrl != nil) {
            _artwork = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_coverUrl]]]];
        }
        
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              _artist, MPMediaItemPropertyArtist,
                              _title, MPMediaItemPropertyTitle,
                              _album, MPMediaItemPropertyAlbumTitle,
                              _artwork, MPMediaItemPropertyArtwork,
                              [NSNumber numberWithDouble:duration], MPMediaItemPropertyPlaybackDuration,
                              [NSNumber numberWithDouble:1.0], MPNowPlayingInfoPropertyPlaybackRate,
                              nil];
        center.nowPlayingInfo = info;
    }
}

@end
