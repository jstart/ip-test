//
//  IPBookmarkViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPBookmarkViewController.h"
#import "IPViewController.h"
#import "UIViewController+MHSemiModal.h"
#import "IPTestView.h"
#import <Parse/Parse.h>

@interface IPBookmarkViewController ()

@end

@implementation IPBookmarkViewController

@synthesize delegate;
@synthesize bookmarkTableView;
@synthesize closeButton;
@synthesize headerViewController;
@synthesize notificationViewController;
@synthesize searchBar = _searchBar;

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
    self.wantsFullScreenLayout = YES;

    // Do any additional setup after loading the view from its nib.
    self.notificationViewController = [[IPNotificationListViewController alloc] initWithNibName:@"IPNotificationListViewController" bundle:[NSBundle mainBundle]];
//    [self.notificationViewController.navigationController setNavigationBarHidden:NO];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.contentMode = UIViewContentModeScaleToFill;

    
    self.headerViewController = [[IPBookmarkHeaderViewController alloc] initWithNibName:@"IPBookmarkHeaderViewController" bundle:[NSBundle mainBundle]];

    [self.bookmarkTableView setTableHeaderView:self.headerViewController.view];
    
    if ([PFUser currentUser]) {
        self.headerViewController.usernameLabel.text = [[PFUser currentUser] objectForKey:@"username"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
  NSLog(@"%@", NSStringFromCGRect(self.bookmarkTableView.frame));
  //HAX
//  [((IPTestView*)self.view) setHasBeenAdjusted:YES];
//  CGRect frame = self.closeButton.frame;
//  frame.origin.y = self.bookmarkTableView.frame.size.height;
//  self.closeButton.frame = frame;
}

- (void)viewDidUnload
{
  [self setBookmarkTableView:nil];
  [self setCloseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeButton:(id)sender {
  if (self.delegate) {
    [self.delegate bookmarkViewWasDismissed:-1];
  }
  else{
    NSLog(@"No delegate for bookmarkview");
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString* CellIdentifier = @"Cell";
  switch (indexPath.row) {
    case 0:{
      CellIdentifier = @"Search";
    }
      break;
    default:
      CellIdentifier = @"Cell";
      break;
  }

  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    switch (indexPath.row) {
      case 0:{
        [cell addSubview:_searchBar];
        cell.backgroundColor = UIColor.grayColor;
        break;
      }
      case 1:{
        cell.textLabel.text = @"Create New Page";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
      }
      case 2:{
        cell.textLabel.text = @"My Pages";
        break;
      }
      case 3:{
        cell.textLabel.text = @"Following";
        break;
      }
      case 4:{
        cell.textLabel.text = @"Popular";
        break;
      }
      case 5:{
        cell.textLabel.text = @"Notifications";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
      }
      default:
        cell.textLabel.text = @"Hi";
        break;
    }
  }
   return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        //Search
      case 0:{
        break;
      }
        //Create New Page
      case 1:{
        if (self.delegate) {
          [self.delegate bookmarkViewWasDismissed:-1];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //My Pages
      case 2:{
        if (self.delegate) {
          [self.delegate bookmarkViewWasDismissed:1];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Following
      case 3:{
        if (self.delegate) {
          [self.delegate bookmarkViewWasDismissed:2];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Popular
      case 4:{
        if (self.delegate) {
          [self.delegate bookmarkViewWasDismissed:0];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Notifications
      case 5:{
//          [self.navigationController pushViewController:notificationViewController animated:NO];
//          CATransition *animationOut = [CATransition animation];
//          [animationOut setDelegate:self];
//          [animationOut setType:kCATransitionPush];
//          [animationOut setSubtype:kCATransitionFromRight];
//          [animationOut setDuration:0.4f];
//          [animationOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//          [self.view.layer addAnimation:animationOut forKey:nil];
//          
//          CATransition *animationIn = [CATransition animation];
//          [animationIn setDelegate:self];
//          [animationIn setType:kCATransitionPush];
//          [animationIn setSubtype:kCATransitionFromRight];
//          [animationIn setDuration:0.4f];
//          [animationIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//          [self.navigationController.view.layer addAnimation:animationIn forKey:nil];
//          [[self view] addSubview:notificationViewController.navigationController.view];
        break;
      }
      default:
        break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark
#pragma mark UISearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [_searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
  [_searchBar setShowsCancelButton:YES animated:YES];
  return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
  [_searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
  return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [_searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
}
@end
