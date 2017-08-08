//
//  ViewController.m
//  Bluetooth
//
//  Created by RincLiu on 01/08/2017.
//  Copyright © 2017 RINC. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManager.h"

@interface ViewController ()
@property (nonatomic,strong) BluetoothManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [BluetoothManager shared];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
