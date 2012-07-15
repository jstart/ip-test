//
//  IPSegmentContainerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPSegmentContainerViewController.h"
#import "IPViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "IPCreatePageViewController.h"
#import "IPInviteFriendToPageViewController.h"
@interface IPSegmentContainerViewController ()

@end

@implementation IPSegmentContainerViewController
@synthesize scrollView;
@synthesize segmentControl;
@synthesize listVC, gridVC;
@synthesize pageObject, objects = _objects;

@synthesize pageManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.objects = [[NSMutableArray alloc] init];
  self.listVC = [[IPListViewController alloc] initWithNibName:@"IPListViewController" bundle:[NSBundle mainBundle]];
  self.listVC.delegate = self;
    self.listVC.pageObject  = self.pageObject;
  self.gridVC = [[IPGridViewController alloc] initWithNibName:@"IPGridViewController" bundle:[NSBundle mainBundle]];
  self.gridVC.delegate = self;

  [self.scrollView addPagedViewController:self.listVC animated:NO];
  [self.scrollView addPagedViewController:self.gridVC animated:NO];
  [self.navigationItem setTitleView:self.segmentControl];
  //HAX
  UIBarButtonItem *spacerButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  self.navigationItem.rightBarButtonItem = spacerButton;

  [self.navigationItem setHidesBackButton:YES];
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                 style:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(customBackAction:)];
  self.navigationItem.leftBarButtonItem = backButton;
    
    self.pageManager = [[IPParseObjectManager sharedInstance] pageManagerForObject:pageObject];
    self.pageManager.delegate = self;

  // Do any additional setup after loading the view from its nib.
}

-(void)didFinishRefreshing{
    NSLog(@"didFinishRefreshing");
    [self sortObjects:[self.pageManager.pageObject objectForKey:@"Items"]];
}

-(void)didInviteUser{
    NSLog(@"didInviteUser");
}

-(void)didAddCurrentUserToFollowing{
    NSLog(@"didAddCurrentUserToFollowing");
}

-(void)didSubmitRankings{
    NSLog(@"didSubmitRankings");
    [self.listVC didSubmitRankingSuccessfully];
    [self.pageManager computeGlobalRanking];
}

-(void)didComputeGlobalRanking{
    NSLog(@"didComputeGlobalRanking");
    [self.listVC didComputeGlobalRanking];
    [self sortObjects:[self.pageManager.pageObject objectForKey:@"Items"]];
}

-(void)didAddItem{
    NSLog(@"didAddItem");
}

-(void)didRetrieveRankingForItems:(NSDictionary*)rankingDictionary{
    NSLog(@"didRetrieveRankingForItems");

    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
//        [self.gridVC updatedResultObjects:[sortedArray mutableCopy]];
        [self.listVC retrievedRanks:[rankingDictionary mutableCopy]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.pageManager refresh];
}

-(void)didRequestRefresh{
    [self.pageManager refresh];
}

-(void)sortObjects:(NSArray *)objects{
    dispatch_async( dispatch_get_global_queue(0, 0), ^{
        
        // call the result handler block on the main queue (i.e. main thread)
      
            // running synchronously on the main thread now -- call the handler
            NSMutableDictionary * sortDictionary = [[NSMutableDictionary alloc] init];
            for (PFObject * item in objects) {
                PFQuery * query = [PFQuery queryWithClassName:@"GlobalRanking"];
                [query whereKey:@"Parent_Page" equalTo:self.pageObject];
                [query whereKey:@"Parent_Item" equalTo:item];
                PFObject * globalRanking = [query getFirstObject];
                if (globalRanking) {
                    [sortDictionary setObject:globalRanking forKey:item.objectId];
                }
            }
            NSArray *sortedArray = nil;
            sortedArray = [objects sortedArrayUsingComparator:^NSComparisonResult(PFObject* obj1, PFObject* obj2){
                PFObject * rankObject1 = [sortDictionary objectForKey:obj1.objectId];
                PFObject * rankObject2 = [sortDictionary objectForKey:obj2.objectId];
                
                if ([rankObject1 objectForKey:@"position"] == nil) {
                    return NSOrderedDescending;
                }else if([rankObject2 objectForKey:@"position"] == nil){
                    return NSOrderedAscending;
                }
                
                if ([[rankObject1 objectForKey:@"position"] intValue] < [[rankObject2 objectForKey:@"position"] intValue]) {
                    return NSOrderedAscending;
                }
                else if ([[rankObject1 objectForKey:@"position"] intValue] == [[rankObject2 objectForKey:@"position"] intValue]) {
                    return NSOrderedSame;
                }
                else{
                    return NSOrderedDescending;
                }
            }];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
            [self.gridVC updatedResultObjects:[sortedArray mutableCopy]];
            [self.listVC updatedResultObjects:[sortedArray mutableCopy]];
            [self.pageManager retrieveRanksForItems:sortedArray];
        }];
    });
}

- (void)viewDidUnload
{
    self.pageManager.delegate = nil;
    self.pageManager = nil;
  [self setSegmentControl:nil];
  [self setScrollView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
    [self customBackActionNoAnimation:homePageIndex];
}


- (void)firePagerChanged:(FireUIPagedScrollView*)pager pagesCount:(NSInteger)pagesCount currentPageIndex:(NSInteger)currentPageIndex {
  NSIndexPath*        selection = [self.listVC.tableView indexPathForSelectedRow];
  if (selection)
    [self.listVC.tableView deselectRowAtIndexPath:selection animated:YES];
  [self.segmentControl setSelectedSegmentIndex:currentPageIndex];
}

#pragma GridDelegate
- (void)didSelectRowAtIndex:(NSInteger)index {
}

#pragma ListDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.scrollView gotoPage:1 animated:YES];
  [self.gridVC.carousel scrollToItemAtIndex:indexPath.row animated:YES];
}

- (void)didPushCreateButton:(id)sender {
  IPAddListItemViewController * addListItemVC = [[IPAddListItemViewController alloc] initWithNibName:@"IPAddListItemViewController" bundle:[NSBundle mainBundle]];
  [addListItemVC setPageObject:pageObject];
  UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:addListItemVC];

  [self presentModalViewController:navigationController animated:YES];
}

-(void)didPushInviteButton:(id)sender{
    IPInviteFriendToPageViewController * inviteVC = [[IPInviteFriendToPageViewController alloc] initWithNibName:@"IPInviteFriendToPageViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:inviteVC];
    [inviteVC setPageObject:self.pageObject];
    PFRelation * followersRelation = [self.pageObject relationforKey:@"Followers"];
    NSArray * followersArray = [[followersRelation query] findObjects];
    [[inviteVC selectedUsersArray] addObjectsFromArray:followersArray];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)customBackAction:(id)sender {
  CATransition *transition = [CATransition animation];
  transition.duration = 0.4f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionPush;
  transition.subtype = kCATransitionFromBottom;
  transition.delegate = self;
  [self.navigationController.view.layer addAnimation:transition forKey:nil];
  [self.navigationController popViewControllerAnimated:NO];
}

- (void)customBackActionNoAnimation:(int)homePageIndex {
    if (homePageIndex >= 0 && homePageIndex < 3) {
        [((IPViewController*)([self.navigationController.viewControllers objectAtIndex:0])) bookmarkViewWasDismissed:homePageIndex];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if (homePageIndex >= 3 && homePageIndex < 4) {
        IPCreatePageViewController * cpvc = [[IPCreatePageViewController alloc] initWithNibName:@"IPCreatePageViewController" bundle:[NSBundle mainBundle]];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:cpvc];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:navController animated:YES];
    }

    [self showBookmark];
    [self dismissSemiModalView];
}

@end
