//
//  MyProtocol.h
//  objc-class
//
//  Created by RincLiu on 4/20/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use Protocol:
@protocol MyProtocol <NSObject>

// Declare required method:
@required
-(void)printProtocolName;

// Declare oprional method:
@optional
-(void)printAuthor;

@end
