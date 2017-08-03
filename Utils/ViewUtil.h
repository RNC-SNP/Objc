#ifndef ViewUtil_h
#define ViewUtil_h

#import <Foundation/Foundation.h>

#define Image(img) [UIImage imageNamed:img]

#define SetImage(v,img) [v setImage:Image(img)]

#define SetImageNormal(v, img) [v setImage:Image(img) forState:UIControlStateNormal]

#define SetTitleColorNormal(v,color) [v setTitleColor:color forState:UIControlStateNormal]

#define SetTitleNormal(v,title) [v setTitle:title forState:UIControlStateNormal]

#define SetClickCallback(v,sel) [v addTarget:self action:sel \
forControlEvents:UIControlEventTouchUpInside]

#define SetTapCallback(v,sel) [v addGestureRecognizer:\
[[UITapGestureRecognizer alloc]initWithTarget:self action:sel]]

#define UIColorFromARGB(argb) [UIColor colorWithRed:((float)((argb & 0xFF0000) >> 16))/255.0 green:((float)((argb & 0xFF00) >> 8))/255.0 blue:((float)(argb & 0xFF))/255.0 alpha:((float)((argb & 0xFF000000) >> 24))/255.0]

@interface ViewUtil : NSObject

+(CGFloat)measureLabelWidth:(UILabel*)label MaxWidth:(CGFloat)maxWidth;

+(UILabel*)LabelFromFrame:(CGRect)frame Color:(UIColor*)color Size:(CGFloat)size;

+(void)setAttrStr:(NSMutableAttributedString*)attrStr Color:(UIColor*)color Size:(CGFloat)size Start:(NSInteger)start Length:(NSInteger)length;

@end

#endif
