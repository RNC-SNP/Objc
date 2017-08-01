#import <Foundation/Foundation.h>

@interface StreamAudioInfo : NSObject

@property (nonatomic,copy) NSString* artist;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* album;
@property (nonatomic,copy) NSString* sourceUrl;
@property (nonatomic,copy) NSString* coverUrl;

-(void)setNowPlayingWithDuration:(NSTimeInterval)duration;

@end
