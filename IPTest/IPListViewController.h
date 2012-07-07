//
//  IPListViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "IPAddListItemViewController.h"

@interface IPListViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject * pageObject;
@property (strong, nonatomic) IBOutlet UITableViewCell *createHeaderTableViewCell;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)addItemButton:(id)sender;
- (IBAction)changeSegment:(id)sender;

@end
