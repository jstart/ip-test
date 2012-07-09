//
//  IPViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPViewController.h"
#import "IPPageViewController.h"
#import "IPPopularPagesViewController.h"
#import "IPMyPagesViewController.h"
#import "IPFollowingPagesViewController.h"
#import <Parse/Parse.h>
#import "IPWelcomeViewController.h"
#import "UIViewController+MHSemiModal.h"

@interface IPViewController ()

@end

@implementation IPViewController
@synthesize scrollView;
@synthesize pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.scrollView setPageControl:self.pageControl];

//  [PFUser logOut];
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser) {
		// Skip straight to the main view.
		
	} else {
		// Go to the welcome screen and have them log in or create an account.
		[self presentWelcomeViewController];
	}

    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
  [self.scrollView addPagedViewController:[[IPPopularPagesViewController alloc] initWithNibName:@"IPPopularPagesViewController" bundle:[NSBundle mainBundle]] animated:NO];
  [self.scrollView addPagedViewController:[[IPMyPagesViewController alloc] initWithNibName:@"IPMyPagesViewController" bundle:[NSBundle mainBundle]]animated:NO];
  [self.scrollView addPagedViewController:[[IPFollowingPagesViewController alloc] initWithNibName:@"IPFollowingPagesViewController" bundle:[NSBundle mainBundle]]animated:NO];
  [self.scrollView gotoPage:1 animated:NO];

}

- (void)presentWelcomeViewController;
{
	// Go to the welcome screen and have them log in or create an account.
	IPWelcomeViewController *welcomeViewController = [[IPWelcomeViewController alloc] initWithNibName:@"IPWelcomeViewController" bundle:[NSBundle mainBundle]];
	welcomeViewController.title = @"Welcome to InsiderPages";
  UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
  
	[self presentModalViewController:navController animated:NO];
}

- (void)presentBookmarkViewController;
{
	// Go to the welcome screen and have them log in or create an account.
  if (super.bookmarkNavigationController == nil) {
    IPBookmarkViewController *bookmarkViewController = [[IPBookmarkViewController alloc] initWithNibName:@"IPBookmarkViewController" bundle:[NSBundle mainBundle]];
    super.bookmarkNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
    [super.bookmarkNavigationController setNavigationBarHidden:YES];
    [super.bookmarkNavigationController setWantsFullScreenLayout:YES];
  }
  if ([[self.navigationItem.rightBarButtonItem customView] isHidden]) {
    
  }else{

    [self.navigationController mh_presentSemiModalViewController:super.bookmarkNavigationController animated:YES];
    [super.bookmarkNavigationController setNavigationBarHidden:YES];
    [self hideBookmark];
  }
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
  [self.navigationController mh_dismissSemiModalViewController:super.bookmarkNavigationController animated:YES];

  [self showBookmark];
  if (homePageIndex >= 0 && homePageIndex < 3) {
    [self.scrollView gotoPage:homePageIndex animated:YES];
  }
}

-(void)showBookmark{
  CATransition *animation = [CATransition animation];
  [animation setDelegate:self];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromTop];
  [animation setDuration:0.2f];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [[self.navigationItem.rightBarButtonItem.customView layer] addAnimation:animation forKey:@"pushOut"];
  [[self.navigationItem.rightBarButtonItem customView] setHidden:NO];
}

-(void)hideBookmark{
  CATransition *animation = [CATransition animation];
  [animation setDelegate:self];
  [animation setType:kCATransitionMoveIn];
  [animation setSubtype:kCATransitionFromTop];
  [animation setDuration:0.2f];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [[self.navigationItem.rightBarButtonItem.customView layer] addAnimation:animation forKey:@"pushOut"];
  [[self.navigationItem.rightBarButtonItem customView] setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{  
  
}

-(void)firePagerChanged:(FireUIPagedScrollView*)pager pagesCount:(NSInteger)pagesCount currentPageIndex:(NSInteger)currentPageIndex{
  self.navigationItem.title = ((UIViewController*)[pager.controllers objectAtIndex:currentPageIndex]).title;
  [self.scrollView.pageControl updateCurrentPageDisplay];
}

- (void)viewDidUnload
{
  [self setScrollView:nil];
  [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

@end
