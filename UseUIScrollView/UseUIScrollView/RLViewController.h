//
//  RLViewController.h
//  UseUIScrollView
//
//  Created by RincLiu on 5/1/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController <UIScrollViewDelegate>

// Methods in UIScrollViewDelegate Protocol:

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view;

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;

-(void)scrollViewDidZoom:(UIScrollView *)scrollView;

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
