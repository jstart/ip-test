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
-(void)didPushCreateButton:(id)sender;

@end

@interface IPListViewController : UITableViewController

@property (nonatomic, strong) PFObject * pageObject;
@property (strong, nonatomic) IBOutlet UITableViewCell *createHeaderTableViewCell;
@property (strong, nonatomic) id <IPListViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * objects;

- (IBAction)addItemButton:(id)sender;
- (void)updatedResultObjects:(NSMutableArray*)newObjects;
@end
