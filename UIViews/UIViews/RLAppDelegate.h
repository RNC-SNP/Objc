//
//  RLAppDelegate.h
//  UIViews
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLAppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *pickerArray;

// Methods in UITabBarDelegate Protocol:
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

// Methods in UIAlertViewDelegate Protocol:
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Methods in UIActionSheetDelegate Protocol:
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

// Methods in UIPickerViewDataSource Protocol:
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

// Methods in UIPickerDelegate Protocol:
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
