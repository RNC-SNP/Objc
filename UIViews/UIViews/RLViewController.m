//
//  RLViewController.m
//  UIViews
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelUser;

@property (weak, nonatomic) IBOutlet UITextField *textfieldUser;

@property (weak, nonatomic) IBOutlet UIImageView *iv;

- (IBAction)sayHello:(id)sender;

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init views:

-(void)initViews
{
    // Setup UILabel:
    [_labelUser setText: @"UIView Usage..."];
    [_labelUser setTextColor:[UIColor orangeColor]];
    [_labelUser setFont:[UIFont boldSystemFontOfSize:12]];
    [_labelUser setTextAlignment: NSTextAlignmentCenter];
    [_labelUser adjustsFontSizeToFitWidth];
    [_labelUser setNumberOfLines: 1];
    [_labelUser setHighlighted:YES];
    [_labelUser setHighlightedTextColor:[UIColor greenColor]];
    [_labelUser setShadowColor:[UIColor brownColor]];
    
    // Setup UIImageView:
    NSURL *url = [NSURL URLWithString:@"http://www.gravatar.com/avatar/5e9ae16f24dfb6fbdf494e8c3c9d6973"];
    [_iv setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]]];
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

#pragma mark - Called when the Return button of keyboard is clicked:

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
