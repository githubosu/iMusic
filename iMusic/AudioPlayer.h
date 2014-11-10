//
//  AudioPlayer.h
//  iMusic
//
//  Created by Dan Meehan on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#ifndef iMusic_AudioPlayer_h
#define iMusic_AudioPlayer_h


#endif

#import <AVFoundation/AVFoundation.h>
#import "TTSong.h"

@interface AudioPlayer : AVQueuePlayer

@property (nonatomic, strong) AVQueuePlayer *musicPlayer;
@property (nonatomic, strong) TTSong *currentSong;
@property (nonatomic, strong) NSMutableArray *songQueue;

+ (id)getPlayer;

@end