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
    
    // Get instance of audio player and start playing
    AudioPlayer *music = [AudioPlayer getPlayer];
    [music startPlayer];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    self.currentSong = music.nowPlaying;
    [self.playPause setSelected:YES];
    
    // Set UI for current song
    [self setUI];
    
    // Notify when a new player item begins
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSong:) name:@"nextSong" object:nil];
    
    // Store song data to Parse
    [self storeData];
}

// Set UI elements to reflect current song
- (void) setUI {
    // Display song info and cover art
    if (self.currentSong.songURL != nil) {
        self.songLabel.text = self.currentSong.songTitle;
        self.artistLabel.text = self.currentSong.artist;
    } else {
        self.songLabel.text = @"Error: song not found on device";
        self.artistLabel.text = @"";
    }
    
    // Set max value for duration slider
    int songDur = self.currentSong.duration.intValue;
    [self.durSlider setMaximumValue:songDur];
    int songMins = (int) songDur / 60;
    int songSecs = (int) songDur % 60;
    self.durLabel.text = [NSString stringWithFormat:@"%02d:%02d", songMins, songSecs];
    
    
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    MPMediaItemArtwork *itemArtwork = self.currentSong.artwork;
    
    if (itemArtwork != nil) {
        albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        self.artwork.image = resizedImage;
    } else { // no album artwork
        //NSLog(@"No ALBUM ARTWORK");
        self.artwork.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
}

// Slider drag action to seek to a specific time in the song
- (IBAction)sliderDragged:(id)sender {
    AudioPlayer *music = [AudioPlayer getPlayer];
    music.musicPlayer.currentTime = _durSlider.value;
}

// Update slider and song timer
- (void)updateTime:(NSTimer *)timer {
    AudioPlayer *music = [AudioPlayer getPlayer];
    int time = music.musicPlayer.currentTime;
    _durSlider.value = time;
    _curDurLabel.text = [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
}

// Store the current song data to Parse for Facebook integration
-(void) storeData {

    PFObject *song = [PFObject objectWithClassName:@"Song"];
    [song setObject:[PFUser currentUser] forKey:@"user"];
    [song setObject:self.currentSong.songTitle forKey:@"title"];
    [song setObject:self.currentSong.album forKey:@"album"];
    [song setObject:self.currentSong.artist forKey:@"artist"];
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    MPMediaItemArtwork *itemArtwork = [self.currentSong artwork];
    
    if (itemArtwork != nil) {
        NSLog(@"found art");
        albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8);
        // Save artwork image in Parse
        PFFile *photoFile = [PFFile fileWithData:imageData];
        [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Artwork saved");
                
                [song setObject:photoFile forKey:@"artwork"];
                [song saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Song saved successfully");
                    }
                }];
            }
        }];
    } else { // no album artwork
        NSLog(@"No ALBUM ARTWORK");
        /*cell.imageView.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];*/
        [song saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Song saved successfully");
            }
        }];
    }
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

// Play or pause music when button tapped
- (IBAction)togglePlayPause:(id)sender {
    
    AudioPlayer *music = [AudioPlayer getPlayer];
    if (self.playPause.selected) {
        [music pause];
    } else {
        [music play];
    }
    self.playPause.selected = !self.playPause.selected;
}


// Change song info when new song starts
- (void) changeSong:(NSNotification *)note {
    AudioPlayer *music = [AudioPlayer getPlayer];
    NSLog(@"Updating player UI");
    self.currentSong = [music nowPlaying];
    [self setUI];
}

@end
