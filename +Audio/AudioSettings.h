#import <Foundation/Foundation.h>

@interface AudioSettings : NSObject

+(instancetype)sharedInstance;

-(void)outputToSpeaker;

-(void)setVolume:(float)volume;

-(float)getVolume;

@end
