//
//  TTFriendViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 10/24/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTFriendViewController.h"
#import "TTFriendSongTableViewController.h"

@interface TTFriendViewController ()
@property (strong, nonatomic) NSArray *friendObjects;
@property (strong, nonatomic) NSArray *friendUsers;

@end

@implementation TTFriendViewController

@synthesize imagesCollection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self queryParseMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)queryParseMethod
{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            self.friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:self.friendObjects.count];
            for (NSDictionary *friendObject in self.friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    self.friendUsers = objects;
                    
                    [imagesCollection reloadData];
                }
            }];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FriendToSongSegue"]) {
        TTImageCollectionViewCell *cell = (TTImageCollectionViewCell *)sender;
        NSIndexPath *indexPath = [self.imagesCollection indexPathForCell:cell];
        TTFriendSongTableViewController *destViewController = segue.destinationViewController;
        destViewController.friendUser = self.friendUsers[indexPath.row];
    };
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return [self.friendUsers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Photo Cell" forIndexPath:indexPath];
    //NSLog(@"cellforitematindexpath");
    
    static NSString *CellIdentifier = @"Photo Cell";
    TTImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // NSLog(@"%@", self.friendUsers);
    //cell.activityIndicator.hidden = NO;
    //[cell.activityIndicator startAnimating];
    
    PFUser *friendList = self.friendUsers[indexPath.row];
    //NSLog(@"%@", friendList);
    
    NSURL *url = [NSURL URLWithString:friendList[@"profile"][@"pictureURL"]];
    cell.backgroundColor = [UIColor whiteColor];
    
    //NSLog(@"%@", url);
    
    if (url == nil ) {
        cell.imageCell.image = [UIImage imageNamed:@"defaultUserIcon.png"];
    }
    else {
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageCell.image = [UIImage imageWithData:data];
    }
    cell.nameLabel.text = friendList[@"profile"][@"name"];
    //[cell.activityIndicator startAnimating];
    //cell.activityIndicator.hidden = YES;
    // Configure the cell
    
    return cell;
}

@end
