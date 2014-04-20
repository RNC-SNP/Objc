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
        // Use Block as function:
        double one = 1;
        double (^MultiplyBlock)(double, double) = ^(double x, double y){
            double result = x * y * one;
            return result;
        };
        one = 0;// This change won't effect the block defined above.
        NSLog(@"Result of MultiplyBlock(1.2, 3.4): %f", MultiplyBlock(1.2, 3.4));
        
        
        // Use Associate:
        static char key;
        NSArray *sourceObj= [[NSArray alloc]initWithObjects:@"Android", @"iOS", @"WindowsPhone", nil];
        NSString *associatedObj = [[NSString alloc]initWithFormat:@"%@", @"Three mobile platforms"];
        objc_setAssociatedObject(sourceObj, key, associatedObj, OBJC_ASSOCIATION_RETAIN);
        // [associatedObj release];
        NSLog(@"associatedObj: %@", (NSString *)objc_getAssociatedObject(sourceObj, key));
        objc_removeAssociatedObjects(sourceObj);
        NSLog(@"associatedObj: %@", (NSString *)objc_getAssociatedObject(sourceObj, key));
        // [sourceObj release];
        
        
        // Use 'for...in' expression with Array:
        NSArray *array = [NSArray arrayWithObjects: @"Android", @"iOS", @"WinPhone", nil];
        for (NSString *ele in array) {
            NSLog(@"element in array: %@", ele);
        }
        // Use 'for...in' expression with Dictionary:
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"Java", @"Android", @"Objective-C", @"iOS", @"C#", @"WinPhone", nil];
        NSString *_key;
        for (_key in dic) {
            NSLog(@"OS: %@, lang: %@", _key, [dic objectForKey:_key]);
        }
        // Use 'for...in' expression with NSEnumerator(Just like Iterator in Java):
        NSEnumerator *_enum= [array objectEnumerator];
        for(NSString *str in _enum) {
            NSLog(@"Current: %@", str);
            NSString *next = [_enum nextObject];
            // Use try/catch/finally/throw:
            @try {
                if(next) {
                    NSLog(@"Next: %@", next);
                } else {
                    NSException* ex = [NSException exceptionWithName: @"NullPointerException" reason: @"Unknown reason" userInfo: nil];
                    @throw ex;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@ occured: %@", [exception name], [exception reason]);
            }
            @finally {
                //TODO
            }
        }
    }
    
    return 0;
}

