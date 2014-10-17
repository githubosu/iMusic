//
//  TTViewController.m
//  iMusic
//
//  Created by Thanh Trinh on 10/16/14.
//  Copyright (c) 2014 edu.osu.trinh.47. All rights reserved.
//

#import "TTViewController.h"
#import "TTArtistTableViewController.h"
#import "TTSongTableViewController.h"

@interface TTViewController ()

@end

@implementation TTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    XHTwitterPaggingViewer *twitterPaggingViewer = [[XHTwitterPaggingViewer alloc] init];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *titles = @[@"Home", @"Friend", @"曾宪华", @"News", @"Viewer", @"Framework", @"Pagging"];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        TTArtistTableViewController *tableViewController = [[TTArtistTableViewController alloc] init];
        tableViewController.title = title;
        [viewControllers addObject:tableViewController];
    }];
    
    
    twitterPaggingViewer.viewControllers = viewControllers;
    
    twitterPaggingViewer.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
         NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:twitterPaggingViewer];
    
    [self.window makeKeyAndVisible];
    [twitterPaggingViewer setCurrentPage:2 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
