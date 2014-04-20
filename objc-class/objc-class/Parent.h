//
//  Parent.h
//  objc-class
//
//  Created by RincLiu on 4/19/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parent : NSObject {
    // Declare variable:
    int x;
}

// Declare property:
@property (readwrite) NSString *_name;

// Init method:
-(id)initWithName: (NSString*) name;

-(void) greeting;
@end
