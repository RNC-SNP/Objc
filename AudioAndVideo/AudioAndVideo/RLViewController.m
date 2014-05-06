//
//  RLViewController.m
//  AudioAndVideo
//
//  Created by RincLiu on 5/6/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//[self initViews];
    //[self initAudioPlayerWithAudioFileName:@"Here to Stay" andFileType:@"mp3"];
    [self playMovieWithURLString:@"http://www.boisestatefootball.com/sites/default/files/videos/original/01%20-%20coach%20pete%20bio_4.mp4"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init views:

-(void)initViews
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btn setFrame:CGRectMake((screenFrame.size.width-60)/2, 100, 60, 20)];
    [_btn setTitle:@"Play" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor lightGrayColor]];
    [_btn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 200, screenFrame.size.width, 20)];
    _slider.minimumValue = 0;
    _slider.maximumValue = 100;
    _slider.value = 100;
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(onSlide:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

-(void)setButtonTitle:(NSString*)title
{
    [_btn setTitle:title forState:UIControlStateHighlighted];
    [_btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Handle events of views:

- (IBAction)onClickPlay:(id)sender {
    if([_audioPlayer isPlaying])
    {
        [_audioPlayer pause];
        [self setButtonTitle:@"Play"];
    }
    else
    {
        [_audioPlayer play];
        [self setButtonTitle:@"Pause"];
    }
}

- (IBAction)onSlide:(id)sender
{
    [_audioPlayer setVolume:_slider.value/100];
}

#pragma mark - Init AudioPlayer:

-(void)initAudioPlayerWithAudioFileName:(NSString*)fileName andFileType:(NSString*)fileType
{
    NSString *audioFilePath = [[NSBundle mainBundle]pathForResource:fileName ofType:fileType];
    NSURL *audioFileURL = [[NSURL alloc]initFileURLWithPath:audioFilePath];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioFileURL error:nil];
    [_audioPlayer setVolume:1.0];
    [_audioPlayer prepareToPlay];
    [_audioPlayer setDelegate:self];
}

#pragma mark - Methods in AVAudioPlayerDelegate protocol:

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"Player begin interruption.");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Player decode error occured.");
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Player finished playing.");
    [self setButtonTitle:@"Play"];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"Player end interruption.");
}

#pragma mark - Init MPMoviePlayerController:

-(void)playMovieWithURLString:(NSString*)URLStr
{
    NSURL *URL = [[NSURL alloc]initWithString:URLStr];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:URL];
    [moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    [[moviePlayer view]setFrame:self.view.bounds];
    [[moviePlayer view]setBackgroundColor:[UIColor greenColor]];
    [[moviePlayer backgroundView]setBackgroundColor:[UIColor whiteColor]];
    [moviePlayer setControlStyle:MPMovieControlModeDefault];
    [moviePlayer setScalingMode:MPMovieScalingModeNone];
    [moviePlayer setRepeatMode:MPMovieRepeatModeNone];
    [self.view addSubview:[moviePlayer view]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFinishedPlayingMovie:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    [moviePlayer play];
}

#pragma mark - Handle MPMoviePlayerController notification:

-(void)onFinishedPlayingMovie:(NSNotification*)notification
{
    MPMoviePlayerController *moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    NSLog(@"Finished movie playing.");
}

@end
