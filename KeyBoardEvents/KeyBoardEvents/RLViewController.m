//
//  RLViewController.m
//  KeyBoardEvents
//
//  Created by RincLiu on 5/2/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    // Init ScrollView:
    _scrollView = [[UIScrollView alloc]initWithFrame:screenFrame];
    [_scrollView setContentSize:CGSizeMake(screenFrame.size.width, 1000)];
	
    // Init TextFieldA:
    _textFieldA = [[UITextField alloc]initWithFrame:CGRectMake(10, screenFrame.size.height-80, screenFrame.size.width-20, 30)];
    [_textFieldA setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldA setPlaceholder:@"This TextField A..."];
    [_textFieldA setDelegate:self];
    
    // Init TextFieldB:
    _textFieldB = [[UITextField alloc]initWithFrame:CGRectMake(10, screenFrame.size.height-40, screenFrame.size.width-20, 30)];
    [_textFieldB setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldB setPlaceholder:@"This TextField B..."];
    [_textFieldB setDelegate:self];
    
    // Register keyboard notifications:
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    // Add views:
    [_scrollView addSubview:_textFieldA];
    [_scrollView addSubview:_textFieldB];
    [self.view addSubview:_scrollView];
}

// Methods in UITextFieldDelegate Protocol:
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeTextField = nil;
}

// Called when the Return button of keyboard is clicked.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    [theTextField resignFirstResponder];
    return YES;
}

// Handle keyboard events:
-(void)keyboardWasShown:(NSNotification*)notification
{
    if(_isKeyboardShown || _activeTextField == nil)
    {
        return;
    }
    // Resize the textfield's parent(the scrollview):
    CGRect svFrame = [_scrollView frame];
    svFrame.size.height -= [self getKeyBoardHeightFromNotification:notification];
    [_scrollView setFrame:svFrame];
    // Reset the textfield's position:
    CGRect tfFrame = [_activeTextField frame];
    [_scrollView scrollRectToVisible:tfFrame animated:YES];
    _isKeyboardShown = YES;
}

-(void)keyboardWasHidden:(NSNotification*)notification
{
    // Resize the textfield's parent(the scrollview):
    CGRect svFrame = [_scrollView frame];
    svFrame.size.height += [self getKeyBoardHeightFromNotification:notification];
    [_scrollView setFrame:svFrame];
    _isKeyboardShown = NO;
}

// Read keyboard height from notification:
-(CGFloat)getKeyBoardHeightFromNotification:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size;
    return keyboardSize.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
