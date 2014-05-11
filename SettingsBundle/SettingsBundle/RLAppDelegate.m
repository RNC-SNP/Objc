//
//  RLAppDelegate.m
//  SettingsBundle
//
//  Created by RincLiu on 5/11/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLAppDelegate.h"

@implementation RLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self readUserDefaults];
    [self modifyUserDefaults];
    [self readUserDefaults];
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SettingsBundle(UserDefaults) operations:

-(void)checkUserDefaultsForKey:(NSString*)prefKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // If the key is nil:
    if (![defaults objectForKey:prefKey])
    {
        // Read plist file's path from MainBundle:
        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *plistPath = [mainBundlePath stringByAppendingPathComponent:@"Settings.bundle/Root.plist"];
        // Read dictionary from plist file:
        NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        // Read Preferences array from dictionary:
        NSMutableArray *prefArray = [plistDic objectForKey:@"PreferenceSpecifiers"];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        // Travel all properties:
        for(int i = 0; i < [prefArray count]; i++)
        {
            NSString *key = [[prefArray objectAtIndex:i] objectForKey:@"Key"];
            if(key)
            {// Write property's default key to dic:
                id value = [[prefArray objectAtIndex:i] objectForKey:@"DefaultValue"];
                [newDic setObject:value forKey:key];
            }
        }
        // Save UserDefaults:
        [defaults registerDefaults:newDic];
        [defaults synchronize];
    }
}

- (void)readUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self checkUserDefaultsForKey:@"pref_name"];
    
    NSLog(@"Name: %@", [defaults stringForKey:@"pref_name"]);
    NSLog(@"Verified: %hhd", [defaults boolForKey:@"pref_verified"]);
    NSLog(@"Level: %d", [defaults integerForKey:@"pref_level"]);
    NSLog(@"Language: %@", [defaults stringForKey:@"pref_lang"]);
}

- (void)modifyUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:@"Richard Lew" forKey:@"pref_name"];
    [defaults setBool:NO forKey:@"pref_verified"];
    [defaults setInteger:9 forKey:@"pref_level"];
    [defaults setValue:@"en" forKey:@"pref_lang"];
}

@end
