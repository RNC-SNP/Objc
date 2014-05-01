//
//  RLDataViewController.m
//  UseUISearchBar
//
//  Created by RincLiu on 5/1/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLDataViewController.h"

@interface RLDataViewController ()

@end

@implementation RLDataViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
