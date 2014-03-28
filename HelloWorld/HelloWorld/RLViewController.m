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
	// Do any additional setup after loading the view, typically from a nib.
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
}

// UIKit框架定义的方法，当用户按下键盘返回按钮时调用
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    if(theTextField==self.textfieldUser){
        // 发送消息，强制textfield失去FirstResponder，进而隐藏键盘
        [theTextField resignFirstResponder];
    }
    return YES;
}
@end
