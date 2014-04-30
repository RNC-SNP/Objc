//
//  RLViewController.m
//  UseUIScrollView
//
//  Created by RincLiu on 5/1/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scrollView setBackgroundColor:[UIColor greenColor]];
    [_scrollView setScrollsToTop:YES];
    [_scrollView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(320, 10000)];
    [_scrollView setBounces:YES];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    [_scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 50, 50, 0)];
    [_scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [_scrollView flashScrollIndicators];
    [_scrollView setDirectionalLockEnabled:YES];
    [_scrollView setContentOffset:CGPointMake(0, 345) animated:true];
    [self.view addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"This is a UILabel in UIScrollView...";
    [_scrollView addSubview:label];
}

// Methods in UIScrollViewDelegate Protocol:

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
