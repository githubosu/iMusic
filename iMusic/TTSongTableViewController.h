//
//  TTSongTableViewController.h
//  iMusic
//
//  Created by Thanh Trinh on 9/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;
@interface TTSongTableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
