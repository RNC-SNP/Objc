#import <UIKit/UIKit.h>

@interface Toast : UIView

+(instancetype)shared;

-(void)showText:(NSString*)text;

-(void)showText:(NSString*)text Duration:(NSTimeInterval)duration;

@end
