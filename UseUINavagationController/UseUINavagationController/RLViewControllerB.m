//
//  RLViewControllerBViewController.m
//  UseUINavagationController
//
//  Created by RincLiu on 5/2/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewControllerB.h"

@interface RLViewControllerB ()

@end

@implementation RLViewControllerB

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor greenColor]];
    [self setTitle:@"This is Page B"];
    UIBarButtonItem *bbItemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackNavButton:)];
    [self.navigationItem setLeftBarButtonItem:bbItemBack];
}

- (IBAction)onClickBackNavButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
