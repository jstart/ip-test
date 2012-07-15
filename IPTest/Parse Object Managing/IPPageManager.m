//
//  IPPageManager.m
//  IPTest
//
//  Created by Truman, Christopher on 7/14/12.
//
//

#import "IPPageManager.h"

@implementation IPPageManager

@synthesize pageObject = _pageObject;
@synthesize queue = _queue;
@synthesize delegate = _delegate;

+(IPPageManager*)pageManagerForPageObject:(PFObject*)pageObject{
    IPPageManager * pageManager = [[IPPageManager alloc] init];
    [pageManager setPageObject:pageObject];
    return pageManager;
}

-(id)init{
    if (self = [super init]) {
        self.queue = [[NSOperationQueue alloc] init];
        [self.queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(void)refresh{
    [self.queue addOperationWithBlock:^(){
        NSError * error = nil;
        [self.pageObject refresh:&error];
        if (error) {
            NSLog(@"Refresh page error for page %@ and error description %@", self.pageObject.objectId, error);
        }else{
            [self.queue addOperationWithBlock:^(){
                [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didFinishRefreshing) withObject:nil waitUntilDone:NO];
            }];
        }
    }];
}

-(void)inviteUser:(PFUser*) user{
    [self.queue addOperationWithBlock:^(){
        NSString * inviteText = [NSString stringWithFormat:@"%@ invited you to the page %@", [PFUser currentUser].username, [self.pageObject objectForKey:@"Title"]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Invite", @"Type",
                              inviteText, @"alert",
                              [NSNumber numberWithInt:1], @"badge",
                              self.pageObject.objectId, @"pageObjectId",
                              nil];
        NSString * channelName = [NSString stringWithFormat:@"UserChannel_%@", user.objectId];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:channelName];
        [push setPushToAndroid:NO];
        [push setPushToIOS:YES];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
            if (error) {
                NSLog(@"Invite page error for page %@ and user name: %@ id: %@ and error description %@", self.pageObject.objectId,user.username, user.objectId, error);
            }else{
                [self.queue addOperationWithBlock:^(){
                    [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didInviteUser) withObject:nil waitUntilDone:NO];
                }];
            }
        }];
     }];
}

-(void)inviteUsers:(NSArray*)users{
    [self.queue addOperationWithBlock:^(){
        for (PFUser * user in users) {
            NSString * inviteText = [NSString stringWithFormat:@"%@ invited you to the page %@", [PFUser currentUser].username, [self.pageObject objectForKey:@"Title"]];
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Invite", @"Type",
                                  inviteText, @"alert",
                                  [NSNumber numberWithInt:1], @"badge",
                                  self.pageObject.objectId, @"pageObjectId",
                                  nil];
            NSString * channelName = [NSString stringWithFormat:@"UserChannel_%@", user.objectId];
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:channelName];
            [push setPushToAndroid:NO];
            [push setPushToIOS:YES];
            [push setData:data];
            [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                if (error) {
                    NSLog(@"Invite page error for page %@ and user name: %@ id: %@ and error description %@", self.pageObject.objectId,user.username, user.objectId, error);
                }else{
                    [self.queue addOperationWithBlock:^(){
                        [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didInviteUser) withObject:nil waitUntilDone:NO];
                    }];
                }
            }];
        }
    }];
}

-(void)addToCurrentUserFollowing{
    [self.queue addOperationWithBlock:^(){
        [[PFUser currentUser] addObject:self.pageObject forKey:@"following"];
        NSError * error = nil;
        [[PFUser currentUser] save:&error];
        if (error) {
            NSLog(@"Accept Invite page error for page %@ and error description %@", self.pageObject.objectId, error);
        }else{
            PFRelation * followersRelation = [self.pageObject relationforKey:@"Followers"];
            [followersRelation addObject:[PFUser currentUser]];
            [self.pageObject save:&error];
            if (error) {
                NSLog(@"Accept Invite page error for page %@ and error description %@", self.pageObject.objectId, error);
            }else{
                [self.queue addOperationWithBlock:^(){
                    [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didAddCurrentUserToFollowing) withObject:nil waitUntilDone:NO];
                }];
            }
        }
    }];
}

-(void)submitRankings:(NSArray*)rankingsArray{
    NSArray * blockRankingsArray = [rankingsArray copy];
    [self.queue addOperationWithBlock:^(){
        NSError * error = nil;
        [PFObject saveAll:blockRankingsArray error:&error];
        if (error) {
            NSLog(@"Submit ranking to page error for page %@ and error description %@", self.pageObject.objectId, error);
        }else{
            [self.pageObject addUniqueObjectsFromArray:blockRankingsArray forKey:@"Rankings"];
            [self.pageObject save:&error];
            if (error) {
                NSLog(@"Submit ranking to page error for page %@ and error description %@", self.pageObject.objectId, error);
            }else{
                [self.queue addOperationWithBlock:^(){
                    [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didSubmitRankings) withObject:nil waitUntilDone:NO];
                }];
            }
        }
    }];
}

-(void)computeGlobalRanking{
    NSArray * objects = [self.pageObject objectForKey:@"Rankings"];

    [self.queue addOperationWithBlock:^(){
        NSError * error = nil;
        
        [self.pageObject refresh:&error];
        if (error) {
            NSLog(@"Page refresh error for page %@ and error: %@", self.pageObject.objectId, error);
        }

        NSMutableDictionary * itemsDictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * itemsAverageRankingDictionary = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary * itemIDDictionary = [NSMutableDictionary dictionary];
        
        for (PFObject * object in objects) {
            [object fetchIfNeeded];
            PFObject * parentItem = ((PFObject*)[object objectForKey:@"Parent_Item"]);
            [itemIDDictionary setObject:parentItem forKey:parentItem.objectId];
            NSMutableArray * array = [itemsDictionary objectForKey:parentItem.objectId];
            if (array == nil){
                array = [[NSMutableArray alloc] init];
            }
            [array addObject:object];
            [itemsDictionary setObject:array forKey:parentItem.objectId];
        }
        if (error) {
            NSLog(@"Computing global ranking for page %@ and error: %@", self.pageObject.objectId, error);
        }
        else{
            NSMutableArray * globalRankingArray = [NSMutableArray array];
            for (NSString * key in [itemsDictionary allKeys]) {
                NSArray * rankings = [itemsDictionary objectForKey:key];
                int average = 0;
                for (PFObject* rank in rankings) {
                    NSNumber * position = [rank objectForKey:@"position"];
                    average += [position intValue];
                    
                }
                NSLog(@"Key: %@ total %d average: %d/%d = %d",key, average, average, [rankings count], average/[rankings count]);
                [itemsAverageRankingDictionary setObject:[NSNumber numberWithInt:average] forKey:key];
                PFObject* globalRankingObject = nil;
                
                for (PFObject * globalRankingObjectIterated in [self.pageObject objectForKey:@"Global_Rankings"]) {
                    [globalRankingObjectIterated fetchIfNeeded:&error];
                    if (error) {
                        NSLog(@"Global ranking error %@", error);
                    }
                    if ([((PFObject*)[globalRankingObjectIterated objectForKey:@"Parent_Item"]).objectId isEqualToString:key]) {
                        globalRankingObject = globalRankingObjectIterated;
                    }
                }
                
                
                if (globalRankingObject == nil) {
                    PFObject * newGlobalRanking = [PFObject objectWithClassName:@"GlobalRanking"];
                    [newGlobalRanking setObject:[itemIDDictionary objectForKey:key] forKey:@"Parent_Item"];
                    [newGlobalRanking setObject:self.pageObject forKey:@"Parent_Page"];
                    [newGlobalRanking setValue:[NSNumber numberWithInt:average] forKey:@"position"];
                    [newGlobalRanking save:&error];
                    if (error) {
                        NSLog(@"Error create new global ranking object %@", error);
                    }
                    [self.pageObject addObject:newGlobalRanking forKey:@"Global_Rankings"];
                }
                else{
                    [globalRankingObject setValue:[NSNumber numberWithInt:average] forKey:@"position"];
                    [globalRankingArray addObject:globalRankingObject];
                }
            }
            [PFObject saveAll:globalRankingArray error:&error];
                if (error) {
                    NSLog(@"Computing global ranking for page %@ and error: %@", self.pageObject.objectId, error);
                }else{
                    [self.pageObject save:&error];
                    if (error) {
                        NSLog(@"Computing global ranking for page %@ and error: %@", self.pageObject.objectId, error);
                    }else{
                        [self.queue addOperationWithBlock:^(){
                            [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didComputeGlobalRanking) withObject:nil waitUntilDone:NO];
                        }];
                    }
                }
            }
    }];
}

-(void)addItem:(PFObject*)item{
    if (item) {
        [self.queue addOperationWithBlock:^(){
            NSError * error = nil;
            [item save:&error];
            if (error) {
                NSLog(@"Create item to page error for item %@ and error description %@", item.objectId, error);
            }else{
                [self.pageObject addObject:item forKey:@"Items"];
                [self.pageObject save:&error];
                if (error) {
                    NSLog(@"Add item %@ to page error for page %@ and error description %@", item.objectId, self.pageObject.objectId, error);
                }
                else{
                    [self.queue addOperationWithBlock:^(){
                        [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didAddItem) withObject:nil waitUntilDone:NO];
                    }];
                }
            }
        }];
    }
}

-(void)retrieveRanksForItems:(NSArray*)itemsArray{
    [self.queue addOperationWithBlock:^(){
        NSMutableDictionary * rankingDictionary = [NSMutableDictionary dictionary];
        for (PFObject * itemObject in itemsArray) {        
            PFQuery * query = [PFQuery queryWithClassName:@"Ranking"];
            [query whereKey:@"Parent_Item" equalTo:itemObject];
            [query whereKey:@"Parent_Page" equalTo:self.pageObject];
            PFQuery * innerQuery = [PFUser query];
            [innerQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
            [query whereKey:@"Parent_User" matchesQuery:innerQuery];
            [query setCachePolicy:kPFCachePolicyNetworkElseCache];
            PFObject * object = [query getFirstObject];
            if (object) {
                [rankingDictionary setObject:object forKey:itemObject.objectId];
            }
        }
        [self.queue addOperationWithBlock:^(){
            [((NSObject*)[self delegate]) performSelectorOnMainThread:@selector(didRetrieveRankingForItems:) withObject:rankingDictionary waitUntilDone:NO];
        }];
    }];
}

@end
