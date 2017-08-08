#import "ResizablePageControl.h"

@implementation ResizablePageControl

-(void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * (_dotSize + _space), dot.frame.origin.y, _dotSize, _dotSize)];
    }
}

@end
