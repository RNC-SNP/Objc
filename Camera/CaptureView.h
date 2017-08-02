#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CaptureMode) {
    CaptureModeCodeScanner,
    CaptureModePhotoCamera,
    CaptureModeVideoCamera
};

@protocol CaptureViewDelegate <NSObject>

@optional
-(void)captureViewGotScanResult:(NSString*)scanResult;

@optional
-(void)captureViewGotPhoto:(UIImage*)photo Exif:(NSDictionary*)exif;

@end

@interface CaptureView : UIView

@property (nonatomic,weak) id<CaptureViewDelegate> delegate;

-(BOOL)hasCamera;

-(BOOL)hasFrontCamera;

-(BOOL)hasBackCamera;

-(BOOL)turnFlashOn:(BOOL)on;

-(void)setMode:(CaptureMode)mode;

-(BOOL)switchFrontBackCamera;

-(void)startCapture;

-(void)stopCapture;

-(void)setPhotoOutputSettings:(NSDictionary*)settings;

-(void)takePhoto;

-(void)startRecordVideo;

-(void)stopRecordVideo;

@end
