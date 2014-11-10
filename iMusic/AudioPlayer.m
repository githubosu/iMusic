//  An audio player developed using a singleton pattern to prevent overlapping playback
//  from multiple AVPlayer instances
//
//  AudioPlayer.m
//  iMusic
//
//  Created by Dan Meehan on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

// Get the singleton player instance
+ (id)getPlayer {
    static AudioPlayer *instance = nil;
    @synchronized(self) {
        if (instance == nil)
    instance = [[self alloc] init];
    }
    return instance;
}

// Dequeue the first item from the song queue
- (TTSong*) dequeue {
    TTSong *first = [_songQueue objectAtIndex:0];
    [_songQueue removeObjectAtIndex:0];
    return first;
}

// Enqueue a new song
- (void) enqueue: (TTSong*) song {
    [_songQueue insertObject: song atIndex: [_songQueue count]];
}

// Clear play queue
- (void) clearQueue {
    [_musicPlayer removeAllItems];
}

@end