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
        
        
        // Use NSString:
        NSString *nameStr = @"Rinc";
        NSString *GreetingStr = [[NSString alloc] initWithFormat: @"Hello, %@", nameStr];
        NSString *utf8 = [NSString stringWithUTF8String:"iOS 7应用开发技术详解"];
        // Travel NSString:
        for(int i=0; i < [utf8 length]; i++) {
            NSLog(@"%c", [utf8 characterAtIndex:i]);
        }
        // Use NSMutableString:
        NSMutableString *mStr = [NSMutableString stringWithString:nameStr];
        [mStr appendString:@" Liu"];
        NSRange range = [mStr rangeOfString:@" Liu"];
        // Use NSMutableString:
        NSMutableString *subStr1 = [mStr substringWithRange:range];
        NSMutableString *subStr2 = [mStr substringToIndex:3];
        [mStr replaceCharactersInRange:range withString:@" Lew"];
        
        
        // Use NSNumber:
        NSNumber *num1 = @0.1234F;
        float f = 5.6789;
        NSNumber *num2 = [[NSNumber alloc] initWithFloat: f];
        NSNumber *num3 = [NSNumber numberWithBool:YES];
        bool b = [num3 boolValue];
        
        
        // Use Array:
        NSArray *array1 = @[@"Android", @"iOS", @"WinPhone"];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"Android", @"iOS", @"WinPhone", nil];
        NSString *objs[3] = {@"Android", @"iOS", @"WinPhone"};
        NSArray *array3 = [NSArray arrayWithObjects:&(*objs) count:3];
        NSString *firstEle = [array1 firstObject];
        // Copy array:
        NSArray *array4 = [NSArray arrayWithArray:array3];
        // Sort array:
        [array4 sortedArrayUsingSelector:@selector(compare:)];
        // Travel array:
        for (NSString *ele in array3) {
            NSLog(@"element in array: %@", ele);
        }
        // Array in Array:
        NSArray *xArray = [NSArray arrayWithObjects:
                           [NSArray arrayWithObjects:@"A0", @"B0", @"C0", nil],
                           [NSArray arrayWithObjects:@"A1", @"B1", @"C1", nil],
                           [NSArray arrayWithObjects:@"A2", @"B2", @"C2", nil],
                           nil];
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                NSLog(@"%@", [[xArray objectAtIndex:i] objectAtIndex:j]);
            }
        }
        // Use NSMutableArray:
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
        [mArray addObject:@"BlackBerry"];
        [mArray insertObject:@"Symbian" atIndex:1];
        [mArray replaceObjectAtIndex:1 withObject:@"WindowsMobile"];
        
        
        // Use NSSet:
        NSArray *array = [[NSArray alloc]initWithObjects:@"AAAA", @"BBBB", @"CCCC", nil];
        NSSet *set1 = [NSSet setWithArray:array];
        NSSet *set2 = [[NSSet alloc]initWithObjects:@"AAAA", @"BBBB", @"CCCC", nil];
        NSSet *set3 = [NSSet setWithObjects:@"AAAA", @"BBBB", @"CCCC", @"DDDD", nil];
        if([set1 isEqual:set2])
        {
            NSLog(@"set1 isEqual set2.");
        }
        if([set1 containsObject:@"AAAA"])
        {
            NSLog(@"set1 contains 'AAAA'.");
        }
        if([set1 isSubsetOfSet:set3])
        {
            NSLog(@"set1 is subset of set3.");
        }
        // Travel NSSet:
        for(NSObject *obj in [set3 objectEnumerator])
        {
            NSLog(@"object in set3:%@", obj);
        }
        // Use NSMutableSet:
        NSMutableSet *mSet = [NSMutableSet setWithCapacity:10];
        [mSet addObject:@"XXXX"];
        // Add NSSet to NSMutableSet:
        [mSet unionSet:set3];
        // Delete NSSet from NSMutableSet:
        [mSet minusSet:set1];
        for(NSObject *obj in [mSet objectEnumerator])
        {
            NSLog(@"object in mSet:%@", obj);
        }
        
        // Use Dictionary:
        NSDictionary *dic1 = @{@"key1":@"value1", @"key2":@"value2"};
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys: @"Java", @"Android", @"Objective-C", @"iOS", @"C#", @"WinPhone", nil];
        NSArray *valueArray = [NSArray arrayWithObjects:@"Java", @"Objective-C", @"C#", nil];
        NSArray *keyArray = [NSArray arrayWithObjects:@"Android", @"iOS", @"WinPhone", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        // Travel Dictionary:
        NSString *_key;
        for (_key in dic3) {
            NSLog(@"OS: %@, lang: %@", _key, [dic3 objectForKey:_key]);
        }
        // Travel with NSEnumerator(like Iterator in Java):
        NSEnumerator *keyEnum = dic3.keyEnumerator;
        for(NSString *_k in keyEnum){
            NSLog(@"OS: %@, lang: %@", _k, [dic3 objectForKey:_k]);
        }
        // Use NSMutableDictionary:
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        mDic[@"WindowsMobile"] = @"C#";
        [mDic setObject:@"C#" forKey:@"WindowsMobile"];
        
        
        // Use NSDate/NSDateFormatter:
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"Current time: %@", [formatter stringFromDate: currentDate]);
        // Use NSCalendar/NSTimeZone/NSDateComponents:
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSCalendarUnit unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dc = [calendar components: unit fromDate: currentDate];
        NSLog(@"Current time: %d-%d-%d %d:%d:%d", [dc year], [dc month], [dc day], [dc hour], [dc minute], [dc second]);
        
        
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
        
        
        // Use try/catch/finally/throw:
        NSEnumerator *_enum= [array2 objectEnumerator];
        for(NSString *str in _enum) {
            NSLog(@"Current: %@", str);
            NSString *next = [_enum nextObject];
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
                NSLog(@"Final operation...");
            }
        }
    }
    
    return 0;
}

