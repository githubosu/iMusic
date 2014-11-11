//
//  TTFriendSongTableViewCell.h
//  iMusic
//
//  Created by Thanh Trinh on 11/11/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTFriendSongTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumArtworkImage;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;

@end
