//
//  IPBookmarkViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPBookmarkHeaderViewController.h"
#import "IPNotificationListViewController.h"

@protocol IPBookmarkViewDelegate <NSObject>

-(void)bookmarkViewWasDismissed:(int)homePageIndex;

@end

@interface IPBookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
  UISearchBar * _searchBar;
}

@property (strong, nonatomic) id <IPBookmarkViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IPBookmarkHeaderViewController * headerViewController;
@property (strong, nonatomic) UISearchBar * searchBar;
@property (strong, nonatomic) IPNotificationListViewController * notificationViewController;

- (IBAction)closeButton:(id)sender;

@end

