//
//  main.m
//  objc-KVC&KVO
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        Person *per = [[Person alloc]init];
        Page *pg = [[Page alloc]init:per];
        
        // Set property:
        [per setValue:@"Rinc Liu" forKey:@"name"];
        NSLog(@"person.name:%@", [per valueForKey:@"name"]);
        
        // Set property's property:
        Phone *pho = [[Phone alloc]init];
        [pho setValue:@"186xxxxxxxx" forKey:@"number"];
        [per setValue:pho forKey:@"phone"];
        NSLog(@"person.phone.number:%@", [per valueForKeyPath:@"phone.number"]);
        // Reset property's property:
        [per setValue:@"186xxxxx435" forKeyPath:@"phone.number"];
        NSLog(@"person.phone.number:%@", [per valueForKeyPath:@"phone.number"]);
        
    }
    return 0;
}

