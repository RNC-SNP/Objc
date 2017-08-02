#import "CaptureView.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface CaptureView()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureOutput *output;
@property (nonatomic,assign) NSUInteger currentMode;
@end

@implementation CaptureView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if ([self hasCamera]) {
            _session = [AVCaptureSession new];
            
            NSError *error = nil;
            _input = [AVCaptureDeviceInput deviceInputWithDevice:
                                           [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
            if (_input) {
                if ([_session canAddInput:_input]) {
                    [_session addInput:_input];
                } else {
                    NSLog(@"CaptureSession addInput failed");
                }
            } else {
                NSLog(@"CaptureSession init Error: %@", error);
            }
            
            _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            frame.origin.x = frame.origin.y = 0;
            _previewLayer.frame = frame;
            [self.layer addSublayer:_previewLayer];
        }
    }
    return self;
}

-(void)initCodeScannerOutput {
    [self setSessionPreset:AVCaptureSessionPresetHigh];
    AVCaptureMetadataOutput *metadataOutput = [AVCaptureMetadataOutput new];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self setSessionOutput:metadataOutput]) {
        metadataOutput.metadataObjectTypes = [metadataOutput availableMetadataObjectTypes];
    }
}

-(void)initPhotoCameraOutput {
    [self setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureStillImageOutput *stillImageOutput = [AVCaptureStillImageOutput new];
    [stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    if ([stillImageOutput respondsToSelector:@selector(setHighResolutionStillImageOutputEnabled:)]) {
        stillImageOutput.highResolutionStillImageOutputEnabled = YES;
    }
    [self setSessionOutput:stillImageOutput];
}

-(void)initVideoCameraOutput {
    [self setSessionPreset:AVCaptureSessionPresetHigh];
    //TODO
}

-(BOOL)setSessionOutput:(AVCaptureOutput*)output {
    if (_output != nil) {
        [_session removeOutput:_output];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        _output = output;
        return YES;
    } else {
        NSLog(@"CaptureSession add %@ failed", output);
        if (_output != nil) {
            [_session addOutput:_output];
        }
        return NO;
    }
}

-(BOOL)setSessionPreset:(NSString*)preset {
    if ([_session canSetSessionPreset:preset]) {
        _session.sessionPreset = preset;
        return YES;
    }
    return NO;
}

-(void)setMode:(CaptureMode)mode {
    if (_session != nil) {
        [_session beginConfiguration];
        switch (mode) {
            case CaptureModeCodeScanner: {
                [self initCodeScannerOutput];
                break;
            }
            case CaptureModePhotoCamera: {
                [self initPhotoCameraOutput];
                break;
            }
            case CaptureModeVideoCamera: {
                [self initVideoCameraOutput];
                break;
            }
        }
        [_session commitConfiguration];
        _currentMode = mode;
    }
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

-(void)setPhotoOutputSettings:(NSDictionary*)settings {
    if (_output != nil && _currentMode == CaptureModePhotoCamera) {
        [(AVCaptureStillImageOutput*)_output setOutputSettings:settings];
    }
}

-(BOOL)hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(BOOL)hasFrontCamera {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

-(BOOL)hasBackCamera {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

-(BOOL)hasMultipleCameras {
    NSArray *devices = [self devices];
    return devices != nil && [devices count] > 1;
}

-(AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position {
    for (AVCaptureDevice *device in [self devices]) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

-(NSArray*)devices {
    return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
}

-(void)switchFrontBackCamera {
    if ([self hasMultipleCameras]) {
        NSArray *inputs = _session.inputs;
        for (AVCaptureDeviceInput *input in inputs) {
            AVCaptureDevice *device = input.device;
            if ([device hasMediaType:AVMediaTypeVideo]) {
                [_session beginConfiguration];
                AVCaptureDevice *cameraDevice = [self cameraWithPosition:device.position == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront];
                AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:nil];
                [_session removeInput:_input];
                if ([_session canAddInput:input]) {
                    [_session addInput:input];
                    _input = input;
                } else {
                    [_session addInput:_input];
                }
                [_session commitConfiguration];
                break;
            }
        }
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
