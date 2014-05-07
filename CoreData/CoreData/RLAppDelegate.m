//
//  RLAppDelegate.m
//  UseCoreData
//
//  Created by RincLiu on 5/3/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLAppDelegate.h"

@implementation RLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _coreDataManager = [[RLCoreDataManager alloc]init];
    
    // Add data:
    // Note: you can not init a NSManagedObject instance by call alloc and init!!
    [_coreDataManager addUserWithName:@"Rinc Liu" andEmail:@"i@RincLiu.com"];
    [_coreDataManager addUserWithName:@"Richard Lew" andEmail:@"i@RichardLew.com"];
    
    // Query data:
    NSMutableArray *users = [_coreDataManager getUserListByPageSize:10 andOffset:0];
    for(UserEntity *user in users)
    {
        NSLog(@"name: %@, email: %@", user.name, user.email);
    }
    
    // Update data:
    [_coreDataManager updateUserEmail:@"i@rincliu.com" byName:@"Rinc Liu"];
    
    // Delete data:
    [_coreDataManager deleteUserByName:@"Rinc Liu"];
    [_coreDataManager deleteUserByName:@"Richard Lew"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_coreDataManager saveManagedObjectContext];
}

@end
