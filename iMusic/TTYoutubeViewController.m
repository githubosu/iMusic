//
//  TTYoutubeViewController.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTYoutubeViewController.h"

@interface TTYoutubeViewController ()

@end

@implementation TTYoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
    
    // For a full list of player parameters, see the documentation for the HTML5 player
    // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
    NSDictionary *playerVars = @{
                                 @"controls" : @2,
                                 @"playsinline" : @0,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };
    /*NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };*/
    self.playerView.delegate = self;
    if(self.youtube != nil) {
        self.videoTitleLabel.text = self.youtube.videoTitle;
        [self.playerView loadWithVideoId:self.youtube.videoId playerVars:playerVars];
    } else {
        NSLog(@"No video id found.");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying: {
            NSLog(@"Started playback");
            // Storing data to Parse
            PFObject *video = [PFObject objectWithClassName:@"Youtube"];
            [video setObject:[PFUser currentUser] forKey:@"user"];
            [video setObject:self.youtube.videoTitle forKey:@"videoTitle"];
            [video setObject:self.youtube.videoDescription forKey:@"videoDescription"];
            [video setObject:self.youtube.videoId forKey:@"videoId"];
            [video setObject:self.youtube.thumbnailURL forKey:@"thumbnailURL"];
            // Get FbId
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userDictionary = (NSDictionary *)result;
                    NSString *facebookID = userDictionary[@"id"];
                    NSLog(@"FB ID: %@", facebookID);
                    [video setObject:facebookID forKey:@"fbId"];
                }
                [video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Video saved successfully in Parse.");
                    }
                }];
            }];
    
            break;
        }
        case kYTPlayerStatePaused: {
            NSLog(@"Paused playback");
            break;
        }
        default:
            break;
    }
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
