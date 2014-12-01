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
    _shuffleQueue = [[NSMutableArray alloc] initWithArray:songs];
    
    // Randomly sort the shuffled queue
    [_shuffleQueue sortUsingComparator: ^(id obj1, id obj2) {
        int r = arc4random() % 2;
        if (r == 0) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];
}

// Set the index to desired value
- (void) setIndex:(int) index {
    _index = index;
}

// Get current song
- (TTSong*) nowPlaying {
    if (_shuffle) {
        return [_shuffleQueue objectAtIndex:_index];
    } else {
        return [_songQueue objectAtIndex:_index];
    }
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
    NSURL *url;
    
    // Choose between the normal or shuffled queue
    if (_shuffle) {
        url = [[_shuffleQueue objectAtIndex:_index] songURL];
        NSLog(@"Starting Player shuffle: %@", [[_shuffleQueue objectAtIndex:_index] songTitle]);
    } else {
        url = [[_songQueue objectAtIndex:_index] songURL];
        NSLog(@"Starting Player normal: %@", [[_songQueue objectAtIndex:_index] songTitle]);
    }
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

// Rewind the music player to the beginning of the song or
// the previous song in the queue (or to the end)
- (void) prevSong {
    [_musicPlayer stop];
    
    if ([_musicPlayer currentTime] > 5) {
        [self startPlayer];
    } else {
        _index -= 1;
        if (_index < 0) _index = [_songQueue count] - 1;
        [self startPlayer];
    }
}

// Switch back and forth betrween the shuffle queue and regular queue
- (void) shufflePlayer {
    TTSong *curr = [self nowPlaying];
    _shuffle = !_shuffle;
    if (_shuffle) {
        _index = [_shuffleQueue indexOfObject:curr];
    } else {
        _index = [_songQueue indexOfObject:curr];
    }
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