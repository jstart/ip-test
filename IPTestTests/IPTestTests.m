//
//  IPTestTests.m
//  IPTestTests
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPTestTests.h"
@implementation IPTestTests

@synthesize pageManager;

- (void)setUp
{
    [super setUp];
    [Parse setApplicationId:@"Sw86jP5zMknD2Gp52hXMUH6cLoBq5YpzIR5SYWlW"
                  clientKey:@"XaM7srV5NdkbOEWXjXzFvFjXLD7w2YzAimdo0m27"];
    
    // Set-up code here.
    NSArray * objects = [[PFQuery queryWithClassName:@"Page"] findObjects];
    PFObject * pageObject = [objects objectAtIndex:0];
    NSLog(@"Before %@", pageObject);
    
    self.pageManager = [[IPParseObjectManager sharedInstance]  pageManagerForObject:pageObject];
    self.pageManager.delegate = self;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    [pageManager refresh];
        sleep(1);
    [pageManager inviteUser:[PFUser currentUser]];
        sleep(1);
    [pageManager inviteUsers:[NSArray arrayWithObject:[PFUser currentUser]]];
        sleep(1);
    [pageManager addToCurrentUserFollowing];
        sleep(1);
    [pageManager submitRankings:nil];
        sleep(1);
    [pageManager computeGlobalRanking];
        sleep(1);
    [pageManager addItem:nil];
        sleep(1);
    PFObject * object = [[PFQuery queryWithClassName:@"Item"] getFirstObject];
    [pageManager retrieveRanksForItems:[NSArray arrayWithObject:object]];
    sleep(10);

    STAssertNotNil(object, @"Unit tests are not implemented yet in IPTestTests");
}

-(void)didFinishRefreshing{
    NSLog(@"didFinishRefreshing");
}

-(void)didInviteUser{
    NSLog(@"didInviteUser");
}

-(void)didAddCurrentUserToFollowing{
    NSLog(@"didAddCurrentUserToFollowing");
}

-(void)didSubmitRankings{
    NSLog(@"didSubmitRankings");
}

-(void)didComputeGlobalRanking{
    NSLog(@"didComputeGlobalRanking");
}

-(void)didAddItem{
    NSLog(@"didAddItem");
}

-(void)didRetrieveRankingForItems:(NSDictionary*)rankingDictionary{
    NSLog(@"didRetrieveRankingForItems: %@", rankingDictionary);
}

@end
