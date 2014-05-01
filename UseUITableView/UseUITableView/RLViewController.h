//
//  RLViewController.h
//  UseUITableView
//
//  Created by RincLiu on 5/1/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *sectionArray, *dataArray;

// Methods of UITableViewDataSource Protocol:
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// Methods od UITableViewDelegate Protocol:
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

@end
