//
//  main.m
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parent.h"
#import "Child.h"
#import "Child+Cate.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        Child *child = [[Child alloc] initWithName: @"Rinc"];
        [child greeting];
        [child greeting: @"Rinc"];
        [child greetingInCate: @"Rinc"];
        [child greetingInExtension: @"Rinc"];
        [child printProtocolName];
        
        // Use isKindOfClass:
        BOOL isKind = [child isKindOfClass:[Parent class]];
        NSLog(@"Object child %@ a kind of class Parent", isKind ?  @"is" : @"is not");
        // Use isMemberOfClass:
        BOOL isMember = [child isMemberOfClass:[Parent class]];
        NSLog(@"Object child %@ a member of class Parent", isMember ?  @"is" : @"is not");
        // Use respondsToSelector:
        BOOL isRespond = [child respondsToSelector: @selector(greeting:)];
        NSLog(@"Object child %@ to selector 'greeting:'", isRespond ?  @"responds" : @"dosn't respond");
        // Use conformsToProtocol:
        BOOL isConform = [child conformsToProtocol: @protocol(MyProtocol)];
        NSLog(@"Object child %@ to protocol 'MyProtocol'", isConform ?  @"comforms" : @"dosn't conform");
    }
    return 0;
}

