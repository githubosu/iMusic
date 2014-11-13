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
        if (instance == nil) {
            instance = [[self alloc] init];
        }
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
    [_songQueue addObject: song];
}

// Set player queue from given array
- (void) setQueue:(NSArray*)songs {
    _songQueue = [[NSMutableArray alloc] initWithArray:songs];
}

// Set the index to desired value
- (void) setIndex:(int) index {
    _index = index;
}

// Get current song
- (TTSong*) nowPlaying {
    return [_songQueue objectAtIndex: _index];
}

// Play music player
- (void) play {
    [_musicPlayer play];
}

// Pause music player
- (void) pause {
    [_musicPlayer pause];
}

// Start music player from the current index in the queue
- (void) startPlayer {
    NSURL *url = [[_songQueue objectAtIndex:_index] songURL];
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [_musicPlayer play];
    
    // Set delegate to implement song switching
    [_musicPlayer setDelegate: (id)self];
}

// Advance the music player to the next song in the queue (or back to the beginning)
- (void) nextSong {
    [_musicPlayer stop];
    _index = (_index + 1) % [_songQueue count];
    [self startPlayer];
}

// Advance to the next song when one song is completed
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Finished song");
    if (flag) {
        [self nextSong];
        
        // Post notification to update player UI
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextSong" object:nil];
        
    }
}

@end