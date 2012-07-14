//
//  IPPageManager.h
//  IPTest
//
//  Created by Truman, Christopher on 7/14/12.
//
//

#import <Foundation/Foundation.h>

@protocol IPPageManagerDelegate <NSObject>

-(void)didFinishRefreshing;
-(void)didInviteUser;
-(void)didAddCurrentUserToFollowing;
-(void)didSubmitRankings;
-(void)didComputeGlobalRanking;
-(void)didAddItem;
-(void)didRetrieveRankingForItems:(NSDictionary*)rankingDictionary;

@end

@interface IPPageManager : NSObject

@property (nonatomic, weak) PFObject * pageObject;
@property (nonatomic, strong) NSOperationQueue * queue;
@property (nonatomic, strong) id<IPPageManagerDelegate> delegate;

+(IPPageManager*)pageManagerForPageObject:(PFObject*)pageObject;

-(void)refresh;
-(void)inviteUser:(PFUser*) user;
-(void)inviteUsers:(NSArray*)users;
-(void)addToCurrentUserFollowing;
-(void)submitRankings:(NSArray*)rankingsArray;
-(void)computeGlobalRanking;
-(void)addItem:(PFObject*)item;
-(void)retrieveRanksForItems:(NSArray*)itemsArray;

@end
