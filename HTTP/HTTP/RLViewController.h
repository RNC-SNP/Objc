//
//  RLViewController.h
//  HTTP
//
//  Created by RincLiu on 5/7/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController <UITextViewDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *data;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@property (strong, nonatomic) UITextView *textView;

@end
