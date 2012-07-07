//
//  IPMyPagesViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface IPMyPagesViewController : PFQueryTableViewController

@property (nonatomic, strong) IBOutlet UITableViewCell * headerCell;
- (IBAction)createButtonPressed:(id)sender;


@end
