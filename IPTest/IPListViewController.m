//
//  IPListViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPListViewController.h"
#import "SVPullToRefresh.h"

@interface IPListViewController ()

@end

@implementation IPListViewController

@synthesize pageObject;
@synthesize delegate;
@synthesize createHeaderTableViewCell;
@synthesize objects = _objects;
@synthesize listTypeIndex;
@synthesize isRankLoaded;
@synthesize queue;
@synthesize rankingDictionary = _rankingDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad
{
//    self.className = @"Item";
//    self.pullToRefreshEnabled = YES;
//    self.paginationEnabled = YES;
//    self.objectsPerPage = 25;
    self.isRankLoaded = [NSNumber numberWithBool:NO];
    self.queue = [[NSOperationQueue alloc] init];
    [self.queue setMaxConcurrentOperationCount:1];
    [super viewDidLoad];
  
    [self.tableView setTableHeaderView:self.createHeaderTableViewCell];

    self.title = [self.pageObject objectForKey:@"Title"];
    self.listTypeIndex = [pageObject objectForKey:@"listType"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([listTypeIndex intValue] == 1) {
        [[self tableView] setAllowsSelectionDuringEditing:YES];
        [self.tableView setEditing:YES animated:YES];
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self.delegate selector:@selector(didRequestRefresh) name:@"RankingPush" object:nil];
    [[self tableView] addPullToRefreshWithActionHandler:^{
        // refresh data
        // call [tableView.pullToRefreshView stopAnimating] when done
        [self.delegate didRequestRefresh];
    }];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCreateHeaderTableViewCell:nil];
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

-(void)updatedResultObjects:(NSMutableArray*)newObjects{
    [[self tableView] beginUpdates];
  self.objects = newObjects;
    IPRetrieveRankOperation * op = [[IPRetrieveRankOperation alloc] initWithItems:self.objects pageObject:self.pageObject];
  op.delegate = self;
  [self.queue addOperation:op];
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [self.tableView.pullToRefreshView stopAnimating];
}

-(void)retrievedRanks:(NSMutableDictionary *)ranks{
    self.rankingDictionary = ranks;
    self.isRankLoaded = [NSNumber numberWithBool:YES];
//    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [[self tableView] endUpdates];
    }];
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
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row  < [self.objects count]) {
        PFObject * object = [self.objects objectAtIndex:indexPath.row];
        [object fetchIfNeeded];
        if ([listTypeIndex intValue] == 1) {
            cell.showsReorderControl = YES;
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[NSString stringWithFormat:@"%d. ", indexPath.row + 1] stringByAppendingString:[object objectForKey:@"Title"]];
            if ([self.rankingDictionary objectForKey:object.objectId]) {
                NSNumber * position = [[self.rankingDictionary objectForKey:object.objectId] objectForKey:@"position"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"You ranked: %d", [position intValue]];
            }
        }else{
            cell.textLabel.text = [object objectForKey:@"Title"];
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([self.isRankLoaded boolValue]) {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.

    return UITableViewCellEditingStyleNone;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    PFObject *movingObject = [self.objects objectAtIndex:fromIndexPath.row];
	[self.objects removeObject:movingObject];
	[self.objects insertObject:movingObject atIndex:toIndexPath.row];
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:fromIndexPath];
    [array addObject:toIndexPath];
//    [[self tableView] reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];

    [self.queue addOperationWithBlock:^(){
        int count = 0;
        for (PFObject * object in self.objects) {
            PFObject * ranking = nil;
            if ([self.rankingDictionary objectForKey:object.objectId]) {
                ranking = [self.rankingDictionary objectForKey:object.objectId];
            }else {
                ranking = [PFObject objectWithClassName:@"Ranking"];
                NSLog(@"Creating new rank object for itemID:%@", object.objectId);
                [ranking setObject:object forKey:@"Parent_Item"];
                [ranking setObject:self.pageObject forKey:@"Parent_Page"];
                [ranking setObject:[PFUser currentUser] forKey:@"Parent_User"];
                [ranking save];
                [self.pageObject addObject:ranking forKey:@"Rankings"];
                [self.pageObject save];
            }   
            [ranking setValue:[NSNumber numberWithInt:count+1] forKey:@"position"];
            BOOL succeeded = [ranking save];

            if (succeeded) {
                [self.queue addOperationWithBlock:^(){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                });
                }];
            }
            count++;
        }
        IPAveragePageRankOperation * avOP = [[IPAveragePageRankOperation alloc] initWithPage:self.pageObject];
        avOP.delegate = (id<IPAveragePageRankDelegate>)self.delegate;
        [self.queue addOperation:avOP];
    }];
    NSString * rankText = [NSString stringWithFormat:@"%@ submitted a ranking to the page %@", [PFUser currentUser].username, [pageObject objectForKey:@"Title"]];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Ranking", @"Type",
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
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


//- (PFQuery *)queryForTable {
//    PFQuery * query = nil;
//    return query;
//}

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
    if (delegate != nil) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
     }else{
         NSLog(@"No Delegate for List View");
     }
}

- (IBAction)addItemButton:(id)sender {
    [self.delegate didPushCreateButton:sender];
}

@end
