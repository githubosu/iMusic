//
//  TTArtistTableViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 9/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTArtistTableViewController.h"
#import "TTSong.h"
#import "UIImage+Resize.h"
@interface TTArtistTableViewController ()
@property (nonatomic, strong) NSMutableArray *songs;
@end

@implementation TTArtistTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *) songs {
    if(!_songs) {
        _songs = [[NSMutableArray alloc]init];
    }
    return _songs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"Artist View Loaded.");
    MPMediaQuery *allAlbumsQuery = [MPMediaQuery artistsQuery];
    NSArray *allAlbumsArray = [allAlbumsQuery collections];
    for (MPMediaItemCollection *collection in allAlbumsArray) {
        TTSong *song = [[TTSong alloc] init];
        MPMediaItem *item = [collection representativeItem];
        //NSLog(@"%@", [item valueForProperty:MPMediaItemPropertyAlbumTitle]);
        //NSLog(@"Artwork: %@", [item valueForProperty:MPMediaItemPropertyArtwork]);
        song.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        song.artist = [item valueForProperty:MPMediaItemPropertyArtist];
        song.artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        song.songTitle = [item valueForProperty:MPMediaItemPropertyTitle];
        song.duration = [item valueForProperty:MPMediaItemPropertyTitle];
        [self.songs addObject:song];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Artist Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    MPMediaItemArtwork *itemArtwork = [[self.songs objectAtIndex:indexPath.row] artwork];
    
    if (itemArtwork != nil) {
        albumArtworkImage = [itemArtwork imageWithSize:CGSizeMake(256.0f, 256.0f)];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        cell.imageView.image = resizedImage;
    } else { // no album artwork
        NSLog(@"No ALBUM ARTWORK");
        cell.imageView.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    TTSong *song = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = song.artist;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
