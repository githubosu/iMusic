//
//  TTArtist.h
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;

@interface TTArtist : NSObject
@property (nonatomic, strong) NSString *artistTitle;
@property (nonatomic, assign) NSInteger albumCount;
@property (nonatomic, assign) NSInteger songCount;
@property (nonatomic, strong) MPMediaItemArtwork *artwork;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSNumber *artistPersistentId;
@end
