//
//  TTNowPlayingViewController.m
//  iMusic
//
//  Created by Dan Meehan on 10/14/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTNowPlayingViewController.h"
#import "UIImage+Resize.h"
@import MediaPlayer;


@interface TTNowPlayingViewController ()


@end

@implementation TTNowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Start playing audio
    NSURL *currentSongPath = self.currentSong.songURL;
    self.audioPlayer = [[AVPlayer alloc] initWithURL: currentSongPath];
    NSLog(@"Player URL: %@", self.currentSong.songURL);
    [self.audioPlayer play];
    [self.playPause setSelected:YES];
    NSLog(@"%d", self.playPause.selected);
    
    //Display song info and cover art
    if (self.currentSong.songURL != nil) {
        self.songLabel.text = self.currentSong.songTitle;
        self.artistLabel.text = self.currentSong.artist;
    } else {
        self.songLabel.text = @"Error: song not found on device";
        self.artistLabel.text = @"";
    }
    
    self.artwork = NULL;
    
    //Set max value for duration slider
    int songDur = self.currentSong.duration.intValue;
    [self.durSlider setMaximumValue:songDur];
    int songMins = (int) songDur / 60;
    int songSecs = (int) songDur % 60;
    self.durLabel.text = [NSString stringWithFormat:@"%02d:%02d", songMins, songSecs];

    
    MPMediaItemArtwork *itemArtwork = self.currentSong.artwork;

    UIImage *resizedImage = NULL;
    
    [self loopPlayer];
}

//Slider drag action to seek to a specific time in the song
- (IBAction)sliderDragged:(id)sender {
    [self.audioPlayer seekToTime:CMTimeMakeWithSeconds((int)(self.durSlider.value) , 1)];
}

//Loop to update UI with current song playback info
-(void) loopPlayer {
    __block TTNowPlayingViewController * weakSelf = self;

    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:NULL usingBlock:^(CMTime time) {
        if(!time.value) {return;}
        int curTime = (int)((weakSelf.audioPlayer.currentTime.value)/weakSelf.audioPlayer.currentTime.timescale);
        int curMins = (int)(curTime/60);
        int curSecs = (int)(curTime%60);
        weakSelf.curDurLabel.text = [NSString stringWithFormat:@"%02d:%02d",curMins,curSecs];
        weakSelf.durSlider.value = curTime;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Play or pause music when button tapped
- (IBAction)togglePlayPause:(id)sender {
    if (self.playPause.selected) {
        [self.audioPlayer pause];
    } else {
        [self.audioPlayer play];
    }
    self.playPause.selected = !self.playPause.selected;
}
@end
