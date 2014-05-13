//
//  RLViewController.m
//  Thread
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
    
	//Init views:
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imageView];
    
    //[self startThread];
    [self startThreads];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Thread start:

-(void)startThread
{
    // Call class method to create and run a thread:
    //[NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:IMAGE_URL];
    
    // Call instance method to create a thread:
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage:) object:IMAGE_URL];
    [thread start];
}

-(void)downloadImage:(NSString *) url{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image != nil)
    {
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
}

-(void)updateUI:(UIImage*) image{
    [_imageView setImage:image];
}

#pragma mark - Thread communication:

-(void)startThreads
{
    x = 9;
    
    lock = [[NSLock alloc] init];
    condition = [[NSCondition alloc] init];
    
    // Init and start thread:
    NSNumber *numA = [NSNumber numberWithInt:1];
    threadA = [[NSThread alloc] initWithTarget:self selector:@selector(runWithNum:) object:numA];
    [threadA setName:@"Thread-A"];
    [threadA start];
    
    NSNumber *numB = [NSNumber numberWithInt:2];
    threadB = [[NSThread alloc] initWithTarget:self selector:@selector(runWithNum:) object:numB];
    [threadB setName:@"Thread-B"];
    [threadB start];
    
    threadC = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [threadC setName:@"Thread-C"];
    [threadC start];
}

- (void)runWithNum:(NSNumber*)num
{
    while(x > 0)
    {
        // With NSCondition, you can wait and notify other threads.
        // More than lock and unlock.
        [condition lock];
        [condition wait];
        //[lock lock];
        
        NSLog(@"%@ is reading x: %d", [[NSThread currentThread] name], x);
        [NSThread sleepForTimeInterval:1];
        x -= num.integerValue;
        
        //[lock unlock];
        [condition unlock];
    }
}
               
-(void)run
{
    while(x > 0)
    {
        [condition lock];
        NSLog(@"Thread-C is reading x...");
        [NSThread sleepForTimeInterval:3];
        [condition signal];
        [condition unlock];
    }
}

@end
