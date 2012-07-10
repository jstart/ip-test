//
//  IPInviteFriendToPageViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface IPInviteFriendToPageViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSOperationQueue * queue;
@property (nonatomic, strong) NSMutableArray * usersArray;

-(void)userSearchRequestForString:(NSString*)searchQuery;

@end
