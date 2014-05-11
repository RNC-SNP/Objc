//
//  Page.h
//  objc-KVC&KVO
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Page : NSObject
{
    Person *person;
}

-(id)init:(Person*)prsn;

@end
