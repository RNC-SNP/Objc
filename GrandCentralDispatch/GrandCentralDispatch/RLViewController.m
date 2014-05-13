//
//  RLViewController.m
//  GrandCentralDispatch
//
//  Created by RincLiu on 5/13/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

#define IMAGE_URL @"http://RincLiu.com/favicon.png"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imageView];
    
    //[self dispatchAsync];
    //[self dispatchGroupAsync];
    //[self dispatchBarrierAsync];
    [self dispatchApply];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GrandCentralDispatch operations:

-(void)dispatchAsync
{
    // Handle data in global thread queue:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _url = [NSURL URLWithString:IMAGE_URL];
        _data = [[NSData alloc]initWithContentsOfURL:_url];
        _image = [[UIImage alloc]initWithData:_data];
        if(_data != nil)
        {
            // Update UI on Main Thread queue:
            dispatch_async(dispatch_get_main_queue(), ^{
                [_imageView setImage:_image];
            });
        }
    });
}

-(void)dispatchGroupAsync
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        _url = [NSURL URLWithString:IMAGE_URL];
        NSLog(@"Got url in thread1.");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        _data = [[NSData alloc]initWithContentsOfURL:_url];
        NSLog(@"Got data in thread2.");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        _image = [[UIImage alloc]initWithData:_data];
        NSLog(@"Got image in thread3.");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [_imageView setImage:_image];
        NSLog(@"Updated UI in main thread.");
    });
    
    //dispatch_release(group);
}

-(void)dispatchBarrierAsync
{
    // Create new thread queue:
    dispatch_queue_t queue = dispatch_queue_create("com.rincliu.gcd", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        _url = [NSURL URLWithString:IMAGE_URL];
        NSLog(@"Got url in thread1.");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        _data = [[NSData alloc]initWithContentsOfURL:_url];
        NSLog(@"Got data in thread2.");
    });
    
    // Set a 'barrier' to block the threads behind it:
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        _image = [[UIImage alloc]initWithData:_data];
        NSLog(@"Got image in thread3.");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        [_imageView setImage:_image];
        NSLog(@"Updated UI in main thread.");
    });
}

-(void)dispatchApply
{
    // You can specify the times of running with this method:
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t size){
        NSLog(@"%zu", size);
        _url = [NSURL URLWithString:IMAGE_URL];
        _data = [[NSData alloc]initWithContentsOfURL:_url];
        _image = [[UIImage alloc]initWithData:_data];
        if(_data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_imageView setImage:_image];
            });
        }
    });
}

@end
