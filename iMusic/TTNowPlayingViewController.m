//
//  TTNowPlayingViewController.m
//  iMusic
//
//  Created by Dan Meehan on 10/14/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTNowPlayingViewController.h"
#import "TTSong.h"

@interface TTNowPlayingViewController ()

@property (strong, nonatomic) TTSong *currentSong;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation TTNowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *currentSongPath = [NSURL URLWithString: self.currentSong.songURL];
    self.audioPlayer = [[AVPlayer alloc] initWithURL: currentSongPath];
    [self.audioPlayer play];
    

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

@end
