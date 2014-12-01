//
//  TTSongTableViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 9/18/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTSongTableViewController.h"
#import "TTSong.h"
#import "TTNowPlayingViewController.h"
#import "UIImage+Resize.h"
@interface TTSongTableViewController ()
@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic, strong) NSMutableDictionary *songIndex;
@property (nonatomic, strong) NSString *letters;
@property (nonatomic, strong) NSMutableArray *songSectionTitle;
@property (nonatomic, strong) NSMutableArray *filteredSongs;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation TTSongTableViewController

@synthesize filteredSongs, searchController;

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

- (NSMutableDictionary *) songIndex {
    if(!_songIndex) {
        _songIndex = [[NSMutableDictionary alloc]init];
    }
    return _songIndex;
}

- (NSMutableArray *) songSectionTitle {
    if(!_songSectionTitle) {
        _songSectionTitle = [[NSMutableArray alloc]init];
    }
    return _songSectionTitle;
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
    
    /*UITableView *tableView = (id)[self.view viewWithTag:1];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Song Cell"];
    searchController = [[UISearchDisplayController alloc]init];
    searchController.searchResultsDataSource = self;*/
    
    filteredSongs = [[NSMutableArray alloc]init];
    
    MPMediaQuery *allAlbumsQuery = [MPMediaQuery songsQuery];
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
        song.duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        song.songURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        
        NSLog(@"%@, %@", song.songTitle, [item valueForProperty:MPMediaItemPropertyIsCloudItem]);
        
        [self.songs addObject:song];
        // Add song title to the dictionary for indexed list
        unichar c = [[song.songTitle uppercaseString] characterAtIndex:0];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:self.letters];
        NSString *key = @"";
        if ([charSet characterIsMember:c]) {
            key = [NSString stringWithFormat:@"%C",c];
        } else {
            key = @"#";
        }
        NSMutableArray *tempArray = [self.songIndex valueForKey:key];
        if([tempArray count] > 0) {
            [tempArray addObject:song];
        } else {
            tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:song];
        }
        [self.songIndex setValue:tempArray forKey:key];
        //NSLog(@"Temp Array: %@",tempArray);
        //NSLog(@"Key: %@", key);
    }
    //NSLog(@"Dictionary...");
    //NSLog(@"%@", self.songIndex);
    self.songSectionTitle = [NSMutableArray arrayWithArray:[[self.songIndex allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    //NSLog(@"Song Section Title...");
    //NSLog(@"%@", self.songSectionTitle);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"Inside scrollViewDidScroll; content offset y: %f",scrollView.contentOffset.y);
    /*UISearchBar *searchBar = self.searchBar;
    CGRect rect = searchBar.frame;
    rect.origin.y = MIN(0, scrollView.contentOffset.y);
    searchBar.frame = rect;*/
    //self.searchBar.frame = CGRectMake(0,MAX(0,scrollView.contentOffset.y),320,44);
    /*UISearchBar *searchBar = self.searchDisplayController.searchBar;
    CGRect rect = searchBar.frame;
    rect.origin.y = MAX(0, scrollView.contentOffset.y);
    searchBar.frame = rect;*/
    // get the table and search bar bounds
    /*CGRect tableBounds = self.tableView.bounds;
    CGRect searchBarFrame = self.searchBar.frame;
    
    // make sure the search bar stays at the table's original x and y as the content moves
    self.searchBar.frame = CGRectMake(tableBounds.origin.x,
                                      tableBounds.origin.y,
                                      searchBarFrame.size.width,
                                      searchBarFrame.size.height
                                      );
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    /*if(tableView.tag == 1) {
        return [self.songSectionTitle count];
    } else {
        return 1;
    }*/
    NSLog(@"Tag: %ld",(long)tableView.tag);
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.songSectionTitle count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    /*if(tableView.tag == 1) {
        NSString *sectionTitle = [self.songSectionTitle objectAtIndex:section];
        NSArray *sectionSongs = [self.songIndex objectForKey:sectionTitle];
        return [sectionSongs count];
    } else {
        return [self.filteredSongs count];
    }*/
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredSongs count];
    } else {
        NSString *sectionTitle = [self.songSectionTitle objectAtIndex:section];
        NSArray *sectionSongs = [self.songIndex objectForKey:sectionTitle];
        return [sectionSongs count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    /*if(tableView.tag == 1) {
        return [self.songSectionTitle objectAtIndex:section];
    } else {
        return nil;
    }*/
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [self.songSectionTitle objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    /*if(tableView.tag == 1) {
        return self.songSectionTitle;
    } else {
        return nil;
    }*/
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return self.songSectionTitle;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Song Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImage *albumArtworkImage = NULL;
    UIImage *resizedImage = NULL;
    //TTSong *song = [self.songs objectAtIndex:indexPath.row];
    TTSong *song;
    
    /*if(tableView.tag == 1) {
        NSString *sectionTitle = [self.songSectionTitle objectAtIndex:indexPath.section];
        NSArray *sectionSongs = [self.songIndex objectForKey:sectionTitle];
        song = [sectionSongs objectAtIndex:indexPath.row];
    } else {
        song = [self.filteredSongs objectAtIndex:indexPath.row];
    }*/
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        song = [self.filteredSongs objectAtIndex:indexPath.row];
    } else {
        NSString *sectionTitle = [self.songSectionTitle objectAtIndex:indexPath.section];
        NSArray *sectionSongs = [self.songIndex objectForKey:sectionTitle];
        song = [sectionSongs objectAtIndex:indexPath.row];
    }
    
    MPMediaItemArtwork *itemArtwork = [song artwork];
    
    if (itemArtwork != nil) {
        //NSLog(@"found art");
        albumArtworkImage = [itemArtwork imageWithSize:itemArtwork.bounds.size];
        resizedImage = [albumArtworkImage resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }
    
    if (albumArtworkImage) {
        cell.imageView.image = resizedImage;
    } else { // no album artwork
        //NSLog(@"No ALBUM ARTWORK");
        cell.imageView.image = [[UIImage imageNamed:@"default-artwork.png"] resizedImage: CGSizeMake(256.0f, 256.0f) interpolationQuality: kCGInterpolationLow];
    }

    cell.textLabel.text = song.songTitle;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"About to perform segue...");
        [self performSegueWithIdentifier:@"SongPlayerSegue" sender:tableView];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SongPlayerSegue"])
    {
        NSInteger index;
        NSMutableArray *songQueue;
        if(sender == self.searchDisplayController.searchResultsTableView) {
            index = [[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow] row];
            songQueue = self.filteredSongs;
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *sectionTitle = [self.songSectionTitle objectAtIndex:indexPath.section];
            NSArray *sectionSongs = [self.songIndex objectForKey:sectionTitle];
            TTSong *song = [sectionSongs objectAtIndex:indexPath.row];
            index = [self.songs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([[(TTSong *)obj songTitle] isEqualToString:song.songTitle] && [[(TTSong *)obj songURL] isEqual:song.songURL]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            NSLog(@"Index: %d", index);
            songQueue = self.songs;
        }
        
        //Get audio player instance and reset it
        AudioPlayer *music = [AudioPlayer getPlayer];
        [music pause];
        
        //Pass song list to player
        [music setQueue:songQueue];
        [music setIndex:index];
    }
}

#pragma mark - Search
/*
-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Song Cell"];
}*/

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.filteredSongs removeAllObjects];
    if(searchString.length > 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"songTitle contains[c] %@", self.searchBar.text];
        for(NSString *key in self.songSectionTitle) {
            NSArray *matches = [self.songIndex[key] filteredArrayUsingPredicate:resultPredicate];
            [self.filteredSongs addObjectsFromArray:matches];
        }
        NSLog(@"Filtered Songs: %@", self.filteredSongs);
    }
    
    return YES;
}

@end
