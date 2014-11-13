//
//  TTPlaylistTableViewController.m
//  iMusic
//
//  Created by Vivek Ratnavel Subramanian on 11/8/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTPlaylistTableViewController.h"

@interface TTPlaylistTableViewController ()

@end

@implementation TTPlaylistTableViewController

@synthesize playlists;

// we need this to retreive managed object context and later save the device data.
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)addPlaylist:(UIBarButtonItem *)sender {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"New Playlist" message:@"Enter a name for this playlist." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Save"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 1) {  //Save
        UITextField *playlist = [alertView textFieldAtIndex:0];
        NSLog(@"Playlist: %@", playlist.text);
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // Create a new playlist
        NSManagedObject *newPlaylist = [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:context];
        [newPlaylist setValue:playlist.text forKey:@"name"];
        
        // Invoke the save method to commit the change
        NSError *error = nil;
        // Save the context
        if (![context save:&error]) {
            NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        }
    }
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Inside viewDidLoad");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // here we get the playlists from the persistent data store (or the database)
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Playlist"];
    playlists = [[moc  executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
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
    return playlists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"playlistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *playlist = [playlists objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [playlist valueForKey:@"name"]]];
    [cell.detailTextLabel setText:@"No songs"];
    
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 if ([[segue identifier] isEqualToString:@"PlaylistPlayerSegue"])
 {
 //Get audio player instance and reset it
 AudioPlayer *music = [AudioPlayer getPlayer];
 [music pause];
 
 //Pass song list to player
 [music setQueue: _songs];
 NSInteger index = [[self.tableView indexPathForSelectedRow] row];
 [music setIndex:index];
 }
 }
 */

@end
