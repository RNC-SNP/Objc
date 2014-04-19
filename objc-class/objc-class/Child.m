//
//  Child.m
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "Child.h"

@implementation Child
// Override:
-(void) greeting{
    [super greeting];
    NSLog(@"Child says: 'Hello, World.'");
}

// Overload:
-(Boolean) greeting:(NSString*) name {
    [self greeting];
    NSLog(@"Child says: 'Hello, %@.'", name);
    return YES;
}

// Implements method declared in Extension:
-(void) greetingInExtension: (NSString*) name{
    [self greeting];
    NSLog(@"Extension says: 'Hello, %@.'", name);
}
@end
