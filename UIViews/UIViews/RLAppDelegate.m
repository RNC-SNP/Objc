//
//  RLAppDelegate.m
//  UIViews
//
//  Created by RincLiu on 3/9/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLAppDelegate.h"

@implementation RLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createCustomView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Create custom views with code:

- (void)createCustomView
{
    // Get screen frame:
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    // Init UIWindow:
    self.window = [[UIWindow alloc] initWithFrame:screenFrame];
    self.window.backgroundColor = [UIColor greenColor];
    
    // Init UIViewController and rootview:
    UIViewController *controller = [[UIViewController alloc] init];
    self.window.rootViewController = controller;
    UIView *rootView = [[UIView alloc]initWithFrame:screenFrame];
    controller.view = rootView;
    
    // Use UINavigationBar:
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, screenFrame.size.width, 48)];
    [navBar setBarStyle:UIBarStyleDefault];
    [navBar setBackgroundColor:[UIColor blueColor]];
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@"UIViews' Usage"];
    UIBarButtonItem *bbItemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickBackNavButton:)];
    [navItem setLeftBarButtonItem:bbItemBack];
    UIBarButtonItem *bbItemSubmit = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(onClickSubmitNavButton:)];
    [navItem setRightBarButtonItem:bbItemSubmit];
    [navBar pushNavigationItem:navItem animated:YES];
    [rootView addSubview:navBar];
    
    // Use UIToolBar:
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 70, screenFrame.size.width, 33)];
    NSMutableArray *toolbarItemArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *barButtonItem0 = [[UIBarButtonItem alloc]initWithTitle:@"BarButton0" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBarButton0:)];
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc]initWithTitle:@"BarButton1" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBarButton1:)];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc]initWithTitle:@"BarButton2" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBarButton2:)];
    [toolbarItemArray addObject:barButtonItem0];
    [toolbarItemArray addObject:barButtonItem1];
    [toolbarItemArray addObject:barButtonItem2];
    [toolbar setItems:toolbarItemArray];
    [rootView addSubview:toolbar];
    
    [self addCommonViewsInRootView:rootView];
    
    // Use UITabBar:
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-48, screenFrame.size.width, 48)];
    [tabBar setBarStyle:UIBarStyleDefault];
    [tabBar setBackgroundColor:[UIColor blueColor]];
    [tabBar setDelegate:self];
    [tabBar setUserInteractionEnabled:YES];
    NSMutableArray *tabItemArray = [NSMutableArray array];
    [tabItemArray addObject:[[UITabBarItem alloc] initWithTitle:@"Tab0" image:nil tag:0]];
    [tabItemArray addObject:[[UITabBarItem alloc] initWithTitle:@"Tab1" image:nil tag:1]];
    [tabItemArray addObject:[[UITabBarItem alloc] initWithTitle:@"Tab2" image:nil tag:2]];
    [tabBar setItems:tabItemArray];
    [tabBar setSelectedItem:[tabItemArray objectAtIndex:0]];
    [rootView addSubview:tabBar];
    
    // Travel subViews:
    for(UIView *view in [rootView subviews]){
        NSLog(@"SubView: %@", view.description);
    }
    
    // Show UIVindow:
    [self.window makeKeyAndVisible];
}

-(void)addCommonViewsInRootView:(UIView *)rootView{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    // Use UIButton:
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(5, 108, 60, 20)];
    [btn setTitle:@"Click!" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:btn];
    [btn addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    // Use UIImageView:
    UIImageView *iv=[[UIImageView alloc]initWithFrame:CGRectMake(70, 108, 30, 30)];
    //[iv setImage:[UIImage imageNamed:@"avatar1.png"]];
    NSURL *url = [NSURL URLWithString:@"http://www.gravatar.com/avatar/5e9ae16f24dfb6fbdf494e8c3c9d6973"];
    [iv setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]]];
    [rootView addSubview:iv];
    
    // Use UIProgressView:
    UIProgressView *pv = [[UIProgressView alloc] initWithFrame:CGRectMake(5, 133, 60, 20)];
    [pv setProgressViewStyle:UIProgressViewStyleDefault];
    [pv setProgress:0.123456789];
    [rootView addSubview:pv];
    
    // Use UIActivityIndicatorView:
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(105, 103, 40, 40)];
    [aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [aiv startAnimating];
    [rootView addSubview:aiv];
    
    // Use UISwitch:
    UISwitch *swtch = [[UISwitch alloc]initWithFrame:CGRectMake(150, 111, 50, 25)];
    [swtch setOn:YES animated:YES];
    [swtch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [rootView addSubview:swtch];
    
    // Use UISlider:
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(205, 120, screenFrame.size.width-210, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = 1.23456789;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(onSlide:) forControlEvents:UIControlEventValueChanged];
    [rootView addSubview:slider];
    
    // Use UIPageControl:
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 158, screenFrame.size.width/2, 50)];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [pageControl setHidesForSinglePage:NO];
    [pageControl setDefersCurrentPageDisplay:YES];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [rootView addSubview:pageControl];
    
    // Use UITextField:
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(screenFrame.size.width/2, 150, screenFrame.size.width/2, 30)];
    [textfield setBorderStyle:UITextBorderStyleRoundedRect];
    [textfield setAutocorrectionType:UITextAutocorrectionTypeYes];
    [textfield setPlaceholder:@"Enter words..."];
    [textfield setClearsOnBeginEditing:YES];
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textfield setAdjustsFontSizeToFitWidth:YES];
    [textfield setDelegate:self];
    [rootView addSubview:textfield];
    
    // Use UIPickerView:
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(screenFrame.size.width/2, 190, screenFrame.size.width/2, 200)];
    [pickerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [pickerView setShowsSelectionIndicator:YES];
    _pickerArray = [[NSArray alloc] initWithObjects:@"Android", @"iOS", @"WindowsPhone", @"WindowsMobile", @"BlackBerry", @"Symbian", @"MeeGo", nil];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [rootView addSubview:pickerView];
    
    // Use UISearchBar:
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 400, screenFrame.size.width, 30)];
    [searchBar setDelegate:self];
    [searchBar setShowsCancelButton:YES];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setPlaceholder:@"Enter mail address..."];
    [searchBar setKeyboardType:UIKeyboardTypeEmailAddress];
    [rootView addSubview:searchBar];
    
    // Use UIWebView:
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 213, screenFrame.size.width/2, screenFrame.size.height-300)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://RincLiu.com"]]];
    [rootView addSubview:webView];
}

#pragma mark -  Methods in UITabBarDelegate Protocol:

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"You selected Item: %@", item.title);
}

#pragma mark - Methods in UIAlertViewDelegate Protocol:

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickedButtonAtIndex: %d", buttonIndex);
}

#pragma mark - Methods in UIActionSheetDelegate Protocol:

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickedButtonAtIndex: %d", buttonIndex);
}

#pragma mark - Methods in UIPickerViewDataSource Protocol:

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerArray objectAtIndex:row];
}

#pragma mark - Methods in UIPickerDelegate Protocol:

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self showMessage:[NSString stringWithFormat:@"You selected: %@", [_pickerArray objectAtIndex:row]]];
}

#pragma mark - Methods in UISearchBarDelegate Protocol:

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText: %@", searchText);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel button clicked");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
}

#pragma mark - Methods in UITextFieldDelegate Protocol:

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Began editing...");
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Ended editing...");
}

#pragma mark - Called when the Return button of keyboard is clicked.

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark - Handle touch events:

- (IBAction)onTouchUp:(id)sender {
    // Use UIActionSheet:
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You clicked!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, I'm sure." otherButtonTitles:@"AAAA",@"BBBB",@"CCCC", nil];
    [actionSheet showInView:_window];
}

- (IBAction)onClickBackNavButton:(id)sender {
    [self showMessage:@"Back Navigation Button was clicked!"];
}

- (IBAction)onClickSubmitNavButton:(id)sender {
    [self showMessage:@"Submit Navigation Button was clicked!"];
}

- (IBAction)onClickBarButton0:(id)sender {
    [self showMessage:@"BarButton0 was clicked!"];
}

- (IBAction)onClickBarButton1:(id)sender {
    [self showMessage:@"BarButton1 was clicked!"];
}

- (IBAction)onClickBarButton2:(id)sender {
    [self showMessage:@"BarButton2 was clicked!"];
}

- (IBAction)onSwitch:(id)sender {
    UISwitch *swtch = (UISwitch*)sender;
    [self showMessage:[[NSString alloc]initWithFormat:@"Switch state: %@", swtch.isOn ? @"ON" : @"OFF"]];
}

- (IBAction)onSlide:(id)sender {
    UISlider *slider = (UISlider*)sender;
    [self showMessage:[[NSString alloc]initWithFormat:@"Slider value: %f", slider.value]];
}

- (IBAction)changePage:(id)sender {
    UIPageControl *pageControl = (UIPageControl*)sender;
    [self showMessage:[[NSString alloc]initWithFormat:@"Current page: %d", pageControl.currentPage]];
}

#pragma mark - Use UIAlertView to show Message:

-(void)showMessage:(NSString *)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh..." message:msg delegate:self cancelButtonTitle:@"Calcel" otherButtonTitles:@"AAAA",@"BBBB",@"CCCC", nil];
    [alertView show];
}

@end
