//
//  RLViewController.m
//  OperationQueue
//
//  Created by RincLiu on 5/12/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imageView];
    
    NSString *url = @"http://RincLiu.com/favicon.png";
    //[self addInvocationOperationWithUrl:url];
    [self addCustomOperationWithUrl:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom NSOperation:

-(void)addCustomOperationWithUrl:(NSString*)url
{
    // Init custom operation:
    RLDownloadImageOperation *op = [[RLDownloadImageOperation alloc]initWithImageUrl:url delegate:self];
    // Set completion callback:
    [op setCompletionBlock:^()
     {
         NSLog(@"Operation done.");
     }];
    // Add operation in queue:
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    [queue addOperation:op];
}

-(void)downloadFinishedWithImage:(UIImage*)image
{
    [_imageView setImage:image];
}

#pragma mark - Use NSInvocationOperation and NSOperationQueue:

-(void)addInvocationOperationWithUrl:(NSString*)url
{
    // Init operation:
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self
                                                                           selector:@selector(downloadImage:)object:url];
    // Set completion callback:
    [operation setCompletionBlock:^()
    {
        NSLog(@"Operation done.");
    }];
    // Add operation in queue:
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    [queue addOperation:operation];
}

-(void)downloadImage:(NSString *)url{
    // Get data from url to init image:
    NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    // Update UI on Main Thread:
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

-(void)updateUI:(UIImage*)image{
    [_imageView setImage:image];
}

@end
