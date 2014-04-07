//
//  main.m
//  objc-base
//
//  Created by RincLiu on 4/8/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char* argv[]){
    @autoreleasepool {
        // Use Block:
        int (^SquareBlock)(int) = ^(int x){
            int result = x * x;
            return result;
        };
        NSLog(@"Result of SquareBlock(9): %d", SquareBlock(9));
        
    }
    return 0;
}

