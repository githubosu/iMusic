//
//  TTAlbum.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/19/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;

@interface TTAlbum : NSObject
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, assign) NSInteger songCount;
@property (nonatomic, strong) MPMediaItemArtwork *artwork;
@property (nonatomic, strong) NSNumber *albumPersistentId;
@property (nonatomic, assign) long duration;
@end
