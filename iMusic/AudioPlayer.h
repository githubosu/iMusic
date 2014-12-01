//  An audio player developed using a singleton pattern to prevent overlapping playback
//  from multiple AVPlayer instances
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

@interface AudioPlayer : AVAudioPlayer

@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) NSMutableArray *songQueue;
@property (nonatomic, strong) NSMutableArray *shuffleQueue;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL shuffle;

+ (id)getPlayer;
- (TTSong*) dequeue;
- (void) enqueue: (TTSong*) song;
- (void) setQueue: (NSArray*) songs;
- (void) setIndex: (int) index;
- (TTSong*) nowPlaying;
- (void) play;
- (void) pause;
- (void) startPlayer;
- (void) nextSong;
- (void) prevSong;
- (void) shufflePlayer;

@end