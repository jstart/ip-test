//
//  IPFollowingPagesViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPFollowingPagesViewController.h"
#import "IPSegmentContainerViewController.h"

@interface IPFollowingPagesViewController ()

@end

@implementation IPFollowingPagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"Following";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        self.loadingViewEnabled = YES;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.view.layer.cornerRadius = 10;
  self.view.layer.masksToBounds = YES;
//    PFObject * object = [PFQuery getObjectOfClass:@"Page"
//                                         objectId:@"WOZt83yqm4"];
//    [[PFUser currentUser] addObject:object forKey:@"following"];
//    [[PFUser currentUser] save];
//    PFRelation * followersRelation = [object relationforKey:@"Followers"];
//    [followersRelation addObject:[PFUser currentUser]];
//    [object save];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PFQuery *)queryForTable {
    PFQuery * query = nil;
    if ([PFUser currentUser]) {
        query = [PFQuery queryWithClassName:@"Page"];
        
        [query whereKey:@"Followers" equalTo:[PFUser currentUser]];
        // If no objects are loaded in memory, we look to the cache
        // first to fill the table and then subsequently do a query
        // against the network.
        if ([self.objects count] == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [query orderByDescending:@"createdAt"];
    }
    
    return query;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//  return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (![[[PFUser currentUser] objectForKey:@"following"]isKindOfClass:[NSNull class]]) {
//        return [[[PFUser currentUser] objectForKey:@"following"] count];
//    }else {
//        return 0;
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController * rootVC = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    IPSegmentContainerViewController * vc = [[IPSegmentContainerViewController alloc] initWithNibName:@"IPSegmentContainerViewController" bundle:[NSBundle mainBundle]];
    PFObject * object = [self.objects objectAtIndex:indexPath.row];
    [vc setPageObject:object];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [rootVC.topViewController.navigationController.view.layer addAnimation:transition forKey:nil];
    [rootVC.topViewController.navigationController pushViewController:vc animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
