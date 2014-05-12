//
//  RLViewController.h
//  OperationQueue
//
//  Created by RincLiu on 5/12/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLDownloadImageOperation.h"

@interface RLViewController : UIViewController<RLDownloadImageOperationDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@end
