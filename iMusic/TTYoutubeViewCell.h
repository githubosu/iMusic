//
//  TTYoutubeViewCell.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 11/11/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTYoutubeViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *videoDescription;

@end
