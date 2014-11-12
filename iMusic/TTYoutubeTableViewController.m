//
//  TTYoutubeTableViewController.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 11/11/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTYoutubeTableViewController.h"
#import "TTYoutubeViewCell.h"
#import "TTYoutube.h"

@interface TTYoutubeTableViewController ()
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSDictionary *videos;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@end

@implementation TTYoutubeTableViewController

@synthesize searchResults, searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.searchResults = [[NSMutableArray alloc]init];
    // For testing
    NSString *apiKey = @"AIzaSyAXwT5jS7mm-QMNAFDqDd_1jlWoBYcvTbc";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&chart=mostPopular&key=%@", apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"JSON REQUESTED for : %@", urlString);
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
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Inside Table Cell");
    static NSString *simpleTableIdentifier = @"youtubeCell";
    /*TTYoutubeViewCell *cell;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    }*/
    
    TTYoutubeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"youtubeCustomCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        //[self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"youtubeCustomCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [[TTYoutubeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.videoTitle.lineBreakMode = NSLineBreakByWordWrapping;
    cell.videoTitle.numberOfLines = 0;
    cell.videoDescription.lineBreakMode = NSLineBreakByWordWrapping;
    cell.videoDescription.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TTYoutubeViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TTYoutube *youtube = [self.searchResults objectAtIndex:indexPath.row];
    NSLog(@"Youtube Video Title: %@",youtube.videoTitle);
    cell.videoTitle.text = youtube.videoTitle;
    cell.videoDescription.text = youtube.videoDescription;
    cell.thumbnail.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:youtube.thumbnailURL]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"About to perform segue...");
        [self performSegueWithIdentifier:@"youtubeSegue" sender:tableView];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"youtubeSegue"])
    {
        TTYoutubeViewController *Player = (TTYoutubeViewController*) segue.destinationViewController;
        NSIndexPath *videoIndexPath;
        TTYoutube *youtube;
        //if (self.searchDisplayController.active) {
        /*if(sender == self.searchDisplayController.searchResultsTableView) {
            videoIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            youtube = [self.searchResults objectAtIndex:videoIndexPath.row];
        } else {
            videoIndexPath = [self.tableView indexPathForSelectedRow];
            youtube = [self.searchResults objectAtIndex:videoIndexPath.row];
        }*/
        videoIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        youtube = [self.searchResults objectAtIndex:videoIndexPath.row];
        NSLog(@"Title: %@, videoId: %@", youtube.videoTitle, youtube.videoId);
        Player.youtube = youtube;
    }
}


#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Populate search results;
    
    [SVProgressHUD showWithStatus:@"Loading Videos..." maskType:SVProgressHUDMaskTypeClear];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //NSString *apiKey = @"AIzaSyC2PTX7MnDclRCRGa1YUpnM6hhb-HU5xB4";
    NSString *apiKey = @"AIzaSyAXwT5jS7mm-QMNAFDqDd_1jlWoBYcvTbc";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=%@&key=%@", searchBar.text, apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"JSON REQUESTED for : %@", urlString);
    
    //[self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [self.data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"JSON RECEIVED");
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.videos = [NSJSONSerialization JSONObjectWithData:self.data options:nil error:nil];
    
    NSLog(@"Videos: %@",self.videos);
    
    NSArray *itemsArray = (NSArray *)[self.videos objectForKey:@"items"];
    [self.searchResults removeAllObjects];
    for (NSDictionary *item in itemsArray) {
        NSDictionary *snippet = [item objectForKey:@"snippet"];
        NSDictionary *ids = [item objectForKey:@"id"];
        NSString *description = [snippet objectForKey:@"description"];
        NSString *title = [snippet objectForKey: @"title"];
        NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
        NSDictionary *defaultThumbnail = [thumbnails objectForKey:@"default"];
        NSString *thumbnailURL = [defaultThumbnail objectForKey:@"url"];
        NSString *videoId = [ids objectForKey:@"videoId"];
        NSLog(@"Title: %@",title);
        NSLog(@"Desc: %@",description);
        NSLog(@"Thumbnail: %@",thumbnailURL);
        NSLog(@"Video Id: %@",videoId);
        TTYoutube *youtube = [[TTYoutube alloc] init];
        youtube.videoId = videoId;
        youtube.videoTitle = title;
        youtube.videoDescription = description;
        youtube.thumbnailURL = thumbnailURL;
        [self.searchResults addObject:youtube];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
    //[self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
