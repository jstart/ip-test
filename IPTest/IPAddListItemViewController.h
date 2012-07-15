//
//  IPAddListItemViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "IPParseObjectManager.h"

@interface IPAddListItemViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSOperationQueue * queue;
@property (nonatomic, strong) NSMutableArray * placesArray;
@property (nonatomic, strong) PFObject * pageObject;

-(void)citygridSearchRequestForString:(NSString*)searchQuery;

@end
