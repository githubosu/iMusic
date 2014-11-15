//
//  TTFriendSongTableViewController.h
//  iMusic
//
//  Created by Thanh Trinh on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFriendSongTableViewCell.h"


@interface TTFriendSongTableViewController : UITableViewController
@property(strong, nonatomic)PFUser *friendUser;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlPressed:(UISegmentedControl *)sender;

@end
