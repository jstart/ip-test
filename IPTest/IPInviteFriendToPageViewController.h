//
//  IPInviteFriendToPageViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPParseObjectManager.h"

@interface IPInviteFriendToPageViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSOperationQueue * queue;
@property (nonatomic, strong) NSMutableArray * usersArray;
@property (nonatomic, strong) PFObject * pageObject;
@property (nonatomic, strong) NSMutableArray * selectedUsersArray;

-(void)userSearchRequestForString:(NSString*)searchQuery;

@end
