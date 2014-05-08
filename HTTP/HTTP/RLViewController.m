//
//  RLViewController.m
//  HTTP
//
//  Created by RincLiu on 5/7/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init views:

-(void)initViews
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    float btnWidth = (screenFrame.size.width - 3 * 30) / 2;
    
    UIButton *btnGet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnGet setTitle:@"GET" forState:UIControlStateNormal];
    [btnGet addTarget:self action:@selector(sendHTTPGetRequest) forControlEvents:UIControlEventTouchUpInside];
    [btnGet setFrame:CGRectMake(30, 20, btnWidth, 30)];
    [btnGet setBackgroundColor:[UIColor brownColor]];
    [self.view addSubview:btnGet];
    
    _aiv = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(30 + btnWidth, 20, 30, 30)];
    [_aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_aiv];
    
    UIButton *btnPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPost setTitle:@"POST" forState:UIControlStateNormal];
    [btnPost addTarget:self action:@selector(sendHTTPPostRequest) forControlEvents:UIControlEventTouchUpInside];
    [btnPost setFrame:CGRectMake(30 * 2 + btnWidth, 20, btnWidth, 30)];
    [btnPost setBackgroundColor:[UIColor brownColor]];
    [self.view addSubview:btnPost];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, screenFrame.size.width, screenFrame.size.height-50)];
    [_textView setDelegate:self];
    [self.view addSubview:_textView];
}

#pragma mark - UITextViewDelegate methods:

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;// Disable UITextView's edit function.
}

#pragma mark - Send HTTP Get/Post request:

- (void)sendHTTPGetRequest
{
    NSString *urlStr = @"http://RincLiu.com";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    // This method depends on the request's delegate:
    //[[NSURLConnection connectionWithRequest:request delegate:self]start];
    
    [self sendAsyncRequest:request];
    
    [_aiv startAnimating];
}

- (void)sendHTTPPostRequest
{
    NSString *urlStr = @"http://weibo.com/311436000";
    NSString *params = @"wvr=5&";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:3.0f];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    // This method depends on the request's delegate:
    //[[NSURLConnection connectionWithRequest:request delegate:self]start];
    
    [self sendAsyncRequest:request];
    
    [_aiv startAnimating];
}

-(void)sendSyncRequest:(NSURLRequest*)request
{
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    // This method will block the Main Thread, so it's not recommended.
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    else
    {
        // Handle data.
    }
}

-(void)sendAsyncRequest:(NSURLRequest*)request
{
    if(_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    // This method doesn't depend on the request's delegate.
    // You can handle data in a code block as callback.
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error != nil)
        {
            NSLog(@"Error: %@", error.localizedDescription);
            [_aiv stopAnimating];
        }
        else
        {
            NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // Like in Android, UI operation is only allowed in the Main Thread.
            // You can call the method below and use a block as callback to update UI.
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_textView setText:output];
                [_aiv stopAnimating];
            });
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate methods:

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!_data)
    {
        _data = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *output = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    [_textView setText:output];
    _data = nil;
    
    [_aiv stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    assert(error);
    
    [_aiv stopAnimating];
}

@end