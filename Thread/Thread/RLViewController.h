//
//  RLViewController.h
//  Thread
//
//  Created by RincLiu on 5/13/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController
{
    int x;
    NSThread* threadA;
    NSThread* threadB;
    NSThread* threadC;
    NSCondition* condition;
    NSLock *lock;
}

@property (strong, nonatomic) UIImageView *imageView;

@end
