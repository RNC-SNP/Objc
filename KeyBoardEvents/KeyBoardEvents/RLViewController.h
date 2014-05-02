//
//  RLViewController.h
//  KeyBoardEvents
//
//  Created by RincLiu on 5/2/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) BOOL isKeyboardShown;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITextField *textFieldA, *textFieldB, *activeTextField;

// Methods in UITextFieldDelegate Protocol:
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;

@end
