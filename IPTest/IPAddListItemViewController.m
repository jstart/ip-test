//
//  IPAddListItemViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPAddListItemViewController.h"
#import "IPSegmentContainerViewController.h"
#import <CityGrid/CityGrid.h>

@interface IPAddListItemViewController ()

@end

@implementation IPAddListItemViewController

@synthesize queue, placesArray, pageObject;

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
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    self.placesArray = [[NSMutableArray alloc] init];
    UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.title = @"Add Item";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
	
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

-(void)cancelPressed{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if ([placesArray count] >= indexPath.row) {
        cell.textLabel.text = ((CGPlacesSearchLocation *)[placesArray objectAtIndex:indexPath.row]).name;
    }else {
        cell.textLabel.text = @"No Results";
    }
    return cell;
}

-(void)citygridSearchRequestForString:(NSString*)searchQuery{
  [self.queue addOperationWithBlock:^{
		CGPlacesSearch* search = [CityGrid placesSearch];
		search.type = CGPlacesSearchTypeRestaurant;
		search.radius = 20.0;
		search.resultsPerPage = 20;
		search.what = searchQuery;
    search.where = @"Los Angeles, CA";
    
		NSArray* errors = nil;
		NSArray* tmpPlaces = [search search:&errors].locations;
		if ([errors count] > 0) {
			NSError* first = [errors objectAtIndex:0];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:first.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alert show];
			}];
		} else {
			self.placesArray = [tmpPlaces mutableCopy];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[self.searchDisplayController searchResultsTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
			}];
		}
  }];

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
  
    PFObject * object = [PFObject objectWithClassName:@"Item"];
    CGPlacesSearchLocation * location = [placesArray objectAtIndex:indexPath.row];
    [object setValue:location.name forKey:@"Title"];
    NSNumber * locationIDNumber = [NSNumber numberWithInt:location.locationId];
    [object setValue:locationIDNumber forKey:@"cg_id"];
    [[[IPParseObjectManager sharedInstance] pageManagerForObject:self.pageObject] addItem:object];
    
    NSString * rankText = [NSString stringWithFormat:@"%@ added a business name %@ to the page %@", [PFUser currentUser].username, [object objectForKey:@"Title"], [pageObject objectForKey:@"Title"]];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"AddItem", @"Type",
                          rankText, @"alert",
                          [NSNumber numberWithInt:1], @"badge",
                          pageObject.objectId, @"pageObjectId",
                          nil];
    NSString * channelName = [NSString stringWithFormat:@"PageChannel_%@", pageObject.objectId];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:channelName];
    [push setPushToAndroid:NO];
    [push setPushToIOS:YES];
    [push setData:data];
    [push sendPushInBackground];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
}

// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView{
}

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{

}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
  
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
  
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
  
}

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
  [self citygridSearchRequestForString:controller.searchBar.text];
  return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
  return YES;
}

@end
