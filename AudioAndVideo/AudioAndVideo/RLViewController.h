//
//  RLViewController.h
//  AudioAndVideo
//
//  Created by RincLiu on 5/6/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RLViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) UISlider *slider;

@end
