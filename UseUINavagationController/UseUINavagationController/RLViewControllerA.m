//
//  RLViewController.m
//  UseUINavagationController
//
//  Created by RincLiu on 5/2/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewControllerA.h"
#import "RLViewControllerB.h"

@interface RLViewControllerA ()

@end

@implementation RLViewControllerA

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor blueColor]];
    [self setTitle:@"This is Page A"];
    UIBarButtonItem *bbItemNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNextNavButton:)];
    [self.navigationItem setRightBarButtonItem:bbItemNext];
}

- (IBAction)onClickNextNavButton:(id)sender {
    RLViewControllerB *viewControllerB = [[RLViewControllerB alloc]init];
    [self.navigationController pushViewController:viewControllerB animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
