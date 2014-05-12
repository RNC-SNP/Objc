//
//  RLDownloadImageOperation.h
//  OperationQueue
//
//  Created by RincLiu on 5/12/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RLDownloadImageOperationDelegate;

@interface RLDownloadImageOperation:NSOperation

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, retain) id<RLDownloadImageOperationDelegate> delegate;

-(id)initWithImageUrl:(NSString*)url delegate:(id<RLDownloadImageOperationDelegate>)delegate;

@end

// Define delegate:
@protocol RLDownloadImageOperationDelegate<NSObject>

-(void)downloadFinishedWithImage:(UIImage*)image;

@end
