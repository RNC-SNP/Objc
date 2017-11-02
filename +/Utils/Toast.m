#import "Toast.h"
#import "UIUtil.h"

static Toast *instance;

@interface Toast()
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *label;
@end

@implementation Toast

+(instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Toast alloc]init];
        }
    });
    return instance;
}

-(instancetype)init {
    if (self = [super init]) {
        _bg = [[UIView alloc]initWithFrame:CGRectZero];
        _bg.backgroundColor = [UIColor grayColor];
        [self addSubview:_bg];
        _label = [UIUtil LabelFromFrame:CGRectZero Color:[UIColor whiteColor] Size:13];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        self.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

-(void)showText:(NSString*)text Duration:(NSTimeInterval)duration {
    _label.text = text;
    
    CGFloat w = [UIUtil measureLabelWidth:_label MaxWidth:INT_MAX];
    NSInteger lines = ceil(w * 2.0f / kSCREEN_WIDTH);
    CGRect frame = CGRectZero;
    frame.size.width = MIN(kSCREEN_WIDTH / 2, w);
    frame.origin.x = (kSCREEN_WIDTH - frame.size.width) / 2;
    frame.size.height = lines * 17;
    frame.origin.y = (kSCREEN_HEIGHT - frame.size.height) / 2;
    _label.frame = frame;
    _label.numberOfLines = lines;
    frame.origin.x -= 20;
    frame.origin.y -= 10;
    frame.size.width += 40;
    frame.size.height += 20;
    _bg.frame = frame;
    _bg.layer.cornerRadius = frame.size.height / 2;
    
    self.alpha = 1.0;
    
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(animDismiss) userInfo:nil repeats:NO];
}

-(void)showText:(NSString*)text {
    [self showText:text Duration:2.0];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

-(void)animDismiss {
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:nil];
}

@end
