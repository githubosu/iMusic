//
//  TTAlbumArtistTableViewController.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/19/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTAlbumArtistTableViewController.h"
#import "TTNowPlayingViewController.h"
#import "UIImage+Resize.h"
@interface TTAlbumArtistTableViewController ()
@property (nonatomic, strong) NSMutableArray *songs;
@end

@implementation TTAlbumArtistTableViewController

- (NSMutableArray *) songs {
    if(!_songs) {
        _songs = [[NSMutableArray alloc]init];
    }
    return _songs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AlbumArtistTable View Loaded...");
    if(self.album != nil) {
        self.aTitle.text = self.album.albumTitle;
        NSString *minString = (self.album.duration > 1)?@"mins":@"min";
        NSString *songString = (self.album.songCount > 1)?@"songs":@"song";
        self.songCount.text = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)self.album.songCount, songString, (long)self.album.duration/60, minString];
        UIImage *albumArtworkImage = NULL;
        UIImage *resizedImage = NULL;
        MPMediaItemArtwork *itemArtwork = self.album.artwork;
        
        if (itemArtwork != nil) {
            albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
            resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
        }
        
        if (albumArtworkImage) {
            self.artwork.image = resizedImage;
        } else { // no album artwork
            //NSLog(@"No ALBUM ARTWORK");
            self.artwork.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
        }
        
        MPMediaPropertyPredicate * predicate = [MPMediaPropertyPredicate predicateWithValue:self.album.albumPersistentId forProperty:MPMediaItemPropertyAlbumPersistentID];
        
        MPMediaQuery * songsQuery = [[MPMediaQuery alloc] init];
        [songsQuery addFilterPredicate:predicate];
        NSArray *songsArray = [songsQuery items];
        if ([songsArray count]){
            NSLog(@"Number of songs: %ld", (long)[songsArray count]);
            for(MPMediaItem * item in songsArray) {
                TTSong *song = [[TTSong alloc] init];
                song.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
                song.artist = [item valueForProperty:MPMediaItemPropertyArtist];
                UIImage *songArtworkImage = NULL;
                MPMediaItemArtwork *itemArtwork = [item valueForProperty:MPMediaItemPropertyArtwork];
                if (itemArtwork != nil) {
                    songArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
                }
                if (songArtworkImage) {
                    song.artwork = itemArtwork;
                } else { // no song artwork
                    //NSLog(@"No ALBUM ARTWORK");
                    song.artwork = self.album.artwork;
                }
                //song.artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
                song.songTitle = [item valueForProperty:MPMediaItemPropertyTitle];
                song.duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
                song.songURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
                [self.songs addObject:song];
            }
        }
        
        //[songsQuery release];
        
    } else if(self.artist != nil) {
        self.aTitle.text = self.artist.artistTitle;
        NSString *albumString = (self.artist.albumCount > 1)?@"albums":@"album";
        NSString *songString = (self.artist.songCount > 1)?@"songs":@"song";
        self.songCount.text = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)self.artist.albumCount, albumString, (long)self.artist.songCount, songString];
        UIImage *artistArtworkImage = NULL;
        UIImage *resizedImage = NULL;
        MPMediaItemArtwork *itemArtwork = self.artist.artwork;
        
        if (itemArtwork != nil) {
            artistArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
            resizedImage = [artistArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
        }
        
        if (artistArtworkImage) {
            self.artwork.image = resizedImage;
        } else { // no artist artwork
            //NSLog(@"No artist ARTWORK");
            self.artwork.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
        }
        
        MPMediaPropertyPredicate * predicate = [MPMediaPropertyPredicate predicateWithValue:self.artist.artistPersistentId forProperty:MPMediaItemPropertyArtistPersistentID];
        
        MPMediaQuery * songsQuery = [[MPMediaQuery alloc] init];
        [songsQuery addFilterPredicate:predicate];
        NSArray *songsArray = [songsQuery items];
        if ([songsArray count]){
            NSLog(@"Number of songs: %ld", (long)[songsArray count]);
            for(MPMediaItem * item in songsArray) {
                TTSong *song = [[TTSong alloc] init];
                song.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
                song.artist = [item valueForProperty:MPMediaItemPropertyArtist];
                UIImage *songArtworkImage = NULL;
                MPMediaItemArtwork *itemArtwork = [item valueForProperty:MPMediaItemPropertyArtwork];
                if (itemArtwork != nil) {
                    songArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
                }
                if (songArtworkImage) {
                    song.artwork = itemArtwork;
                } else { // no song artwork
                    //NSLog(@"No ALBUM ARTWORK");
                    song.artwork = self.artist.artwork;
                }
                //song.artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
                song.songTitle = [item valueForProperty:MPMediaItemPropertyTitle];
                song.duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
                song.songURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
                [self.songs addObject:song];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Album Artist Song";
    TTAlbumArtistSongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TTAlbumArtistSongViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    TTSong *song = [self.songs objectAtIndex:indexPath.row];
    cell.songTitle.text = song.songTitle;
    int durationInSecs = song.duration.intValue;
    int minutes = durationInSecs / 60;
    int seconds = durationInSecs % 60;
    cell.duration.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    return cell;

    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"AlbumArtistPlayerSegue"])
    {
        TTNowPlayingViewController *Player = (TTNowPlayingViewController*) segue.destinationViewController;
        NSIndexPath *songIndexPath = [self.tableView indexPathForSelectedRow];
        
        Player.currentSong = [self.songs objectAtIndex:[songIndexPath row]];
    }
}

@end
