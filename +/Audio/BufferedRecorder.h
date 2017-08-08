#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

static const int NUM_BUFFERS = 3;
static const int BUFFER_SIZE = 16000;

typedef struct {
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    UInt32 bufferByteSize; 
    AudioFileID audioFile;
    SInt64 currentPacket;
    bool working;
} RecordState;

@interface BufferedRecorder : NSObject
{
    RecordState recordState;
    CFURLRef mFileURL;
}

-(NSError*)start;

-(BOOL)pause;

-(BOOL)resume;

-(NSData*)stop;

-(BOOL)isRecording;

@end
