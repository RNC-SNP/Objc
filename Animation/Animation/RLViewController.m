//
//  RLViewController.m
//  Animation
//
//  Created by RincLiu on 5/14/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

#define IMAGE_URL @"https://avatars3.githubusercontent.com/u/3728159"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CALayer *layer = self.view.layer;
    [self modifyLayer:layer];
    [self addSubLayerToLayer:layer];
    [self setDelegateToLayer:layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Use CALayer:

-(void)modifyLayer:(CALayer*)layer
{
    [layer setBackgroundColor:[UIColor orangeColor].CGColor];
    [layer setCornerRadius:10.0];
}

-(void)addSubLayerToLayer:(CALayer*)layer
{
    // Create a new layer:
    CALayer *sublayer = [CALayer layer];
    [sublayer setFrame:CGRectMake(50, 50, 200, 200)];
    [sublayer setBackgroundColor:[UIColor purpleColor].CGColor];
    [sublayer setCornerRadius:5.6789];
    [sublayer setMasksToBounds:NO];
    // Set shadow properties:
    [sublayer setShadowOffset:CGSizeMake(0, 3)];
    [sublayer setShadowRadius:5.0];
    [sublayer setShadowColor:[UIColor blackColor].CGColor];
    [sublayer setShadowOpacity:0.8];
    // Set border properties:
    [sublayer setBorderColor:[UIColor blueColor].CGColor];
    [sublayer setBorderWidth:0.369];
    // Set contents:
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:IMAGE_URL]];
    [sublayer setContents:(id)[UIImage imageWithData:data].CGImage];
    // Add subLayer:
    [layer addSublayer:sublayer];
}

#pragma mark - Use CALayerDelegate to draw customized content:

-(void)setDelegateToLayer:(CALayer*)layer
{
    CALayer *customDrawn = [CALayer layer];
    customDrawn.delegate = self;
//    customDrawn.backgroundColor = [UIColor greenColor].CGColor;
//    customDrawn.frame = CGRectMake(30, 250, 280, 200);
//    customDrawn.shadowOffset = CGSizeMake(0, 3);
//    customDrawn.shadowRadius = 5.0;
//    customDrawn.shadowColor = [UIColor blackColor].CGColor;
//    customDrawn.shadowOpacity = 0.8;
//    customDrawn.cornerRadius = 10.0;
//    customDrawn.borderColor = [UIColor blackColor].CGColor;
//    customDrawn.borderWidth = 2.0;
//    customDrawn.masksToBounds = YES;
    [layer addSublayer:customDrawn];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, layer.bounds);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           layer.bounds,
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, layer.bounds);
    CGContextRestoreGState(context);
}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
}

static inline double radians (double degrees)
{
    return degrees * M_PI/180;
}

#pragma mark - Use CoreAnimation:

@end
