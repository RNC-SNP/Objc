//
//  RLViewController.m
//  HelloWorld
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUser;

@property (weak, nonatomic) IBOutlet UITextField *textfieldUser;

- (IBAction)sayHello:(id)sender;

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup Label:
    [_labelUser setText: @"UIView Usage..."];
    [_labelUser setTextColor:[UIColor orangeColor]];
    [_labelUser setFont:[UIFont boldSystemFontOfSize:15]];
    [_labelUser setTextAlignment: NSTextAlignmentCenter];
    [_labelUser adjustsFontSizeToFitWidth];
    [_labelUser setNumberOfLines: 1];
    [_labelUser setHighlighted:YES];
    [_labelUser setHighlightedTextColor:[UIColor greenColor]];
    [_labelUser setShadowColor:[UIColor brownColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sayHello:(id)sender {
    self.username=self.textfieldUser.text;
    if([self.username length]>0){
        NSString *greetingStr=[[NSString alloc]initWithFormat:@"Hello, %@!",self.username];
        self.labelUser.text=greetingStr;
    }else{
        self.labelUser.text=@"Please type your name below...";
    }
    [self hideKeyboard:_textfieldUser];
}

// Called when the Return button of keyboard is clicked.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    if(theTextField == self.textfieldUser){
        [self hideKeyboard:theTextField];
    }
    return YES;
}


- (void) hideKeyboard: (UITextField *)theTextField{
    // Let the textfield give up first responder to hide keyboard.
    // Just like 'setFocusableInTouchMode(false)' in Android.
    [theTextField resignFirstResponder];
}
@end
