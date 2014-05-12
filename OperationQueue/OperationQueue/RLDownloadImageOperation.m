//
//  RLDownloadImageOperation.m
//  OperationQueue
//
//  Created by RincLiu on 5/12/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLDownloadImageOperation.h"

@implementation RLDownloadImageOperation

// Init method:
-(id)initWithImageUrl:(NSString*)url delegate:(id<RLDownloadImageOperationDelegate>)delegate
{
    if(self = [super init])
    {
        self.imageUrl = url;
        self.delegate = delegate;
    }
    return self;
}

// Override main method of NSOperation:
-(void)main
{
    @autoreleasepool
    {// Check if the operation is canceled:
        if(self.isCancelled)
        {
            return;
        }
        
        // Get data from url:
        NSURL *url = [NSURL URLWithString:_imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if(self.isCancelled)
        {
            url = nil;
            imageData = nil;
            return;
        }
        
        // Init image with data:
        UIImage *image = [UIImage imageWithData:imageData];
        
        if(self.isCancelled)
        {
            image = nil;
            return;
        }
        
        // Post image data to delegate's method:
        if([(NSObject*)_delegate respondsToSelector:@selector(downloadFinishedWithImage:)])
        {
            [(NSObject*)_delegate performSelectorOnMainThread:@selector(downloadFinishedWithImage:) withObject:image waitUntilDone:NO];
        }
    }
}

@end
