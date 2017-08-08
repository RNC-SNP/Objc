#import <Foundation/Foundation.h>

@interface AudioSettings : NSObject

+(instancetype)sharedInstance;

-(void)outputToSpeaker;

-(void)vibrate;

-(void)setVolume:(float)volume;

-(float)getVolume;

@end
