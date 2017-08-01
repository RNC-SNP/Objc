#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CaptureViewMode) {
    CaptureViewModeScan,
    CaptureViewModePhoto,
    CaptureViewModeVideo
};

@protocol CaptureViewDelegate <NSObject>

@optional
-(void)captureViewGotScanResult:(NSString*)scanResult;

@optional
-(void)captureViewGotPhoto:(UIImage*)photo Exif:(NSDictionary*)exif;

@end

@interface CaptureView : UIView

@property (nonatomic,weak) id<CaptureViewDelegate> delegate;

-(void)setMode:(CaptureViewMode)mode;

-(void)startCapture;

-(void)stopCapture;

-(void)takePhoto;

@end
