//
//  TTArtistTableViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 9/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTArtistTableViewController.h"
#import "TTArtistViewCell.h"
#import "TTArtist.h"
#import "UIImage+Resize.h"
@interface TTArtistTableViewController ()
@property (nonatomic, strong) NSMutableArray *artists;
@property (nonatomic, strong) NSMutableDictionary *artistIndex;
@property (nonatomic, strong) NSString *letters;
@property (nonatomic, strong) NSMutableArray *artistSectionTitle;
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

- (NSMutableArray *) artists {
    if(!_artists) {
        _artists = [[NSMutableArray alloc]init];
    }
    return _artists;
}

- (NSMutableDictionary *) artistIndex {
    if(!_artistIndex) {
        _artistIndex = [[NSMutableDictionary alloc]init];
    }
    return _artistIndex;
}

- (NSMutableArray *) artistSectionTitle {
    if(!_artistSectionTitle) {
        _artistSectionTitle = [[NSMutableArray alloc]init];
    }
    return _artistSectionTitle;
}

- (NSString *) letters {
    if(!_letters) {
        _letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }
    return _letters;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [SVProgressHUD showWithStatus:@"Loading Artists..." maskType:SVProgressHUDMaskTypeClear];
    
    NSLog(@"Artist View Loaded.");
    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
    NSArray *albumCollection = [albumQuery collections];
    NSCountedSet *artistAlbumCounter = [NSCountedSet set];
    
    [albumCollection enumerateObjectsUsingBlock:^(MPMediaItemCollection *album, NSUInteger idx, BOOL *stop) {
        NSString *artistName = [[album representativeItem] valueForProperty:MPMediaItemPropertyArtist];
        if(artistName != nil) {
            [artistAlbumCounter addObject:artistName];
        }
    }];
    MPMediaQuery *allArtistsQuery = [MPMediaQuery artistsQuery];
    NSArray *allArtistsArray = [allArtistsQuery collections];
    for (MPMediaItemCollection *collection in allArtistsArray) {
        TTArtist *artist = [[TTArtist alloc] init];
        MPMediaItem *item = [collection representativeItem];
        NSInteger songsCount = [collection.items count];
        artist.songCount = songsCount;
        artist.artistTitle = [item valueForProperty:MPMediaItemPropertyArtist];
        artist.albumCount = [artistAlbumCounter countForObject:artist.artistTitle];
        artist.artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        artist.artistPersistentId = [item valueForProperty:MPMediaItemPropertyArtistPersistentID];
        [self.artists addObject:artist];
        // Add artist title to the dictionary for indexed list
        unichar c = [[artist.artistTitle uppercaseString] characterAtIndex:0];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:self.letters];
        NSString *key = @"";
        if ([charSet characterIsMember:c]) {
            key = [NSString stringWithFormat:@"%C",c];
        } else {
            key = @"#";
        }
        NSMutableArray *tempArray = [self.artistIndex valueForKey:key];
        if([tempArray count] > 0) {
            [tempArray addObject:artist];
        } else {
            tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:artist];
        }
        [self.artistIndex setValue:tempArray forKey:key];
    }
    NSLog(@"Dictionary...");
    NSLog(@"%@", self.artistIndex);
    self.artistSectionTitle = [NSMutableArray arrayWithArray:[[self.artistIndex allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    NSLog(@"Song Section Title...");
    NSLog(@"%@", self.artistSectionTitle);
    [SVProgressHUD dismiss];
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
    return [self.artistSectionTitle count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [self.artistSectionTitle objectAtIndex:section];
    NSArray *sectionSongs = [self.artistIndex objectForKey:sectionTitle];
    return [sectionSongs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.artistSectionTitle objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.artistSectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Artist Cell";
    
    TTArtistViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell = [[TTArtistViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //TTArtist *artist = [self.artists objectAtIndex:indexPath.row];
    NSString *sectionTitle = [self.artistSectionTitle objectAtIndex:indexPath.section];
    NSArray *sectionSongs = [self.artistIndex objectForKey:sectionTitle];
    TTArtist *artist = [sectionSongs objectAtIndex:indexPath.row];
    
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    MPMediaItemArtwork *itemArtwork = artist.artwork;
    
    if (itemArtwork != nil) {
        albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        cell.artistArtworkImage.image = resizedImage;
    } else { // no album artwork
        NSLog(@"No ALBUM ARTWORK");
        cell.artistArtworkImage.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }

    cell.artistTitle.text = artist.artistTitle;
    NSString *albumString = (artist.albumCount > 1)?@"albums":@"album";
    NSString *songString = (artist.songCount > 1)?@"songs":@"song";
    cell.albumSongCountLabel.text = [NSString stringWithFormat:@"%ld %@, %ld %@", (long)artist.albumCount, albumString, (long)artist.songCount, songString];
    //cell.textLabel.text = song.artist;
    //cell.artistTitle.text = song.artist;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 75;
    } else {
        return 50;
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue.... %@ ", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"artistToSongListSegue"])
    {
        //NSLog(@"Inside segue.");
        TTAlbumArtistTableViewController *vc = (TTAlbumArtistTableViewController *)[segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        //songIndexPath = [self.tableView indexPathForSelectedRow];
        NSString *sectionTitle = [self.artistSectionTitle objectAtIndex:path.section];
        NSArray *artistSongs = [self.artistIndex objectForKey:sectionTitle];

        vc.artist = [artistSongs objectAtIndex:path.row];
    }}


@end
