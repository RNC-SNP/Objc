//
//  RLAppDelegate.h
//  UIViews
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIWindow *window;

// Methods in UIAlertViewDelegate Protocol:
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

// Methods in UIActionSheetDelegate Protocol:
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
