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

@protocol IPListViewDelegate <NSObject>

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface IPListViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject * pageObject;
@property (strong, nonatomic) IBOutlet UITableViewCell *createHeaderTableViewCell;
@property (strong, nonatomic) id <IPListViewDelegate> delegate;

- (IBAction)addItemButton:(id)sender;
- (void)updatedResultObjects:(NSMutableArray*)newObjects;
@end
