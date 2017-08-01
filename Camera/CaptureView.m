#import "CaptureView.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface CaptureView()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVCaptureOutput *output;
@property (nonatomic,assign) NSUInteger currentMode;
@end

@implementation CaptureView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _session = [AVCaptureSession new];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:
                                       [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
        if (input) {
            [_session addInput:input];
        } else {
            NSLog(@"CaptureSession Error: %@", error);
        }
        
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        frame.origin.x = frame.origin.y = 0;
        _previewLayer.frame = frame;
        [self.layer addSublayer:_previewLayer];
    }
    return self;
}

-(void)initCodeScanner {
    AVCaptureMetadataOutput *metadataOutput = [AVCaptureMetadataOutput new];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:metadataOutput];
    metadataOutput.metadataObjectTypes = [metadataOutput availableMetadataObjectTypes];
    _output = metadataOutput;
}

-(void)initPhotoCamera {
    AVCaptureStillImageOutput *stillImageOutput = [AVCaptureStillImageOutput new];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [_session addOutput:stillImageOutput];
    _output = stillImageOutput;
}

-(void)initVideoCamera {
    //TODO
}

-(void)setMode:(CaptureMode)mode {
    if (_session != nil && _output != nil) {
        [_session removeOutput:_output];
    }
    switch (mode) {
        case CaptureModeCodeScanner: {
            [self initCodeScanner];
            break;
        }
        case CaptureModePhotoCamera: {
            [self initPhotoCamera];
            break;
        }
        case CaptureModeVideoCamera: {
            [self initVideoCamera];
            break;
        }
    }
    _currentMode = mode;
}

-(void)startCapture {
    if (_output != nil) {
        [_session startRunning];
    }
}

-(void)stopCapture {
    if (_output != nil) {
        [_session stopRunning];
    }
}

-(void)takePhoto {
    if (_output != nil && _currentMode == CaptureModePhotoCamera) {
        AVCaptureConnection *mConnection = nil;
        AVCaptureStillImageOutput *stillImageOutput = (AVCaptureStillImageOutput*)_output;
        for (AVCaptureConnection *connection in stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType]isEqual:AVMediaTypeVideo]) {
                    mConnection = connection;
                    break;
                }
            }
            if (mConnection != nil) {
                break;
            }
        }
        
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:mConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            CFDictionaryRef exifDictRef = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            NSDictionary *exifDict = exifDictRef != nil ? (__bridge NSDictionary*)exifDictRef : nil;
            
            if (_delegate != nil && [_delegate respondsToSelector:@selector(captureViewGotPhoto:Exif:)]) {
                [_delegate captureViewGotPhoto:image Exif:exifDict];
            }
         }];
    }
}

-(void)startRecordVideo {
    //TODO
}

-(void)stopRecordVideo {
    //TODO
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput*)output didOutputMetadataObjects:(NSArray*)metadataObjs fromConnection:(AVCaptureConnection*)conn {
    AVMetadataMachineReadableCodeObject *codeObj;
    NSString *codeText = nil;
    
    NSArray *types = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code,
                       AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code,
                       AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code,
                       AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code,
                       AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjs) {
        for (NSString *type in types) {
            if ([metadata.type isEqualToString:type]) {
                AVMetadataMachineReadableCodeObject* codeObjMetadata = (AVMetadataMachineReadableCodeObject*)metadata;
                codeObj = (AVMetadataMachineReadableCodeObject*)[_previewLayer transformedMetadataObjectForMetadataObject:codeObjMetadata];
                codeText = [codeObjMetadata stringValue];
                break;
            }
        }
        
        if (codeText != nil) {
            if (_delegate != nil && [_delegate respondsToSelector:@selector(captureViewGotScanResult:)]) {
                [_delegate captureViewGotScanResult:codeText];
            }
            break;
        }
    }
}

@end
