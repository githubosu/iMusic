//
//  TTAlbumArtistTableViewController.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/19/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSong.h"
#import "TTAlbum.h"
#import "TTArtist.h"
#import "TTAlbumArtistSongViewCell.h"
@interface TTAlbumArtistTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIImageView *artwork;
@property (strong, nonatomic) IBOutlet UILabel *aTitle;
@property (strong, nonatomic) IBOutlet UILabel *songCount;
@property (strong, nonatomic) TTAlbum *album;
@property (strong, nonatomic) TTArtist * artist;
@end
