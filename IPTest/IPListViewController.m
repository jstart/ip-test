//
//  IPListViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPListViewController.h"

@interface IPListViewController ()

@end

@implementation IPListViewController

@synthesize pageObject;
@synthesize createHeaderTableViewCell;
@synthesize segmentedControl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    self.className = @"Item";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
      
    [self.navigationItem setTitleView:self.segmentedControl];
    //HAX
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIBarButtonItem *spacerButton = [[UIBarButtonItem alloc] 
                                   initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = spacerButton;  

    [super viewDidLoad];
  
    [self.tableView setTableHeaderView:self.createHeaderTableViewCell];

    self.title = [self.pageObject objectForKey:@"Title"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(customBackAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidUnload
{
  [self setCreateHeaderTableViewCell:nil];
  [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)customBackAction:(id)sender{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.4f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionPush;
  transition.subtype = kCATransitionFromBottom;
  transition.delegate = self;
  [self.navigationController.view.layer addAnimation:transition forKey:nil];
  self.navigationController.navigationBarHidden = NO;
  [self.navigationController popToRootViewControllerAnimated:NO];
}

- (PFQuery *)queryForTable{
  PFQuery *query = [PFQuery queryWithClassName:self.className];
  [query whereKey:@"Parent_Page" equalTo:pageObject];
  
  // If no objects are loaded in memory, we look to the cache 
  // first to fill the table and then subsequently do a query
  // against the network.
  if ([self.objects count] == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  }
  
  [query orderByDescending:@"createdAt"];
  
  return query;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return 5;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [object objectForKey:@"Title"];
  
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)addItemButton:(id)sender {
  IPAddListItemViewController * addListItemVC = [[IPAddListItemViewController alloc] initWithNibName:@"IPAddListItemViewController" bundle:[NSBundle mainBundle]];
  [addListItemVC setPageObject:pageObject];
  UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:addListItemVC];

  [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)changeSegment:(id)sender {
  UISegmentedControl * segControl = (UISegmentedControl *) sender;
  switch (segControl.selectedSegmentIndex) {
    case 0:
      [self.tableView setHidden:NO];
      [self.tableView setUserInteractionEnabled:YES];

      break;
    case 1:
      [self.tableView setHidden:YES];
      [self.tableView setUserInteractionEnabled:NO];

      break;
      
    default:
      break;
  }
}

@end
