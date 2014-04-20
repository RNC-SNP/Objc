//
//  Parent.h
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyProtocol.h"

// Declare Super Class and Protocol:
@interface Parent : NSObject <MyProtocol> {
    // Declare variable:
    int x;
}

// Declare property:
@property (readwrite) NSString *_name;

// Init method:
-(id)initWithName: (NSString*) name;

-(void) greeting;
@end
