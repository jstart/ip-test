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
#import "IPParseObjectManager.h"
@protocol IPListViewDelegate <NSObject>

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)didPushCreateButton:(id)sender;
-(void)didPushInviteButton:(id)sender;
-(void)didRequestRefresh;

@end

@interface IPListViewController : UITableViewController

@property (nonatomic, strong) PFObject * pageObject;
@property (strong, nonatomic) IBOutlet UITableViewCell *createHeaderTableViewCell;
@property (strong, nonatomic) id <IPListViewDelegate> delegate;
@property (strong, atomic) NSMutableArray * objects;
@property (strong, nonatomic) NSNumber * listTypeIndex;
@property (strong, nonatomic) NSNumber * isRankLoaded;
@property (strong, nonatomic) NSOperationQueue * queue;
@property (strong, nonatomic) NSMutableDictionary * rankingDictionary;

@property (weak, nonatomic) IPPageManager * pageManager;

- (IBAction)addItemButton:(id)sender;
- (IBAction)inviteFriendButtonPressed:(id)sender;
- (void)updatedResultObjects:(NSMutableArray*)newObjects;
-(void)retrievedRanks:(NSMutableDictionary *)ranks;
-(void)didSubmitRankingSuccessfully;
-(void)didComputeGlobalRanking;

@end
