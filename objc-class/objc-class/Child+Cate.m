//
//  Child+Cate.m
//  objc-class
//
//  Created by RincLiu on 4/20/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "Child+Cate.h"

// Use Category:
@implementation Child (Cate)
-(NSString*) greetingInCate:(NSString *)name{
    [self greeting: name];
    NSLog(@"Category says: 'Hello, %@.'", name);
    return name;
}
@end
