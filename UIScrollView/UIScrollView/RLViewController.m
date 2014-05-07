//
//  RLViewController.m
//  UseUIScrollView
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
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [scrollView setBackgroundColor:[UIColor yellowColor]];
    [scrollView setScrollsToTop:YES];
    [scrollView setDelegate:self];
    [scrollView setContentSize:CGSizeMake(320, 10000)];
    [scrollView setBounces:YES];
    [scrollView setPagingEnabled:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [scrollView setContentInset:UIEdgeInsetsMake(0, 50, 50, 0)];
    [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [scrollView flashScrollIndicators];
    [scrollView setDirectionalLockEnabled:YES];
    [scrollView setContentOffset:CGPointMake(0, 345) animated:true];
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
    label.backgroundColor = [UIColor greenColor];
    label.text = @"This is a UILabel in UIScrollView...";
    [scrollView addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods in UIScrollViewDelegate Protocol:

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"TOP!");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrolling...");
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"drag begin.");
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"drag end.");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scroll end at: %f,%f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

@end
