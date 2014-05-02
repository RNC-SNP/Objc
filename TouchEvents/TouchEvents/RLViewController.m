//
//  RLViewController.m
//  TouchEvents
//
//  Created by RincLiu on 5/2/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// Handle touch events:
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchs:touches withEvent:event byTag:@"Began"];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchs:touches withEvent:event byTag:@"Moved"];}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchs:touches withEvent:event byTag:@"Ended"];
    
    if([touches count] == [[event touchesForView:self.view]count])
    {
        NSLog(@"Last finger has lifted...");
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchs:touches withEvent:event byTag:@"Canceled"];
}

-(void)handleTouchs:(NSSet *)touches withEvent:(UIEvent *)event byTag:(NSString*)tag
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"%@->x:%f,y:%f,TouchTapCount:%d,EventType:%d,EventSubTyoe:%d,EventTimestamp:%f", tag, point.x, point.y, touch.tapCount, event.type, event.subtype, event.timestamp);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
