//
//  IPInviteFriendToPageViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPInviteFriendToPageViewController.h"

@interface IPInviteFriendToPageViewController ()

@end

@implementation IPInviteFriendToPageViewController

@synthesize queue, usersArray, selectedUsersArray, pageObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.queue = [[NSOperationQueue alloc] init];
        self.usersArray = [[NSMutableArray alloc] init];
        self.selectedUsersArray = [[NSMutableArray alloc] init];
        UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIBarButtonItem * inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleDone target:self action:@selector(pushInviteToSelectedUsers)];
        self.navigationItem.rightBarButtonItem = inviteButton;
        self.title = @"Invite Friends";
        [self.searchDisplayController.searchBar setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
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
    return [usersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if ([usersArray count] >= indexPath.row) {
        PFUser * user = ((PFUser *)[usersArray objectAtIndex:indexPath.row]);
        if ([self.selectedUsersArray containsObject:user]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = user.username;
    }else {
        cell.textLabel.text = @"No Results";
    }
    return cell;
}

//-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleInsert;
//}

-(void)userSearchRequestForString:(NSString*)searchQuery{
    PFQuery * query = [PFUser query];
    //    [query whereKey:@"username" notEqualTo:[[PFUser currentUser] objectForKey:@"username"]];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"username" matchesRegex:searchQuery modifiers:@"i"];
    
    NSMutableArray * array = [usersArray mutableCopy];
    for (PFUser * user in array) {
        if (![self.selectedUsersArray containsObject:user]) {
            [[self usersArray] removeObject:user];
        }
    }
    
    NSMutableArray * queryArray = [[query findObjects] mutableCopy];
    NSMutableArray * iterateArray = [queryArray mutableCopy];
    
    for (PFUser * user in iterateArray) {
        for (PFUser * selectedUser in self.selectedUsersArray) {
            if ([user.objectId isEqualToString:selectedUser.objectId]) {
                [queryArray removeObject:user];
            }
        }
    }
    

    [queryArray addObjectsFromArray:self.usersArray];
    self.usersArray = queryArray;
    [[self.searchDisplayController searchResultsTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    PFObject * user = [usersArray objectAtIndex:indexPath.row];

    if ([self.selectedUsersArray containsObject:user]) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsersArray removeObject:user];

    }else{
        [self.selectedUsersArray addObject:user];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

-(void)pushInviteToSelectedUsers{
    //Push a notification to the user
    for (PFUser * user in self.selectedUsersArray) {
        NSString * inviteText = [NSString stringWithFormat:@"%@ invited you to the page %@", [PFUser currentUser].username, [pageObject objectForKey:@"Title"]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Invite", @"Type",
                              inviteText, @"alert",
                              [NSNumber numberWithInt:1], @"badge",
                              pageObject.objectId, @"pageObjectId",
                              nil];
        NSString * channelName = [NSString stringWithFormat:@"UserChannel_%@", user.objectId];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:channelName];
        [push setPushToAndroid:NO];
        [push setPushToIOS:YES];
        [push setData:data];
        [push sendPushInBackground];
    }
    
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
    self.usersArray = self.selectedUsersArray;
    [[self tableView] reloadData];
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
  [self userSearchRequestForString:controller.searchBar.text];
  return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
  return YES;
}
#pragma UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar    {
    [[self searchDisplayController] setActive:NO animated:YES];
}

// called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [[self searchDisplayController] setActive:NO animated:YES];
}
@end
