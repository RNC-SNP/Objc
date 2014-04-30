//
//  RLAppDelegate.h
//  UIViews
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLAppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIWindow *window;

// Methods in UITabBarDelegate Protocol:
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

// Methods in UIAlertViewDelegate Protocol:
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Methods in UIActionSheetDelegate Protocol:
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
