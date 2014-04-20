//
//  Parent.m
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "Parent.h"

@implementation Parent

// Notify the Compiler to generate setter and getter method if the implementation file dosn't define them:
@synthesize _name;

// Init method:
-(id)initWithName: (NSString*) name{
    if (self = [super init]) {
        if(name) {
            _name = [name copy];
            return self;
        } else {
            // Cannot call release method in Automatic Reference Counting Mode:
            //[self release];
            return nil;
        }
    } else {
        return nil;
    }
}

// Implements method in Protocol:
-(void)printProtocolName {
    Protocol *protocol = @protocol(MyProtocol);
    NSLog(@"Protocol name: %@", protocol);
}

-(void) greeting{
    NSLog(@"Parent says: 'Hello, World.'");
}
@end
