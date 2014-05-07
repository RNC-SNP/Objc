//
//  RLAppDelegate.h
//  UseCoreData
//
//  Created by RincLiu on 5/3/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLCoreDataManager.h"
#import "UserEntity.h"
#import <Foundation/Foundation.h>

@interface RLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RLCoreDataManager *coreDataManager;

@end
