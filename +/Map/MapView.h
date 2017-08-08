#import <UIKit/UIKit.h>

@interface Annotation : NSObject

+(instancetype)annotationWithLatitude:(double)latitude Longitude:(double)longitude Title:(NSString*)title SubTitle:(NSString*)subTitle;

@end

@interface MapView : UIView

-(void)setCenterLatitude:(double)latitude Longitude:(double)longitude RegionSpan:(double)regionSpan;

-(void)addAnnotation:(Annotation*)annotation AutoSelect:(BOOL)autoSelect;

-(void)removeAnnotation:(Annotation*)Annotation;

-(void)moveToUserLocation;

-(void)takeSnapshot:(void(^)(UIImage*))handler;

@end
