//
//  Student.h
//  objc-KVC&KVO
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
# import "Phone.h"

@interface Person : NSObject
{
    NSString *name;
    Phone *phone;
}

-(void)changePhone:(Phone*)phn;

@end
