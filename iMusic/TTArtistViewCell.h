//
//  TTArtistViewCell.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTArtistViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *albumSongCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistTitle;

@property (strong, nonatomic) IBOutlet UIImageView *artistArtworkImage;


@end
