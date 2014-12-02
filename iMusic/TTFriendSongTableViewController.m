//
//  TTFriendSongTableViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 11/10/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTFriendSongTableViewController.h"
#import "TTYoutube.h"

@interface TTFriendSongTableViewController ()
@property(strong,nonatomic)NSArray *songArray;
@property(strong,nonatomic)NSString *currentSegment;

@end

@implementation TTFriendSongTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSLog(@"%@",self.friendUser[@"fbId"]);
    self.navigationItem.hidesBackButton = YES;
//    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
//    [query whereKey:@"fbId" equalTo:self.friendUser[@"fbId"]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            //NSLog(@"%@", objects);
//            self.songArray = objects;
//            [self.tableView reloadData];
//        }
//        
//    }];
    [self queryForSong];
}

#pragma mark - Query Parse

-(void)queryForYoutube
{
    PFQuery *query = [PFQuery queryWithClassName:@"Youtube"];
    [query whereKey:@"fbId" equalTo:self.friendUser[@"fbId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.songArray = objects;
            //NSLog(@"%@", self.songArray);
            [self.tableView reloadData];
        }
    }];
}

-(void)queryForSong
{
    PFQuery *query = [PFQuery queryWithClassName:@"Song"];
    [query whereKey:@"fbId" equalTo:self.friendUser[@"fbId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //NSLog(@"%@", objects);
            self.songArray = objects;
            [self.tableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.songArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TTFriendSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    static NSString *cellIdentifier = @"Cell";
    TTFriendSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *imageObject = [self.songArray objectAtIndex:indexPath.row];
    NSLog(@"%@", imageObject);
    PFFile *imageFile = [imageObject objectForKey:@"artwork"];
   //NSLog(@"%@", imageFile);
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.albumArtworkImage.image = [UIImage imageWithData:data];
            cell.songLabel.text = imageObject[@"title"];
            //cell.albumLabel.text = imageObject[@"album"];
            cell.artistLabel.text = imageObject[@"artist"];
        }
    }];
    
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
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue
    if([self.currentSegment isEqualToString:@"Videos"]) {
        NSLog(@"About to perform segue...");
        [self performSegueWithIdentifier:@"friendYoutubeSegue" sender:tableView];
    }
}*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // Performing segue only when selected segment is Videos
    if([self.currentSegment isEqualToString:@"Videos"]) {
        return YES;
    } else {
        return NO;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"friendYoutubeSegue"]) {
        if([self.currentSegment isEqualToString:@"Videos"]) {
            TTYoutubeViewController *Player = (TTYoutubeViewController*) segue.destinationViewController;
            NSIndexPath *videoIndexPath;
            TTYoutube *youtube = [[TTYoutube alloc] init];
            videoIndexPath = [self.tableView indexPathForSelectedRow];
            PFObject *videoObject = [self.songArray objectAtIndex:videoIndexPath.row];
            youtube.videoId = videoObject[@"album"];
            youtube.videoTitle = videoObject[@"title"];
            youtube.videoDescription = videoObject[@"artist"];
            youtube.thumbnailURL = videoObject[@"thumbnailURL"];
            NSLog(@"Title: %@, videoId: %@", youtube.videoTitle, youtube.videoId);
            Player.youtube = youtube;
        }
    }
}

- (IBAction)segmentedControlPressed:(UISegmentedControl *)sender
{
    int index = (int)sender.selectedSegmentIndex;
    NSLog(@"The selected segment is : %d", index);
    switch (index) {
        case 0:
            self.currentSegment = @"Songs";
            [self queryForSong];
            break;
        case 1:
            self.currentSegment = @"Videos";
            [self queryForYoutube];
            break;
    }
}
@end
