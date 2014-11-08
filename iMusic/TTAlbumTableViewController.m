//
//  TTAlbumTableViewController.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 10/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTAlbumTableViewController.h"
#import "TTAlbum.h"
#import "UIImage+Resize.h"
@interface TTAlbumTableViewController ()
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation TTAlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *) albums {
    if(!_albums) {
        _albums = [[NSMutableArray alloc]init];
    }
    return _albums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    MPMediaQuery *allAlbumsQuery = [MPMediaQuery albumsQuery];
    NSArray *allAlbumsArray = [allAlbumsQuery collections];
    for (MPMediaItemCollection *collection in allAlbumsArray) {
        TTAlbum *album = [[TTAlbum alloc] init];
        MPMediaItem *item = [collection representativeItem];
        album.albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        album.artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        album.albumPersistentId = [item valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        //NSLog(@"Album Track Count: %@", [item valueForProperty:MPMediaItemPropertyAlbumTrackCount]);
        NSInteger songCount = 0;
        long duration = 0;
        for(MPMediaItem *song in collection.items) {
            songCount++;
            duration = duration + [[song valueForProperty:MPMediaItemPropertyPlaybackDuration] longValue];
        }
        //NSLog(@"Album Song Count: %ld", (long)songCount);
        album.songCount = songCount;
        album.duration = duration;
        [self.albums addObject:album];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Album Cell";
    
    TTAlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[TTAlbumViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    TTAlbum *album = [self.albums objectAtIndex:indexPath.row];
    MPMediaItemArtwork *itemArtwork = album.artwork;
    
    if (itemArtwork != nil) {
        albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        cell.albumArtworkImage.image = resizedImage;
    } else { // no album artwork
        //NSLog(@"No ALBUM ARTWORK");
        cell.albumArtworkImage.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    cell.albumTitle.text = album.albumTitle;
    NSString *minString = (album.duration > 1)?@"mins":@"min";
    NSString *songString = (album.songCount > 1)?@"songs":@"song";

    cell.songCountLabel.text = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)album.songCount, songString, (long)album.duration/60, minString];
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

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row Selected.");
    //[self performSegueWithIdentifier:@"albumSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    [self performSegueWithIdentifier:@"albumSegue" sender:[self superclass]];
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue.... %@ ", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"albumToSongListSegue"])
    {
        //NSLog(@"Inside segue.");
        TTAlbumArtistTableViewController *vc = (TTAlbumArtistTableViewController *)[segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        vc.album = [self.albums objectAtIndex:path.row];
    }
}

@end
