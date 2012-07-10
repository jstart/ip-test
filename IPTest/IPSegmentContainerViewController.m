//
//  IPSegmentContainerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPSegmentContainerViewController.h"
#import "IPViewController.h"
#import "UIViewController+MHSemiModal.h"
#import "IPCreatePageViewController.h"

@interface IPSegmentContainerViewController ()

@end

@implementation IPSegmentContainerViewController
@synthesize scrollView;
@synthesize segmentControl;
@synthesize listVC, gridVC;
@synthesize pageObject, objects = _objects;

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
  self.gridVC = [[IPGridViewController alloc] initWithNibName:@"IPGridViewController" bundle:[NSBundle mainBundle]];
  self.gridVC.delegate = self;
  [self.scrollView addPagedViewController:self.listVC animated:NO];
  [self.scrollView addPagedViewController:self.gridVC animated:NO];
  [self.navigationItem setTitleView:self.segmentControl];
  //HAX
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  UIBarButtonItem *spacerButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:view];
  self.navigationItem.rightBarButtonItem = spacerButton;
  [self.navigationItem setHidesBackButton:YES];
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                 style:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(customBackAction:)];
  self.navigationItem.leftBarButtonItem = backButton;
  // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"Parent_Page" equalTo:pageObject];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
        [self.gridVC updatedResultObjects:[objects mutableCopy]];
        [self.listVC updatedResultObjects:[objects mutableCopy]];
    }];

}

- (void)viewDidUnload
{
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

- (void)customBackAction:(id)sender {
  CATransition *transition = [CATransition animation];
  transition.duration = 0.4f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionPush;
  transition.subtype = kCATransitionFromBottom;
  transition.delegate = self;
  [self.navigationController.view.layer addAnimation:transition forKey:nil];
  self.navigationController.navigationBarHidden = NO;
  [self.navigationController popViewControllerAnimated:NO];
}

- (void)customBackActionNoAnimation:(int)homePageIndex {
    if (homePageIndex >= 0 && homePageIndex < 3) {
        self.navigationController.navigationBarHidden = NO;
        [((IPViewController*)([self.navigationController.viewControllers objectAtIndex:0])) bookmarkViewWasDismissed:homePageIndex];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if (homePageIndex >= 3 && homePageIndex < 4) {
        IPCreatePageViewController * cpvc = [[IPCreatePageViewController alloc] initWithNibName:@"IPCreatePageViewController" bundle:[NSBundle mainBundle]];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:cpvc];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentModalViewController:navController animated:YES];
    }

    [self showBookmark];
    [self mh_dismissSemiModalViewController:super.bookmarkNavigationController animated:YES];
//    [self performSelector:@selector(mh_dismissSemiModalViewController:animated:) withObject:super.bookmarkNavigationController afterDelay:1.1];
}

@end
