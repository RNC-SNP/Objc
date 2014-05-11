//
//  Page.m
//  objc-KVC&KVO
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "Page.h"

@implementation Page

-(id)init:(Person*)prsn
{
    if(self = [super init])
    {
        person = prsn;
        // Add Observer to property's changing:
        [person addObserver:self forKeyPath:@"phone" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc
{
    [person removeObserver:self forKeyPath:@"phone" context:nil];
    //[super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"phone"])
    {
        NSLog(@"person.phone changed from %@ to %@", [change objectForKey:@"old"], [change objectForKey:@"new"]);
    }
}

@end
