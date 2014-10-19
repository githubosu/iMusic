//
//  TTAlbumViewCell.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/19/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAlbumViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumArtworkImage;
@property (strong, nonatomic) IBOutlet UILabel *albumTitle;
@property (strong, nonatomic) IBOutlet UILabel *songCountLabel;

@end
