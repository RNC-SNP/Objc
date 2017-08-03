#import "UIUtil.h"

@implementation UIUtil

+(CGFloat)measureLabelWidth:(UILabel*)label MaxWidth:(CGFloat)maxWidth {
    NSDictionary *atrr = @{NSFontAttributeName : label.font};
    CGSize size = [(label.text ? label.text : @"") boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:atrr
                                                      context:nil].size;
    return size.width;
}

+(UILabel*)LabelFromFrame:(CGRect)frame Color:(UIColor*)color Size:(CGFloat)size {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label setTextColor:color];
    [label setFont:[UIFont systemFontOfSize:size]];
    return label;
}

+(void)setAttrStr:(NSMutableAttributedString*)attrStr Color:(UIColor*)color Size:(CGFloat)size Start:(NSInteger)start Length:(NSInteger)length {
    NSRange range = NSMakeRange(start, length);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
}

@end
