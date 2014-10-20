//
//  TTSong.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;
@interface TTSong : NSObject
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) MPMediaItemArtwork *artwork;
@property (nonatomic, assign) long duration;
@property (nonatomic, strong) NSURL *songURL;

@end
