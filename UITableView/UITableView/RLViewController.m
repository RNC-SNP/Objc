//
//  RLViewController.m
//  UseUITableView
//
//  Created by RincLiu on 5/1/14.
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
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, screenFrame.size.width, screenFrame.size.height)];
    _sectionArray = [[NSArray alloc] initWithObjects:@"Desktop OS", @"Mobile OS", nil];
    _dataArray = [NSArray arrayWithObjects:
                  [NSArray arrayWithObjects:@"Linux", @"OS X", @"Windows", @"Unix", @"Ubuntu", @"Debian", @"CenOS", @"Solaris", @"Arch Linux", @"FreeBSD", nil],
                  [NSArray arrayWithObjects:@"Android", @"iOS", @"WindowsPhone", @"WindowsMobile", @"BlackBerry", @"Symbian", @"MeeGo", @"Palm OS", @"WebOS", @"Tizen", @"Sailfish OS", @"Ubuntu Touch OS", @"Maemo", nil],
                  nil];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
	[self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods of UITableViewDataSource Protocol:

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionArray objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section]count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rowId = @"rowId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowId];
    }
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    [cell.textLabel setText:[[_dataArray objectAtIndex:section] objectAtIndex:row]];
    return cell;
}

#pragma mark - Methods od UITableViewDelegate Protocol:

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
