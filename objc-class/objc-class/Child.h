//
//  Child.h
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "Parent.h"

@interface Child : Parent{
    int y;
}

// Override:
-(void) greeting;

// Overload:
-(Boolean) greeting: (NSString*) name;
@end

// Use Extension(anonymous category after interface)
@interface Child() {
    int k;
}
-(void) greetingInExtension: (NSString*) name;
@end
