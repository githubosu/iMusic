//
//  TTYoutubeViewController.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>
#import "TTYoutube.h"
@interface TTYoutubeViewController : UIViewController
@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) TTYoutube *youtube;
@end
