#import "BufferedRecorder.h"

void AudioInputCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp* inStartTime,
                        UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription* inPacketDescs) {
    RecordState* recordState = (RecordState*)inUserData;
    
    if (inNumberPacketDescriptions == 0 && recordState->dataFormat.mBytesPerPacket != 0) {
        inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / recordState->dataFormat.mBytesPerPacket;
    }
    
    OSStatus status = AudioFileWritePackets(recordState->audioFile, false, inBuffer->mAudioDataByteSize, inPacketDescs,
                                            recordState->currentPacket, &inNumberPacketDescriptions, inBuffer->mAudioData);
    if (status == 0) {
        recordState->currentPacket += inNumberPacketDescriptions;
        if (!recordState->working) return;
        //TODO: handle buffer data
        AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
    }
}

void DeriveBufferSize(AudioQueueRef audioQueue, AudioStreamBasicDescription ASBDescription, Float64 seconds, UInt32 *outBufferSize) {
    static const int maxBufferSize = 0x50000;
    int maxPacketSize = ASBDescription.mBytesPerPacket;
    if (maxPacketSize == 0) {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioQueue, kAudioConverterPropertyMaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize);
    }
    
    Float64 numBytesForTime = ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize = (UInt32)((numBytesForTime < maxBufferSize) ? numBytesForTime : maxBufferSize);
}

@implementation BufferedRecorder

-(NSError*)start {
    [self setupAudioFormat:&recordState.dataFormat];
    
    OSStatus status = AudioQueueNewInput(&recordState.dataFormat, AudioInputCallback, &recordState, CFRunLoopGetCurrent(),
                                kCFRunLoopCommonModes, 0, &recordState.queue);
    if (status == 0) {
        status = [self createAudioFile];
        if (status == 0) {
            DeriveBufferSize(recordState.queue, recordState.dataFormat, 0.5, &recordState.bufferByteSize);
            
            for (int i = 0; i < NUM_BUFFERS; i++) {
                AudioQueueAllocateBuffer(recordState.queue, BUFFER_SIZE, &recordState.buffers[i]);
                AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, NULL);
            }
            
            //UInt32 enableMetering = YES;
            //AudioQueueSetProperty(recordState.queue, kAudioQueueProperty_EnableLevelMetering, &enableMetering, sizeof(enableMetering));
            
            status = AudioQueueStart(recordState.queue, NULL);
            if (status == 0) {
                recordState.currentPacket = 0;
                recordState.working = true;
                return nil;
            }
        }
    }
    
    return [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
}

-(BOOL)pause {
    return recordState.queue && AudioQueuePause(recordState.queue) == 0 ? YES : NO;
}

-(BOOL)resume {
    return recordState.queue && AudioQueueStart(recordState.queue, NULL) == 0 ? YES : NO;
}

-(NSData*)stop {
    if (recordState.working) {
        recordState.working = false;
        AudioQueueFlush(recordState.queue);
        AudioQueueStop(recordState.queue, true);
        for (int i = 0; i < NUM_BUFFERS; i++) {
            AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
        }
        AudioQueueDispose(recordState.queue, true);
        AudioFileClose(recordState.audioFile);
        
        return [NSData dataWithContentsOfURL:(__bridge NSURL*)mFileURL];
    }
    return nil;
}

-(BOOL)isRecording {
    return recordState.working;
}

-(void)setupAudioFormat:(AudioStreamBasicDescription*)format {
    format->mSampleRate = 16000.0;
    format->mFormatID = kAudioFormatLinearPCM;
    format->mBitsPerChannel = 16;
    format->mFramesPerPacket = 1;
    format->mReserved = 0;
    format->mChannelsPerFrame = 1;
    format->mBytesPerPacket = format->mBytesPerFrame = 2 * format->mChannelsPerFrame;
    format->mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger;
}

-(OSStatus)createAudioFile {
    const UInt8* pFilePath = (const UInt8*)[[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/recording.wav"] UTF8String];
    mFileURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, pFilePath, strlen((const char*)pFilePath), false);
    return AudioFileCreateWithURL(mFileURL, kAudioFileWAVEType, &recordState.dataFormat,
                                    kAudioFileFlags_EraseFile, &recordState.audioFile);
}

-(void)dealloc {
    CFRelease(mFileURL);
}

@end
