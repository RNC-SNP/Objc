//
//  RLAppDelegate.m
//  UseNotification
//
//  Created by RincLiu on 5/3/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLAppDelegate.h"

@implementation RLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self handleNotificationsWithLaunchOptions:launchOptions];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self scheduleLocalNotification];
}
				
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification callbacks:

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Registered remote notification successfully.");
    const void *deviceTokenBytes = [deviceToken bytes];
    // Send this token to to provider.
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register remote notification.");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received remote notification...");
    UIApplication *app = [UIApplication sharedApplication];
    [app setApplicationIconBadgeNumber:app.applicationIconBadgeNumber+1];
    [self printNotificationDicInfo:userInfo];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Received local notification...");
    UIApplication *app = [UIApplication sharedApplication];
    [app setApplicationIconBadgeNumber:app.applicationIconBadgeNumber+1];
    [self printNotificationDicInfo:notification.userInfo];
}

#pragma mark - Handle Notifications:

-(void)handleNotificationsWithLaunchOptions:(NSDictionary *)launchOptions
{
    UIApplication *app = [UIApplication sharedApplication];
    
    // Register remote notification:
    [app registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    // Handle local notification:
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotification)
    {
        NSLog(@"Read local notification...");
        //[app setApplicationIconBadgeNumber:localNotification.applicationIconBadgeNumber-1];
        [app setApplicationIconBadgeNumber:app.applicationIconBadgeNumber-1];
        [self printNotificationDicInfo:localNotification.userInfo];
    }
    else{
        NSLog(@"No local notification...");
    }
    //[app cancelAllLocalNotifications];
    
    // Handle remote notification:
    UILocalNotification *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(localNotification)
    {
        NSLog(@"Read remote notification...");
        //[app setApplicationIconBadgeNumber:remoteNotification.applicationIconBadgeNumber-1];
        [app setApplicationIconBadgeNumber:app.applicationIconBadgeNumber-1];
        [self printNotificationDicInfo:remoteNotification.userInfo];
    }
    else{
        NSLog(@"No remote notification...");
    }
}
                                                              
-(void)scheduleLocalNotification
{
    // Schedule a Local Notification:
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [localNotification setFireDate:[df dateFromString:@"2014-05-03 17:00:10"]];
    [localNotification setRepeatInterval:NSMinuteCalendarUnit];
    [localNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [localNotification setAlertBody:@"This is a Local Notification."];
    [localNotification setAlertAction:@"Got it."];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [localNotification setApplicationIconBadgeNumber:1];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"UserName", @"UserEmail", nil] forKeys:[NSArray arrayWithObjects:@"Rinc Liu", @"i@RincLiu.com", nil]];
    [localNotification setUserInfo:dic];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)printNotificationDicInfo:(NSDictionary *)dic
{
    for(NSString *key in dic)
    {
        NSLog(@"%@:%@", key, [dic objectForKey:key]);
    }
}
                                                              
@end
