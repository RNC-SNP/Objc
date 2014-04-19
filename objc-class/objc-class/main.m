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
        Child *child = [[Child alloc] init];
        [child greeting];
        [child greeting: @"Rinc"];
        [child greetingInCate: @"Rinc"];
    }
    return 0;
}

