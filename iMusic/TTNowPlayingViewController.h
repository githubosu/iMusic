//
//  TTNowPlayingViewController.h
//  iMusic
//
//  Created by Dan Meehan on 10/14/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TTSong.h"
#import "AudioPlayer.h"

@interface TTNowPlayingViewController : UIViewController

@property (strong, nonatomic) TTSong *currentSong;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artwork;

@property (weak, nonatomic) IBOutlet UISlider *durSlider;
@property (weak, nonatomic) IBOutlet UILabel *durLabel;
@property (weak, nonatomic) IBOutlet UILabel *curDurLabel;

@property (strong, nonatomic) IBOutlet UIButton *playPause;
@property (strong, nonatomic) IBOutlet UIButton *shuffle;
@property (strong, nonatomic) IBOutlet UIButton *nextSong;
@property (strong, nonatomic) IBOutlet UIButton *prevSong;

@end
