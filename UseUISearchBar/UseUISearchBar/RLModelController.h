//
//  RLModelController.h
//  UseUISearchBar
//
//  Created by RincLiu on 5/1/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLDataViewController;

@interface RLModelController : NSObject <UIPageViewControllerDataSource>

- (RLDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(RLDataViewController *)viewController;

@end
