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
    self.notificationViewController = [[IPNotificationListViewController alloc] initWithNibName:@"IPNotificationListViewController" bundle:[NSBundle mainBundle]];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.contentMode = UIViewContentModeScaleToFill;
//    self.bookmarkTableView.layer.cornerRadius = 1;
//    self.bookmarkTableView.layer.borderColor = UIColor.blackColor.CGColor;
//    self.bookmarkTableView.layer.borderWidth = 1;
//    self.bookmarkTableView.layer.masksToBounds = YES;
//    self.bookmarkTableView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
//    self.bookmarkTableView.layer.shouldRasterize = YES;
//    self.closeButton.layer.rasterizationScale = [[UIScreen mainScreen] scale]; 
//    self.closeButton.layer.shouldRasterize = YES;
//    self.closeButton.layer.masksToBounds = YES;
      // Do any additional setup after loading the view from its nib.
    
    self.headerViewController = [[IPBookmarkHeaderViewController alloc] initWithNibName:@"IPBookmarkHeaderViewController" bundle:[NSBundle mainBundle]];
//    self.headerViewController.view.layer.cornerRadius = 10;
//    self.headerViewController.view.layer.shadowOffset = CGSizeMake(0, 4);
//    self.headerViewController.view.layer.shadowColor = UIColor.blackColor.CGColor;
//    self.headerViewController.view.layer.shadowRadius = 10;
//    self.headerViewController.view.layer.shadowOpacity = 0.5;
//    self.headerViewController.view.layer.shouldRasterize = YES;
//    self.headerViewController.view.layer.borderColor = UIColor.blackColor.CGColor;
//    self.headerViewController.view.layer.borderWidth = 0.5f;
//    self.headerViewController.view.layer.masksToBounds = YES;
    [self.bookmarkTableView setTableHeaderView:self.headerViewController.view];
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
  NSLog(@"%@", NSStringFromCGRect(self.bookmarkTableView.frame));
  //HAX
  [((IPTestView*)self.view) setHasBeenAdjusted:YES];
  CGRect frame = self.closeButton.frame;
  frame.origin.y = self.bookmarkTableView.frame.size.height;
  self.closeButton.frame = frame;
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

//        [[self view] addSubview:notificationViewController.view];
        break;
      }
      default:
        break;
    }
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
