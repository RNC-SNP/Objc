#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Recorder : NSObject<AVAudioRecorderDelegate>

-(instancetype)init;

-(void)start;

-(void)stop;

//-(NSURL*)URL;

-(NSData*)data;

-(void)dealloc;

@end
